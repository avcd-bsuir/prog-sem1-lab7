# License: CC BY-NC-SA 4.0
# build.sh
#
# Simple build file for BSUIR laboratory works.
#
# Written by AlexeyFilich 2020

#!/bin/bash

FLAGS=""
LIBS=""
INCLUDE=""
INCLUDE += "-I\"third-party/tools-storage/include\" "
INCLUDE += "-I\"third-party/tools-stuff/include\" "

NAME=${2%.*}
FOLDER=${2%/*}
FILENAME=${NAME##*/}

# Recreate build/ directory
[ ! -d build ] && mkdir build

# Recreate bin/ directory
[ ! -d bin ] && mkdir bin

# Print error message if compiler is specified incorrectly
if [ "$1" != "gcc" ] && [ "$1" != "g++" ]; then
    printf -- "\e[38;05;1;49;24;27m-- Only\e[0m \e[38;05;3;49;04;27mgcc.exe\e[0m \e[38;05;1;49;24;27mor\e[0m \e[38;05;3;49;04;27mg++.exe\e[0m \e[38;05;1;49;24;27mcompilers are supported\e[0m\n"
    exit 1
fi

# Remove out and hash files
if [ "$3" == "--full" ] || [ "$3" == "-f" ]; then
    rm build/$NAME.out
    rm build/$NAME.hash
fi

printf -- "\e[38;05;2;49;24;27m--\e[0m \e[38;05;2;49;04;27mStarting build process\e[0m\n"
printf -- "\e[38;05;2;49;24;27m-- Compiler:\e[0m \e[38;05;3;49;04;27m$1.exe\e[0m\n\n"

printf -- "\e[38;05;2;49;24;27m-- Compiling file:\e[0m \e[38;05;3;49;04;27m$2\e[0m\n"
printf -- "\e[38;05;2;49;24;27m-- Flags: \e[0m$FLAGS\n"
printf -- "\e[38;05;2;49;24;27m-- Libs: \e[0m$LIBS\n"
printf -- "\e[38;05;2;49;24;27m-- Include directories:\e[0m\n"
printf -- "\e[38;05;2;49;24;27m.. \e[0minclude/\n"
printf -- "\e[38;05;2;49;24;27m.. \e[0mthird-party/toolbox/\n"
printf -- "\e[38;05;2;49;24;27m.. \e[0mD:\workspace\MinGW\include\n"
printf -- "\e[38;05;2;49;24;27m-- Library directories:\e[0m\n"
printf -- "\e[38;05;2;49;24;27m.. \e[0mlib/\n"
printf -- "\e[38;05;2;49;24;27m.. \e[0mD:\workspace\MinGW\lib\n"
printf -- "\n"
printf -- "\e[38;05;2;49;24;27m-- Output name:\e[0m \e[38;05;3;49;04;27mbuild/$NAME.out\e[0m\n"
printf -- "\n"

[ ! -d build/$FOLDER ] && mkdir -p build/$FOLDER
[ ! -f build/$NAME.hash ] && touch build/$NAME.hash

file_hash=$(md5sum $2)
last_hash=$(cat build/$NAME.hash)

if [ "$file_hash" != "$last_hash" ]
then
    printf -- "\e[38;05;2;49;24;27m-- Compiling...\e[0m\n"
    [ -f build/$NAME.out ] && rm build/$NAME.out
    # Compiler command
    $1.exe $FLAGS -I"include/" -I"third-party/toolbox/" -I"D:\workspace\MinGW\include" $INCLUDE -L"lib/" -L"D:\workspace\MinGW\lib" $2 -o build/$NAME.out $LIBS
    # Success check
    if [ ! -f build/$NAME.out ]
    then
        echo > build/$NAME.hash
        printf -- "\e[38;05;1;49;24;27m-- Compilation failed!\e[0m\n"
        exit 1
    fi
    echo "$(md5sum $2)" > build/$NAME.hash
    printf -- "\e[38;05;2;49;24;27m-- Success!\e[0m\n"
else
    printf -- "\e[38;05;2;49;24;27m--\e[0m \e[38;05;3;49;04;27m$2\e[0m \e[38;05;2;49;24;27mis up to date\e[0m\n"
fi

cp build/$NAME.out bin/$FILENAME.exe
cd bin
printf -- "\n==== Starting ====\n"
./$FILENAME.exe
printf -- "==================\n"
cd ..
