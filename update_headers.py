#!/usr/bin/env python3
import os
import sys

def print_warning(message: str) -> None:
    print(f"[WARNING] {message}")

def generate_copyright_header(filename: str) -> str:
    MARGIN = 70
    TEMPLATE = """\
/**************************************************************************/
/*  %s*/
/**************************************************************************/
/*                         This file is part of:                          */
/*                             LINUS ENGINE                               */
/*            https://linusbf15.github.io/linus-engine-web                */
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
    if len(basename) > MARGIN:
        print_warning(f'Filename "{basename}" is too long for the copyright header.')
        basename = basename[:MARGIN]
        
    padded_filename = basename.ljust(MARGIN)
    return TEMPLATE % padded_filename

def process_file(file_path: str) -> None:
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
    except UnicodeDecodeError:
        # Skip binary files or unrecognized encodings
        return
    
    header_end_marker = "/**************************************************************************/"
    
    if content.startswith("/**************************************************************************/"):
        # Split by the horizontal block marker to isolate the existing header.
        # Standard Linus Engine headers contain exactly 4 instances of this line.
        parts = content.split(header_end_marker)
        if len(parts) > 3:
            # Reconstruct everything after the header block
            rest_of_code = header_end_marker.join(parts[5:])
            clean_content = rest_of_code.lstrip()
        else:
            clean_content = content
    else:
        clean_content = content

    # Generate the fresh header based on the current filename
    new_header = generate_copyright_header(file_path)
    final_content = new_header + "\n" + clean_content

    # Write changes back only if the file content has actually changed
    if content != final_content:
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(final_content)
        print(f"[UPDATED] {file_path}")

def main() -> None:
    # Target directories inside the engine repository to scan
    TARGET_FOLDERS = ["core", "scene", "servers", "modules", "main", "platform", "drivers", "editor", "thirdparty", "misc", "tests"]
    VALID_EXTENSIONS = (".cpp", ".h", ".c", ".glsl", ".inc")

    print("Starting copyright headers update for Linus Engine...")
    
    counter = 0
    for folder in TARGET_FOLDERS:
        if not os.path.exists(folder):
            continue
            
        for root, _, files in os.walk(folder):
            for file in files:
                if file.endswith(VALID_EXTENSIONS):
                    full_path = os.path.join(root, file)
                    process_file(full_path)
                    counter += 1

    print(f"Done! Processed {counter} source files.")

if __name__ == "__main__":
    main()
