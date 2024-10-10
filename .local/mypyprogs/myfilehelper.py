import os
import json

import aiofiles
import aiofiles.os


async def read_json(file_path: str):
    async with aiofiles.open(file_path, encoding="utf-8") as f:
        return json.loads(await f.read())


async def write_json(json_file_path: str, content_dict) -> None:
    await aiofiles.os.makedirs(os.path.dirname(json_file_path), exist_ok=True)
    async with aiofiles.open(json_file_path, "w", encoding="utf-8") as f:
        await f.write(json.dumps(content_dict, indent=2))
