#!/bin/bash
#part1
set -euo pipefail
printf '\033c'

install_started=0
cleanup_on_error() {
    local status=$?
    (( status == 0 || install_started == 0 )) && return

    if [[ -n "${swappartition:-}" ]] && \
        swapon --show=NAME --noheadings 2>/dev/null | grep -Fxq "$swappartition"; then
        swapoff "$swappartition" || true
    fi
    if findmnt -M /mnt >/dev/null 2>&1; then
        umount -R /mnt || true
    fi
}
trap cleanup_on_error EXIT

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }
confirm() { dialog --backtitle "Arch Install" --yesno "$1" 0 0; }
input_box() { dialog --backtitle "Arch Install" --inputbox "$1" 0 0 "${2:-}" 3>&1 1>&2 2>&3; }

is_partition_on_drive() {
    local device="$1"
    [[ -b "$device" ]] && [[ "$(lsblk -dnro TYPE "$device")" == "part" ]] && \
        lsblk -nrpo NAME "$drive" | grep -Fxq -- "$device"
}

validate_target_layout() {
    local device
    local -a targets=("$partition" "$efipartition")

    [[ $want_home -eq 1 ]] && targets+=("$homepartition")
    [[ $want_swap -eq 1 ]] && targets+=("$swappartition")

    for device in "${targets[@]}"; do
        is_partition_on_drive "$device" || {
            echo "$device is not a partition on $drive" >&2
            return 1
        }
        findmnt -rn -S "$device" >/dev/null && {
            echo "$device is currently mounted" >&2
            return 1
        }
    done

    [[ $(printf '%s\n' "${targets[@]}" | sort -u | wc -l) -eq ${#targets[@]} ]] || {
        echo "Root, EFI, home, and swap must all be different partitions" >&2
        return 1
    }
}

# run_step "description" [--core] cmd args...
# Runs cmd; on failure, offers retry/skip/abort via dialog (no "skip" for --core steps).
run_step() {
    local desc="$1"; shift
    local allow_skip=1
    if [[ "$1" == "--core" ]]; then
        allow_skip=0
        shift
    fi
    while true; do
        "$@" && return 0
        local choice
        if [[ $allow_skip -eq 1 ]]; then
            choice=$(dialog --backtitle "Arch Install" --menu "\"$desc\" failed." 0 0 3 \
                retry "Try again" \
                skip  "Skip this step and continue" \
                abort "Abort the installation" \
                3>&1 1>&2 2>&3) || choice="abort"
        else
            choice=$(dialog --backtitle "Arch Install" --menu "\"$desc\" failed. This step is required." 0 0 2 \
                retry "Try again" \
                abort "Abort the installation" \
                3>&1 1>&2 2>&3) || choice="abort"
        fi
        case "$choice" in
            retry) continue ;;
            skip) return 0 ;;
            *) clear; echo "Aborted at: $desc"; exit 1 ;;
        esac
    done
}

step "Stage 1/3: Partitioning & base install"

[[ -d /sys/firmware/efi/efivars ]] || { echo "Not booted in UEFI mode, aborting"; exit 1; }

step "Keyboard layout & clock"
loadkeys us
timedatectl set-ntp true
timedatectl

step "Network setup"
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
pacman --noconfirm -S networkmanager dialog
systemctl start NetworkManager
# Assumes a wired ethernet connection is already up (DHCP) for the pacman
# calls above. Use nmtui now to add/switch to Wi-Fi if needed.
nmtui

step "Mirror list"
reflector --country India --age 12 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
[[ -s /etc/pacman.d/mirrorlist ]] || { echo "reflector produced an empty mirrorlist"; exit 1; }

step "Installation choices"
## Gather every answer up front, before anything destructive runs.
lsblk

drive=$(input_box "Enter the drive to partition (e.g. /dev/sda):") || true
[[ -n "$drive" ]] || { echo "No drive given, aborting."; exit 1; }
[[ -b "$drive" && "$(lsblk -dnro TYPE "$drive")" == "disk" ]] || {
    echo "Target must be an existing whole-disk device (for example /dev/sda or /dev/nvme0n1)."
    exit 1
}
if lsblk -nrpo MOUNTPOINT "$drive" | grep -qv '^$'; then
    echo "$drive or one of its partitions is mounted; refusing to use it."
    exit 1
