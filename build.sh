#!/bin/bash
# Uncomment this lines and the echo lines below to have messages with colors, maybe requre install something

# green=$(tput setaf 71);
# red=$(tput setaf 12);
# reset=$(tput sgr0);

# This script compiles a .tex file using LuaLaTeX

# Change this to match the name of your .tex file or recieve from console.
FILENAME="Resume"  
# FILENAME=$1.tex   # From input 

# Create the build directory if it doesn't exist
if [ ! -d "build" ]; then
  mkdir build
fi

# Run LuaLaTeX on the .tex file and redirect the output to the build directory
lualatex -shell-escape -output-directory=build $FILENAME.tex </dev/null 
# Also you can run xelatex
# xelatex -shell-escape -output-directory=build $FILENAME.tex

# Check if there are any errors in the .log file
if grep -q ".*Error.*" build/$FILENAME.log; then
    # echo "${red}Compilation failed${reset}"
    echo "Compilation failed"
    rm -f build/*
else
    # echo "${green}Compilation successful${reset}"
    echo "Compilation successful"
    # Copy the resulting PDF to the working directory
    cp build/$FILENAME.pdf .
    rm -f build/*
fi
