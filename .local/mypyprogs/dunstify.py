import myhelper


async def dunstify(
    summary: str,
    body: str | None = None,
    appname: str | None = None,
    urgency: str | None = None,
    hints: list[tuple[str, str, str]] | None = None,
    actions: list[str] | None = None,
    timeout: int | None = None,
    icon: str | None = None,
    replace: int | None = None,
):
    cmd_args = ["dunstify", summary]
    if body:
        cmd_args.append(body)
    if appname:
        cmd_args.extend(["-a", appname])
    if urgency:
        cmd_args.extend(["-u", urgency])
    if hints:
        for hint in hints:
            cmd_args.extend(["-h", ":".join(hint)])
    if actions:
        cmd_args.extend(["-a", ",".join(actions)])
    if timeout:
        cmd_args.extend(["-t", str(timeout)])
    if icon:
        cmd_args.extend(["-i", icon])
    if replace:
        cmd_args.extend(["-r", str(replace)])

    await myhelper.get_rcode_out_err_exec(cmd_args)