fi

kernel_choice=$(dialog --backtitle "Arch Install" --checklist \
    "Select one or more kernels. Multiple kernels use NVIDIA DKMS when NVIDIA is selected." 0 0 4 \
    linux          "Current stable kernel" on \
    linux-lts      "Long-term-support kernel" off \
    linux-zen      "Desktop/interactive tuned kernel" off \
    linux-hardened "Security-hardened kernel" off \
    3>&1 1>&2 2>&3) || true
[[ -n "$kernel_choice" ]] || { echo "Select at least one kernel, aborting."; exit 1; }

kernel_choice_unquoted=${kernel_choice//\"/}
read -r -a selected_kernels <<< "$kernel_choice_unquoted"
kernel_pkgs=()
for kernel in linux linux-lts linux-zen linux-hardened; do
    for selected_kernel in "${selected_kernels[@]}"; do
        [[ "$selected_kernel" == "$kernel" ]] || continue
        kernel_pkgs+=("$kernel" "${kernel}-headers")
        break
    done
done
kernel_count=$((${#kernel_pkgs[@]} / 2))

partition=$(input_box "Enter the partition to use as root (ext4, will be ERASED):") || true
[[ -n "$partition" ]] || { echo "No partition given, aborting."; exit 1; }

want_home=0
format_home=0
if confirm "Use a separate home partition?"; then
    want_home=1
    homepartition=$(input_box "Enter home partition:") || true
    [[ -n "$homepartition" ]] || { echo "No home partition given, aborting."; exit 1; }
    if confirm "Format home partition? (ERASES all data on it)"; then
        format_home=1
    fi
fi

want_new_efi=1
if confirm "Create a NEW efi partition? (ERASES it; choose No to reuse an existing one)"; then
    efipartition=$(input_box "Enter efi partition (will be formatted FAT32):") || true
else
    want_new_efi=0
    efipartition=$(input_box "Enter EXISTING efi partition to mount:") || true
fi
[[ -n "$efipartition" ]] || { echo "No efi partition given, aborting."; exit 1; }

want_swap=0
if confirm "Create a swap partition? (ERASES it)"; then
    want_swap=1
    swappartition=$(input_box "Enter swap partition:") || true
    [[ -n "$swappartition" ]] || { echo "No swap partition given, aborting."; exit 1; }
fi

username=$(input_box "Username for the new user account:") || true
[[ "$username" =~ ^[a-z_][a-z0-9_-]*\$?$ ]] || {
    echo "Username must contain only lowercase letters, digits, _, -, and optionally end with $."
    exit 1
}

hostname=$(input_box "Hostname for this machine:") || true
[[ "$hostname" =~ ^[A-Za-z0-9][A-Za-z0-9.-]*$ ]] || {
    echo "Hostname contains invalid characters."
    exit 1
}

login_method=$(dialog --backtitle "Arch Install" --radiolist \
    "Select login method (both are installed; this picks the active one):" 0 0 2 \
    greeter   "noctalia-greeter (password, unlocks keyring)" on \
    autologin "agetty autologin on tty1" off \
    3>&1 1>&2 2>&3) || login_method=greeter

pkg_choice=$(dialog --backtitle "Arch Install" --checklist \
    "Select optional package groups to install:" 0 0 7 \
    media "Media tools (mpv, zathura, ffmpeg, image viewer...)" on \
    dev   "Dev tools (nodejs, npm, python venv, lazygit...)" on \
    qtile "Qtile + X11 session (xorg, picom, xclip, i3lock...)" off \
    fallback "Non-Noctalia tools (waybar, dunst, rofimoji, polkit-gnome...)" on \
    testing "VM installer testing (QEMU + OVMF UEFI firmware)" off \
    android "Android Studio, SDK tools, and device rules" off \
    latex "LaTeX, Pandoc, and document tooling" off \
    3>&1 1>&2 2>&3) || true
install_media=0
install_dev=0
install_qtile=0
install_fallback=0
install_testing=0
install_android=0
install_latex=0
[[ "$pkg_choice" == *media* ]] && install_media=1
[[ "$pkg_choice" == *dev* ]] && install_dev=1
[[ "$pkg_choice" == *qtile* ]] && install_qtile=1
[[ "$pkg_choice" == *fallback* ]] && install_fallback=1
[[ "$pkg_choice" == *testing* ]] && install_testing=1
[[ "$pkg_choice" == *android* ]] && install_android=1
[[ "$pkg_choice" == *latex* ]] && install_latex=1

aur_choice=$(dialog --backtitle "Arch Install" --checklist \
    "Select optional AUR apps to install:" 0 0 5 \
    mongodb-compass "MongoDB Compass GUI" off \
    envycontrol     "GPU mode switcher (hybrid nvidia laptops)" on \
    github-tools    "GitHub CLI + Copilot CLI" on \
    claude-code     "Claude Code CLI" on \
    codex           "Codex CLI" on \
    3>&1 1>&2 2>&3) || true
clear

step "Package check"
# Catch renamed/removed packages before touching the disk
eval "$(sed -n '/^[a-z_]*_pkgs=($/,/^)$/p' "$0")"
pacman -Sp --noconfirm "${kernel_pkgs[@]}" "${core_pkgs[@]}" "${qtile_pkgs[@]}" "${fallback_pkgs[@]}" \
    "${media_pkgs[@]}" "${dev_pkgs[@]}" "${testing_pkgs[@]}" \
    nvidia-open nvidia-open-dkms "${nvidia_pkgs[@]}" >/dev/null ||
    { echo "Fix the package names above in arch_install.sh, aborting."; exit 1; }

step "Disk partitioning"
echo "About to open cgdisk on: $drive"
run_step "Partition editor (cgdisk)" --core cgdisk "$drive"

if ! validate_target_layout; then
    dialog --backtitle "Arch Install" --msgbox "Invalid target layout. Each selected target must be an unmounted partition on $drive, and all targets must differ. Re-run the installer after correcting the partition names/layout." 0 0
    exit 1
fi

plan=$(cat <<PLAN
Drive: $drive

Root partition: $partition (ext4, ERASED)
Home partition: $([[ $want_home -eq 1 ]] && echo "$homepartition (format: $([[ $format_home -eq 1 ]] && echo yes || echo no))" || echo "none (use root)")
EFI partition: $efipartition ($([[ $want_new_efi -eq 1 ]] && echo "NEW, formatted FAT32" || echo "existing, reused"))
Swap partition: $([[ $want_swap -eq 1 ]] && echo "$swappartition" || echo "none")

Username: $username
Hostname: $hostname
Login method: $login_method

Optional packages: $([[ $install_media -eq 1 ]] && echo -n "media ")$([[ $install_dev -eq 1 ]] && echo -n "dev ")$([[ $install_qtile -eq 1 ]] && echo -n "qtile ")$([[ $install_fallback -eq 1 ]] && echo -n "fallback ")$([[ $install_testing -eq 1 ]] && echo -n "testing ")$([[ $install_android -eq 1 ]] && echo -n "android ")$([[ $install_latex -eq 1 ]] && echo -n "latex ")
Kernels: $kernel_choice
Optional AUR apps: ${aur_choice:-none}
PLAN
)
if dialog --backtitle "Arch Install" --yesno "$plan

Proceed? This will ERASE the partitions listed above." 0 0; then
    clear
else
    clear
    echo "Aborted by user."
    exit 1
fi

install_started=1
echo "$partition -> formatting as ext4 and mounting at /mnt. This ERASES all data on $partition."
run_step "Format root partition" --core mkfs.ext4 "$partition"
mount "$partition" /mnt

if [[ $want_home -eq 1 ]]; then
    if [[ $format_home -eq 1 ]]; then
        run_step "Format home partition" --core mkfs.ext4 "$homepartition"
    fi
    mount --mkdir "$homepartition" /mnt/home
fi

if [[ $want_new_efi -eq 1 ]]; then
    run_step "Format EFI partition" --core mkfs.fat -F 32 "$efipartition"
fi
mount --mkdir "$efipartition" /mnt/boot

if [[ $want_swap -eq 1 ]]; then
    run_step "Format swap partition" --core mkswap "$swappartition"
    swapon "$swappartition"
fi

step "Base system install (pacstrap)"
## Install
run_step "pacstrap" --core pacstrap -K /mnt base base-devel linux-firmware "${kernel_pkgs[@]}"
genfstab -U /mnt >> /mnt/etc/fstab

cat > /mnt/.arch_install_answers <<EOF
username=$username
hostname=$hostname
install_media=$install_media
install_dev=$install_dev
install_qtile=$install_qtile
install_fallback=$install_fallback
install_testing=$install_testing
install_android=$install_android
install_latex=$install_latex
kernel_count=$kernel_count
login_method=$login_method
aur_choice="$aur_choice"
EOF

step "Entering chroot for system configuration (stage 2/3)"
ai2_path=/mnt/arch_install2.sh
sed '2,/^#part2$/d' "$0" > "$ai2_path"
chmod +x "$ai2_path"
arch-chroot /mnt ./arch_install2.sh
rm "$ai2_path"

step "Installation finished"
if confirm "Unmount /mnt and reboot now?" ; then
    umount -R /mnt
    reboot
else
    echo "Remember to run: umount -R /mnt && reboot"
fi
exit

#part2
set -euo pipefail
printf '\033c'

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }
confirm() { dialog --backtitle "Arch Install" --yesno "$1" 0 0; }
run_step() {
    local desc="$1"; shift
    local allow_skip=1
    if [[ "$1" == "--core" ]]; then
        allow_skip=0
        shift
    fi
    while true; do
        "$@" && return 0
        local choice
        if [[ $allow_skip -eq 1 ]]; then
            choice=$(dialog --backtitle "Arch Install" --menu "\"$desc\" failed." 0 0 3 \
                retry "Try again" \
                skip  "Skip this step and continue" \
                abort "Abort the installation" \
                3>&1 1>&2 2>&3) || choice="abort"
        else
            choice=$(dialog --backtitle "Arch Install" --menu "\"$desc\" failed. This step is required." 0 0 2 \
                retry "Try again" \
                abort "Abort the installation" \
                3>&1 1>&2 2>&3) || choice="abort"
        fi
        case "$choice" in
            retry) continue ;;
            skip) return 0 ;;
            *) clear; echo "Aborted at: $desc"; exit 1 ;;
        esac
    done
}

