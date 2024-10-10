import asyncio
import shlex
from enum import Enum, auto
from dataclasses import dataclass
import myhelper


class OptionType(Enum):
    command = auto()
    url = auto()


@dataclass
class Option:
    name: str
    image: str = ""
    type: OptionType = OptionType.url
    url: str = ""
    command: str = ""


async def choose(
    options: dict[str, Option],
    no_image: bool = True,
    preview: bool = True,
    theme="fullscreen-preview",
) -> Option | str | None:
    options_str = ""
    for option_name, option in options.items():
        option_str = f"{option.name}"
        option_str += rf"\0icon\x1f{option.image}" if option.image else ""
        options_str += rf"{option_str}\n"

    rofi_cmd = f"NO_IMAGE={str(no_image).lower()} PREVIEW={str(preview).lower()} rofi -dmenu -show-icons -theme {theme}"
    echo_cmd = rf"echo -en {shlex.quote(options_str)}"
    cmd = f"{echo_cmd} | {rofi_cmd}"
    # print(cmd)
    rcode, out, err = await myhelper.get_rcode_out_err_shell(cmd)
    if not out:
        return None
    if out not in options:
        return out
    option = options[out]
    return option


async def real_main():
    options = {
        "Folder": Option("Folder", "folder"),
        "Back": Option("Back", "back"),
    }
    option = await choose(options)
    print(option)


def main():
    asyncio.run(real_main())


if __name__ == "__main__":
    main()
