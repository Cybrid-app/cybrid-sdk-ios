#!/bin/bash

#Path to swiftlint
SWIFT_LINT=./Pods/SwiftLint/swiftlint

#if $SWIFT_LINT >/dev/null 2>&1; then
if [[ -e "${SWIFT_LINT}" ]]; then
    count=0
    for file_path in $(git ls-files -m --exclude-from=.gitignore | grep ".swift$"); do
        export SCRIPT_INPUT_FILE_$count=$file_path
        count=$((count + 1))
    done

##### Check for modified files in unstaged/Staged area #####
    for file_path in $(git diff --name-only --cached | grep ".swift$"); do
        export SCRIPT_INPUT_FILE_$count=$file_path
        count=$((count + 1))
    done

##### Make the count avilable as global variable #####
    export SCRIPT_INPUT_FILE_COUNT=$count

    echo "${SCRIPT_INPUT_FILE_COUNT}"

##### Lint files or exit if no files found for lintint #####
    if [ "$count" -ne 0 ]; then
        echo "Found lintable files! Linting and fixing the fixible parts..."
        $SWIFT_LINT autocorrect --use-script-input-files --config .swiftlint.yml #autocorrects before commit.
    else
        echo "No files to lint!"
        exit 0
    fi

    RESULT=$?

    if [ $RESULT -eq 0 ]; then
        echo ""
        echo "Violation found of the type WARNING! Must fix before commit!"
    else
        echo ""
        echo "Violation found of the type ERROR! Must fix before commit!"
    fi
    exit $RESULT

else
#### If SwiftLint is not installed, do not allow commit
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    echo "If you have Homebrew, you can directly use `brew install swiftlint` to install SwiftLint"
    exit 1
fi