step "Stage 2/3: System configuration (inside chroot)"

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
# shellcheck disable=SC1091
source /.arch_install_answers

if [[ "$install_android" -eq 1 ]]; then
    sed -i -E '/^[[:space:]]*#?[[:space:]]*\[multilib\][[:space:]]*$/,/^[[:space:]]*#?[[:space:]]*Include[[:space:]]*=[[:space:]]*\/etc\/pacman.d\/mirrorlist[[:space:]]*$/ s/^[[:space:]]*#//' /etc/pacman.conf
fi

pacman --noconfirm --disable-download-timeout -Syu archlinux-keyring dialog

step "Locale & timezone"
## Time and lang
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
grep -qxF 'en_US.UTF-8 UTF-8' /etc/locale.gen || echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf


step "Installing base package set (this takes a while)"
## Install packages
core_pkgs=(
    grub os-prober efibootmgr neovim git xterm man-db man-pages texinfo sudo gptfdisk
    wget curl speedtest-cli ttf-mononoki-nerd otf-font-awesome noto-fonts noto-fonts-emoji
    noto-fonts-cjk btop zip unzip unrar 7zip fish lua lua51 eza ripgrep jq sd fzf
    trash-cli alacritty bluez bluez-utils pipewire
    pipewire-pulse pipewire-audio pipewire-jack pipewire-alsa wireplumber alsa-utils pulsemixer
    ncdu aria2 ntfs-3g ntfsprogs
    rsync xdg-user-dirs libconfig libnotify tmux bat
    fd ctags xdg-desktop-portal
    openssh sshfs miniserve rofi upower power-profiles-daemon networkmanager brightnessctl ddcutil
    proxychains-ng socat zoxide keyd reflector
    mitmproxy gnome-keyring bc mesa mesa-utils usbutils pciutils poppler
    kitty tldr tree-sitter tree-sitter-cli yazi glow jless pkgfile libsecret wl-clipboard
    lsof python-gobject uv udisks2 perl-image-exiftool qrencode
    hyprland uwsm niri xwayland-satellite noctalia noctalia-greeter
    xdg-desktop-portal-gtk xdg-desktop-portal-gnome xdg-desktop-portal-hyprland
    playerctl xdg-terminal-exec wev adw-gtk-theme papirus-icon-theme
)
qtile_pkgs=(
    qtile xorg xorg-xinit picom xclip xdotool xss-lock autorandr
    feh flameshot
)
fallback_pkgs=(
    waybar dunst polkit-gnome rofi-calc rofimoji networkmanager-dmenu
)
media_pkgs=(
    ytfzf imagemagick nsxiv zathura zathura-pdf-poppler ffmpeg qutebrowser mpv
    ffmpegthumbnailer mediainfo
)
dev_pkgs=(
    python-pip python-virtualenv lazygit luarocks nodejs npm
    parallel parallel-docs jc csvlens miller
)
testing_pkgs=(
    qemu-desktop edk2-ovmf
)
nvidia_pkgs=(
    nvidia-prime nvidia-utils nvidia-settings inxi opencl-nvidia nvtop
)

