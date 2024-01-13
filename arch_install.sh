#!/bin/bash
# Inspired by - Bugswriter
#part1
printf '\033c'

echo "Arch Install Started"

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
pacman -S networkmamger
systemctl start networkmanager
nmtui
loadkeys us
timedatectl set-ntp true
timedatectl

## Drives and partitions
lsblk
read -p "Enter the drive: " drive
cfdisk $drive
read -p "Enter the linux partition: " partition
mkfs.ext4 $partition
mount $partition /mnt

read -p "Separate home partition? [y/n]" homeanswer
if [[ $homeanswer = y ]] ; then
    read -p "Enter home partition: " homepartition
    mount --mkdir $homepartition /mnt/home
fi

read -p "Create efi partition? [y/n]" efianswer
if [[ $efianswer = y ]] ; then
    read -p "Enter efi partition: " efipartition
    mkfs.fat -F 32 $efipartition
    mount --mkdir $efipartition /mnt/boot
fi

read -p "Create swap partition? [y/n]" swapanswer
if [[ $swapanswer = y ]] ; then
    read -p "Enter swap partition: " swappartition
    mkswap $swappartition
    swapon $swappartition
fi

## Install
pacstrap -K /mnt base base-devel linux linux-headers linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

ai2_path=/mnt/arch_install2.sh
sed '2,/^#part2$/d' `basename $0` > $ai2_path
chmod +x $ai2_path
arch-chroot /mnt ./arch_install2.sh
rm $ai2_path
exit

#part2
printf '\033c'

echo "Arch setup in chroot Started"

sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm --disable-download-timeout -Sy archlinux-keyring

## Time and lang
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

mkinitcpio -P

## Install packages
pacman -Sy --disable-download-timeout --noconfirm grub os-prober efibootmgr neovim git xterm \
    python-pip python-virtualenv python-poetry python-pipx man-db man-pages texinfo sudo \
    wget curl speedtest-cli ttf-mononoki-nerd awesome-terminal-fonts noto-fonts noto-fonts-emoji \
    noto-fonts-cjk btop zip unzip unrar p7zip fish lua lua51 xorg lf sx xh eza ripgrep jq sd fzf \
    ytfzf trash-cli imagemagick qtile python-pywlroots nsxiv alacritty bluez bluez-utils pipewire \
    pipewire-pulse pipewire-audio pipewire-jack pipewire-alsa wireplumber alsa-utils pulsemixer \
    ncdu zathura zathura-pdf-mupdf arc-icon-theme arc-gtk-theme ffmpeg aria2 ntfs-3g qutebrowser \
    rsync picom xdg-user-dirs libconfig libnotify dunst exa tmux bat ffmpeg mpv noto-fonts-emoji \
    fd fzf lazygit ranger ctags ripgrep luarocks feh nodejs xclip xdg-desktop-portal flameshot \
    polkit-gnome openssh sshfs miniserve rofi amd-ucode upower networkmamger brightnessctl

luarocks --local --lua-version=5.1 install magick

## User
passwd
read -p "Username: " username
useradd -mG wheel,audio,video,storage,optical -s /bin/fish $username
passwd $username
echo "%wheel ALL=(ALL:ALL) ALL" >> /etc/sudoers

## nvim for vi / vim
ln -s /usr/bin/nvim /usr/bin/vi
ln -s /usr/bin/nvim /usr/bin/vim

# touchpad
curl -L "https://github.com/Deshdeepak1/.dotfiles/raw/master/.config/30-touchpad.conf" \
    -o /etc/X11/xorg.conf.d/30-touchpad.conf

## Network
read -p "Hostname: " hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
systemctl enable NetworkManager systemd-networkd bluetooth

## Boot Loader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

### Silent Boot
sed -i /etc/default/grub  \
    -e 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=0/g' \
    -e 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/g' \
    -e 's/GRUB_HIDDEN_TIMEOUT=.*/GRUB_HIDDEN_TIMEOUT=0/g' \
    -e 's/GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/g' \
    -e 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="Arch"/g' \
    -e 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=""/g' \
    -e 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 acpi_backlight=video"/g'

sed -i /etc/mkinitcpio.conf -e "s/^HOOKS=(\(.*\) systemd \(.*\))/HOOKS=(\1 udev \2)/g"

agety_prompt_file=/etc/systemd/system/getty@tty1.service.d/skip-prompt.conf
cat << EOF > $agety_prompt_file
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --skip-login --nonewline --noissue --autologin deshdeepak --noclear %I $TERM
EOF

grub-mkconfig -o /boot/grub/grub.cfg

## Pre-Installation Finish
ai3_path=/home/$username/arch_install3.sh
sed '2,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username
rm $ai3_path
exit

#part3
printf '\033c'

echo "User Setup started"

## Paru
cd $HOME
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -fsr
sudo -S pacman -U paru-bin-*pkg.tar.zst
cd $HOME
rm paru-bin -rf

### Paru - Install packages
paru -S --disable-download-timeout forkgram-bin i3lock-fancy-git brave-bin ueberzugpp bento4 dragon-drop simple-mtpfs paru-bin

git config --global user.email "rkdeshdeepak1@gmail.com"
git config --global user.name "Deshdeepak"
git config --global credential.helper cache/store

# Dotfiles
shopt -s expand_aliases
rm $HOME/.dotfiles -rf
alias dotfiles="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
dotfiles init
dotfiles remote add origin https://github.com/deshdeepak1/.dotfiles
dotfiles config --local status.showUntrackedFiles no
dotfiles config --local credential.helper cache/store
dotfiles fetch --set-upstream origin master
dotfiles reset --hard FETCH_HEAD
dotfiles remote set-url origin git@github.com:Deshdeepak1/.dotfiles.git


echo "Installation Completed"

exit

# Todo: Fan/ Cpu Scaling/ Battery ,  nvidia/amd graphics , nvim resetup, Android Studio setup, qr from link
