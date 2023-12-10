#!/bin/bash

# Function below is the code that will be run on the main function of the file that is complied. If your program does not have a main, this is not use. If it does have a main, swap the code below with your code
run_program(){
    # Compile the java file
    javac "$1"

    # Define test inputs
    test_inputs=("ahhaaauuaaoaa aaaa eee uuu ooo o." "aaheeeeaaa jiii louuuuuooo" "alex")

    test_outputs=("3912001414" "1422121332" "0101000000")

    # Loop through test outputs and expected outputs
    for i in "${!test_inputs[@]}"; do
        # Run the java file with test output
        output=$(java "${1//.java/}" <<< "${test_inputs[i]}")
        echo $output
        printf "\n"

        output_numbers=$(echo "$output" | grep -o '[0-9]\+' | tr '\n' ' ')
        output_numbers=${output_numbers// /}

        expected_numbers=${test_outputs[i]}

        if [ "$output_numbers" = "$expected_numbers" ]; then
            echo "Test $i passed"
        else
            echo "Test $i failed"
        fi
        printf "\n"
    done
}

process_file(){
    studentName=$(echo $1 | cut -d'/' -f 2 | cut -d'_' -f 1)
    studentNameNoSpaces="${studentName// /_}"
    if ! grep -q "$studentNameNoSpaces" openedStudents.txt; then
        fileWithSlash="/$2"
        cd "${1//$fileWithSlash/}" 
        # run_program "$2"
        cd "$3"
        echo "$studentNameNoSpaces" >> openedStudents.txt
        echo $studentNameNoSpaces
    else
        cd "$3"
    fi
}

# Use this command if you want to recurisvely decomprees all the zips in your dir: find . -name "*.zip" | while read filename; do unzip -o -d "`dirname "$filename"`" "$filename"; done;

pwd=$(pwd)
echo $pwd
echo "Looking for directories with a file named $1"
find . -name "$1" | while read filename;do process_file "$filename" $1 "$pwd"; done;