run_step "Core packages" --core pacman --noconfirm -S --needed --disable-download-timeout "${core_pkgs[@]}"
[[ "$install_media" -eq 1 ]] && run_step "Media packages" pacman --noconfirm -S --needed --disable-download-timeout "${media_pkgs[@]}"
[[ "$install_dev" -eq 1 ]] && run_step "Dev packages" pacman --noconfirm -S --needed --disable-download-timeout "${dev_pkgs[@]}"
[[ "$install_qtile" -eq 1 ]] && run_step "Qtile/X11 packages" pacman --noconfirm -S --needed --disable-download-timeout "${qtile_pkgs[@]}"
[[ "$install_qtile" -eq 1 || "$install_fallback" -eq 1 ]] && run_step "Fallback packages" pacman --noconfirm -S --needed --disable-download-timeout "${fallback_pkgs[@]}"
[[ "$install_testing" -eq 1 ]] && run_step "VM testing packages" pacman --noconfirm -S --needed --disable-download-timeout "${testing_pkgs[@]}"

step "CPU microcode detection"
cpu_vendor=$(lscpu | awk -F: '/Vendor ID:/ { gsub(/^[[:space:]]+/, "", $2); print $2; exit }')
case "$cpu_vendor" in
    GenuineIntel) run_step "Intel microcode" --core pacman --noconfirm -S --needed intel-ucode ;;
    AuthenticAMD) run_step "AMD microcode" --core pacman --noconfirm -S --needed amd-ucode ;;
    *) echo "Unknown CPU vendor ($cpu_vendor); skipping microcode package." ;;
