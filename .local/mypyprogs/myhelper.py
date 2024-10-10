import asyncio
import asyncio.subprocess


async def get_rcode_out_err_exec(cmd: list[str]) -> tuple[int | None, str, str]:
    """
    Run subprocess and get rcode, out and err
    """
    process = await asyncio.create_subprocess_exec(
        *cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    out, err = [x.decode().strip() for x in await process.communicate()]
    rcode = process.returncode
    return rcode, out, err


async def get_rcode_out_err_shell(cmd: str) -> tuple[int | None, str, str]:
    """
    Run subprocess and get rcode, out and err
    """
    process = await asyncio.create_subprocess_shell(
        cmd,
        stdout=asyncio.subprocess.PIPE,
        stderr=asyncio.subprocess.PIPE,
    )
    out, err = [x.decode().strip() for x in await process.communicate()]
    rcode = process.returncode
    return rcode, out, err


def clear_str(text: str):
    return (
        (
            text.replace("\n", " ")
            .replace("\r", " ")
            .replace("\t", " ")
            .replace("/", "|")
            .strip()
        )
        if text
        else ""
    )
