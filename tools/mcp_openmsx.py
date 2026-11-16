#!/usr/bin/env python3
"""Small MCP client for the reference openMSX service (diagnostics only)."""
import base64
import json
import sys
import urllib.request

URL = "http://raspberrypi3b.local:3000/mcp"


class Mcp:
    def __init__(self):
        self.session = None
        self.next_id = 1
        self.rpc("initialize", {
            "protocolVersion": "2025-06-18",
            "capabilities": {},
            "clientInfo": {"name": "opencode-script", "version": "1"},
        })
        self.rpc("notifications/initialized", {}, notification=True)

    def rpc(self, method, params, notification=False):
        body = {"jsonrpc": "2.0", "method": method, "params": params}
        if not notification:
            body["id"] = self.next_id
            self.next_id += 1
        headers = {
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
        }
        if self.session:
            headers["Mcp-Session-Id"] = self.session
        request = urllib.request.Request(
            URL, data=json.dumps(body).encode(), headers=headers)
        with urllib.request.urlopen(request, timeout=30) as response:
            if method == "initialize":
                self.session = response.headers.get("Mcp-Session-Id")
            text = response.read().decode()
        if notification or not text:
            return None
        for line in text.splitlines():
            if line.startswith("data: "):
                return json.loads(line[6:])
        return json.loads(text)

    def tool(self, name, arguments):
        return self.rpc("tools/call", {"name": name, "arguments": arguments})


def main():
    mcp = Mcp()
    if len(sys.argv) == 3 and sys.argv[1] == "tcl":
        print(json.dumps(mcp.tool("openmsx_tcl_cmd", {"command": sys.argv[2]}), indent=2))
        return
    if len(sys.argv) == 4 and sys.argv[1] == "tool":
        print(json.dumps(mcp.tool(sys.argv[2], json.loads(sys.argv[3])), indent=2))
        return
    if len(sys.argv) == 3 and sys.argv[1] == "vram":
        # The MCP truncates large Tcl results. Snapshot atomically once, then
        # export bounded chunks from that same snapshot (not a moving frame).
        def tcl(command):
            reply = mcp.tool("openmsx_tcl_cmd", {"command": command})["result"]
            if reply.get("isError"):
                raise RuntimeError(reply)
            result = reply["structuredContent"]
            if result["truncated"]:
                raise RuntimeError("MCP truncated VRAM export")
            return result["result"]

        tcl("set ::opencode_vram_export [debug read_block {physical VRAM} 0 131072]; string length $::opencode_vram_export")
        data = bytearray()
        try:
            for offset in range(0, 131072, 8192):
                text = tcl("binary encode base64 [string range $::opencode_vram_export %d %d]"
                           % (offset, offset + 8191))
                block = base64.b64decode(text)
                if len(block) != 8192:
                    raise RuntimeError("short VRAM block at %d" % offset)
                data.extend(block)
        finally:
            tcl("unset ::opencode_vram_export")
        if len(data) != 131072:
            raise RuntimeError("short VRAM snapshot")
        with open(sys.argv[2], "wb") as fp:
            fp.write(data)
        print(sys.argv[2], len(data))
        return
    if len(sys.argv) == 3 and sys.argv[1] == "screenshot":
        result = mcp.tool("screen_shot", {"command": "as_image"})
        for content in result.get("result", {}).get("content", []):
            if content.get("type") == "image":
                data = base64.b64decode(content["data"])
                with open(sys.argv[2], "wb") as fp:
                    fp.write(data)
                print(sys.argv[2], len(data), content.get("mimeType"))
                return
        print(json.dumps(result, indent=2))
        raise SystemExit("no image in screenshot response")
    print("usage: mcp_openmsx.py screenshot OUT | vram OUT | tcl CMD | tool NAME JSON")
    raise SystemExit(2)


if __name__ == "__main__":
    main()