esac

step "GPU driver detection"
gpu=$(lspci | grep -iE "vga|3d|display" || true)
if echo "$gpu" | grep -qi nvidia; then
    if confirm "Install the NVIDIA driver (nvidia-open)?"; then
        nvidia_pkg=nvidia-open
        if [[ "$kernel_count" -gt 1 ]]; then
            nvidia_pkg="${nvidia_pkg}-dkms"
        fi
        run_step "Nvidia drivers" pacman --noconfirm -S --needed --disable-download-timeout \
            "$nvidia_pkg" "${nvidia_pkgs[@]}"
    fi
fi
if echo "$gpu" | grep -qi amd; then
    amd_pkgs=(vulkan-radeon)
    [[ "$install_qtile" -eq 1 ]] && amd_pkgs+=(xf86-video-amdgpu)
    run_step "AMD drivers" pacman --noconfirm -S --needed --disable-download-timeout "${amd_pkgs[@]}"
fi

pacman --noconfirm -Fyy
pkgfile -u

step "Initramfs"
cat > /etc/mkinitcpio.conf <<EOF
MODULES=()
BINARIES=()
FILES=()
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)
EOF

run_step "mkinitcpio" --core mkinitcpio -P

step "User account creation"
## User
passwd
[[ -d "/home/$username" ]] && mv "/home/$username" "/home/$username.old"
useradd -mG wheel,audio,video,storage,optical -s /bin/fish "$username"
passwd "$username"
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel
chmod 0440 /etc/sudoers.d/wheel
visudo -cf /etc/sudoers.d/wheel

