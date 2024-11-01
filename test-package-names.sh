#!/bin/bash
dir="$(dirname "$0")"
source "$dir/common/printer.sh"
source "$dir/common/read_args.sh"
file="config"

test_package_name() 
{
    if ! sudo apt show "$1" > /dev/null 2>&1; then
        print_message "The package named $1 does not exist. Try <apt-cache search --names-only <name>>" e
    else
        print_message "Ok, the package $1 exists" i
    fi
}

main() 
{
    declare -A arg_map
    read_args arg_map "$@"

    local test_file="${arg_map["$file"]/"~"/"$HOME"}"
    packages=()

    local path="$(realpath $test_file)"
    [[ ! -f "$path" ]] && pretty_error "invalid path: $test_file"

    read_file_to_array packages "$test_file" "#"
    print_message "Testing package names:"
    print_array packages

    for package in "${packages[@]}"; do
        test_package_name "$package"
    done
}

main "$@"