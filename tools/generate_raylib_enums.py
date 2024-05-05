"""
Generates raylib enum bindings from C to s7
"""

import json
from os import path


# List of enums that will be included in the generated file
# Change this and re-run the script to add more enum bindings
INCLUDE_ENUMS = [
    "KeyboardKey",
]


def main():
    input_path = path.join(path.dirname(__file__), "..", "libs", "raylib", "parser", "output", "raylib_api.json")
    output_path = path.join(path.dirname(__file__), "..", "sources", "rl", "enums.c")
    with open(input_path, "r") as input_file:
        raylib_api = json.load(input_file)
    with open(output_path, "w") as output_file:
        def writelines(*lines):
            output_file.writelines(line + "\n" for line in lines)
        writelines(
            "// This file was automatically generated by tools/generate_raylib_enums.py",
            "// Any manual modifications will be overwritten when running the script again",
            "#include \"enums.h\"",
            "#include \"raylib.h\"",
            "",
            "void rl_register_enums(s7_scheme *s7) {",
        )
        for enum in raylib_api["enums"]:
            if enum["name"] not in INCLUDE_ENUMS:
                continue
            writelines(
                f"  // enum {enum['name']}",
                *[
                    f"  S7_DEFINE_ENUM(s7, {value['name']});"
                    for value in enum["values"]
                ],
            )
        writelines("}")


if __name__ == "__main__":
    main()