## nvim for vi / vim
ln -sf /usr/bin/nvim /usr/bin/vi
ln -sf /usr/bin/nvim /usr/bin/vim
ln -sf /usr/bin/rofi /usr/bin/dmenu

step "Network & hostname configuration"
## Network
echo "$hostname" > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
if grep -qE '^[[:space:]]*ControllerMode[[:space:]]*=' /etc/bluetooth/main.conf; then
    sed -i -E 's/^[[:space:]]*ControllerMode[[:space:]]*=.*/ControllerMode = dual/' /etc/bluetooth/main.conf
else
    echo 'ControllerMode = dual' >> /etc/bluetooth/main.conf
fi

cat > /etc/xdg/reflector/reflector.conf <<EOF
--protocol https
--country India
--age 12
--sort rate
--save /etc/pacman.d/mirrorlist
EOF

step "Enabling services"
services=(NetworkManager bluetooth sshd reflector.timer fstrim.timer pkgfile-update.timer keyd power-profiles-daemon)
[[ "$login_method" == greeter ]] && services+=(greetd)
run_step "Enable services" systemctl enable "${services[@]}"

step "Bootloader installation"
## Boot Loader
run_step "grub-install (primary)" --core grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
run_step "grub-install (removable fallback)" grub-install --target=x86_64-efi --efi-directory=/boot --removable

### Silent Boot
sed -i /etc/default/grub  \
    -e 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=0/g' \
    -e 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/g' \
    -e 's/GRUB_HIDDEN_TIMEOUT=.*/GRUB_HIDDEN_TIMEOUT=0/g' \
    -e 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/g' \
    -e 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="Arch"/g' \
    -e 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=""/g' \
    -e "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"quiet loglevel=3\"/g" \
    -e 's/^#GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/g' \
    -e 's/^GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/g'


run_step "grub-mkconfig" --core grub-mkconfig -o /boot/grub/grub.cfg

step "Handing off to user-level setup (stage 3/3)"
## Pre-Installation Finish
cp /.arch_install_answers "/home/$username/.arch_install_answers"
chown "$username:$username" "/home/$username/.arch_install_answers"
rm /.arch_install_answers

ai3_path="/home/$username/arch_install3.sh"
sed '2,/^#part3$/d' "$0" > "$ai3_path"
chown "$username:$username" "$ai3_path"
chmod +x "$ai3_path"
su -c "$ai3_path" -s /bin/bash "$username"
rm "$ai3_path"
exit

#part3
set -euo pipefail
printf '\033c'

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$1"; }
run_step() {
    local desc="$1"; shift
    local allow_skip=1
    if [[ "$1" == "--core" ]]; then
        allow_skip=0
        shift
    fi
    while true; do
        "$@" && return 0
        local choice
        if [[ $allow_skip -eq 1 ]]; then
            choice=$(dialog --backtitle "Arch Install" --menu "\"$desc\" failed." 0 0 3 \
                retry "Try again" \
                skip  "Skip this step and continue" \
                abort "Abort the installation" \
                3>&1 1>&2 2>&3) || choice="abort"
        else
            choice=$(dialog --backtitle "Arch Install" --menu "\"$desc\" failed. This step is required." 0 0 2 \
                retry "Try again" \
                abort "Abort the installation" \
                3>&1 1>&2 2>&3) || choice="abort"
        fi
        case "$choice" in
            retry) continue ;;
            skip) return 0 ;;
            *) clear; echo "Aborted at: $desc"; exit 1 ;;
        esac
    done
}

# shellcheck disable=SC1091
source "$HOME/.arch_install_answers"
rm "$HOME/.arch_install_answers"

step "Stage 3/3: User environment setup"

