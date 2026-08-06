#!/usr/bin/env python3
import os
import re

HEADER_START = "/**************************************************************************/"
HEADER_ID = "This file is part of:"
HEADER_RE = re.compile(
    r"^/\*{74}/\r?\n.*?"
    r"Permission is hereby granted.*?"
    r"/\*{74}/\r?\n*",
    re.DOTALL,
)

TARGET_FOLDERS = [
    "core",
    "scene",
    "servers",
    "modules",
    "main",
    "platform",
    "drivers",
    "editor",
    "misc",
    "tests",
]

# Set to True if you intentionally want to rewrite headers in third-party code.
PROCESS_THIRDPARTY = False

VALID_EXTENSIONS = (".cpp", ".h", ".c", ".glsl", ".inc")


def print_warning(message: str) -> None:
    print(f"[WARNING] {message}")


def detect_newline(text: str) -> str:
    return "\r\n" if "\r\n" in text else "\n"


def generate_copyright_header(filename: str, newline: str) -> str:
    margin = 70

    template = """\
/**************************************************************************/
/*  %s*/
/**************************************************************************/
/*                         This file is part of:                          */
/*                             LINUS ENGINE                               */
/*            https://linusbf15.github.io/Linus-Engine                    */
/**************************************************************************/
/* Copyright (c) 2026-present Linus Fogsgaard.                            */
/* Copyright (c) 2014-2026 Godot Engine contributors (see AUTHORS.md).    */
/* Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.                  */
/*                                                                        */
/* Permission is hereby granted, free of charge, to any person obtaining  */
/* a copy of this software and associated documentation files (the        */
/* "Software"), to deal in the Software without restriction, including    */
/* without limitation the rights to use, copy, modify, merge, publish,    */
/* distribute, sublicense, and/or sell copies of the Software, and to     */
/* permit persons to whom the Software is furnished to do so, subject to  */
/* the following conditions:                                              */
/*                                                                        */
/* The above copyright notice and this permission notice shall be         */
/* included in all copies or substantial portions of the Software.        */
/*                                                                        */
/* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,        */
/* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF     */
/* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. */
/* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY   */
/* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,   */
/* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE      */
/* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                 */
/**************************************************************************/
"""

    basename = os.path.basename(filename)

    if len(basename) > margin:
        print_warning(f'Filename "{basename}" is too long for the copyright header.')
        basename = "..." + basename[-(margin - 3):]

    padded = basename.ljust(margin)

    return (template % padded).replace("\n", newline)


def strip_existing_header(content: str) -> str:
    if HEADER_ID not in content:
        return content

    match = HEADER_RE.match(content)
    if match:
        return content[match.end():].lstrip()

    return content


def process_file(file_path: str) -> None:
    try:
        with open(file_path, "r", encoding="utf-8", newline="") as f:
            content = f.read()
    except (UnicodeDecodeError, OSError):
        return

    newline = detect_newline(content)

    clean_content = strip_existing_header(content)

    header = generate_copyright_header(file_path, newline)

    final_content = header + newline + clean_content

    if final_content != content:
        with open(file_path, "w", encoding="utf-8", newline="") as f:
            f.write(final_content)
        print(f"[UPDATED] {file_path}")


def main() -> None:
    folders = list(TARGET_FOLDERS)

    if PROCESS_THIRDPARTY:
        folders.append("thirdparty")

    print("Starting copyright header update for Linus Engine...")

    processed = 0
    updated = 0

    for folder in folders:
        if not os.path.isdir(folder):
            continue

        for root, _, files in os.walk(folder):
            for file in files:
                if not file.endswith(VALID_EXTENSIONS):
                    continue

                path = os.path.join(root, file)

                before = os.path.getmtime(path)
                process_file(path)
                after = os.path.getmtime(path)

                processed += 1
                if after != before:
                    updated += 1

    print()
    print(f"Processed : {processed}")
    print(f"Updated   : {updated}")
    print("Done!")


if __name__ == "__main__":
    main()