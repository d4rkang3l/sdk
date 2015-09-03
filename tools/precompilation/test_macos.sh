#!/bin/bash -ex

# Usage:
#   cd sdk
#   ./tools/precompilation/test_macos.sh

./tools/build.py -mdebug -ax64 runtime

./xcodebuild/DebugX64/dart_no_snapshot --gen-precompiled-snapshot ~/hello.dart

./xcodebuild/DebugX64/dart ./tools/precompilation/create_instructions_snapshot_assembly.dart precompiled.instructions precompiled.S

clang -m64 -dynamiclib -o libprecompiled.dylib precompiled.S

LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$PWD" lldb -- ./xcodebuild/DebugX64/dart --run-precompiled-snapshot not_used.dart