step "Installing yay (AUR helper)"
## Yay
install_yay() {
    cd "$HOME"
    rm -rf yay-bin
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -fsr
    sudo -S pacman -U yay-bin-[0-9]*.pkg.tar.zst
    cd "$HOME"
    rm -rf yay-bin
}
run_step "Build & install yay" install_yay

step "AUR packages"
### Yay - Install necessary packages
run_step "Necessary AUR packages" yay --noconfirm --sudoflags "-S" --sudoloop -S --disable-download-timeout \
    materialgram-bin pup-bin brave-bin bibata-cursor-theme-bin \
    bento4 dragon-drop simple-mtpfs cloudflare-warp-bin

## Yay - Install optional packages, based on choices made at the start of the install
aur_extra_pkgs=()
[[ "$install_qtile" -eq 1 ]] && aur_extra_pkgs+=(i3lock-fancy-git)
[[ "$install_android" -eq 1 ]] && aur_extra_pkgs+=(android-tools android-udev jdk21-openjdk android-studio android-sdk-cmdline-tools-latest android-sdk-build-tools android-sdk-platform-tools)
[[ "$install_latex" -eq 1 ]] && aur_extra_pkgs+=(texlive-basic texlive-fontsrecommended texlive-latexrecommended texlive-latex texlive-xetex pandoc-cli entr)
[[ "$aur_choice" == *mongodb-compass* ]] && aur_extra_pkgs+=(mongodb-compass-bin)
[[ "$aur_choice" == *envycontrol* ]] && aur_extra_pkgs+=(envycontrol)
[[ "$aur_choice" == *github-tools* ]] && aur_extra_pkgs+=(github-cli github-copilot-cli)
[[ "$aur_choice" == *claude-code* ]] && aur_extra_pkgs+=(claude-code)
[[ "$aur_choice" == *codex* ]] && aur_extra_pkgs+=(openai-codex-bin)

if [[ ${#aur_extra_pkgs[@]} -gt 0 ]]; then
    run_step "Optional AUR packages" yay --noconfirm --sudoflags "-S" --sudoloop -S --disable-download-timeout "${aur_extra_pkgs[@]}"
fi

step "Shell/tooling extras"
# luarocks --local --lua-version=5.1 install magick
run_step "bat cache build" bat cache --build

run_step "yt-dlp install" uv tool install yt-dlp

step "Dotfiles bootstrap"
# Dotfiles
shopt -s expand_aliases
rm -rf "$HOME/.dotfiles"
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
dotfiles init
dotfiles remote add origin https://github.com/deshdeepak1/.dotfiles
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local credential.helper /usr/lib/git-core/git-credential-libsecret
dotfiles fetch --set-upstream origin master
dotfiles reset --hard FETCH_HEAD
dotfiles remote set-url origin git@github.com:Deshdeepak1/.dotfiles.git

install_system_files() {
    sudo -S cp -r --no-preserve=mode,ownership "$HOME/.config/system/." /
    sudo -S sed -i "s/--autologin [^ ]*/--autologin $USER/" \
        /etc/systemd/system/getty@tty1.service.d/skip-prompt.conf
}
run_step "Install system config files" install_system_files

[[ "$install_media" -eq 1 ]] && run_step "mpv scripts" ~/.local/scripts/mpv-scripts-update

step "AUR & user services"
enable_services() {
    sudo -S systemctl enable warp-svc
    systemctl --user --root=/ enable proxychains4-daemon.service train-watch.timer warp-taskbar.service
}
run_step "Enable AUR & user services" enable_services

step "GTK settings"
run_step "GTK settings" dbus-run-session ~/.local/scripts/gtk-settings

step "Wallpapers"
clone_wallpapers() {
    rm -rf "$HOME/wallpapers"
    git clone https://github.com/deshdeepak1/wallpapers "$HOME/wallpapers"
}
run_step "Wallpapers clone" clone_wallpapers

step "Restore kept files"
[[ -d "$HOME.old" ]] && run_step "Restore kept files from ~.old" ~/.local/scripts/restore-kept

step "Stage 3/3 complete — installation finished"

exit

# TODO: fish -> bash, ddcui-like noctalia plugin (ddcutil: contrast, colour preset, input source)

# Testing: arch-install-test (throwaway QEMU/UEFI VM; requires "testing" packages).
