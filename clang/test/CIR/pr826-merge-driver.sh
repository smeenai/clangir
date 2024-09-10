#!/usr/bin/env bash

# See https://github.com/ldionne/llvm-project/blob/main/libcxx/utils/clang-format-merge-driver.sh
# Install via (from repo root):
#   git config merge.pr826.name "Fix type alias names for https://github.com/llvm/clangir/pull/826"
#   git config merge.pr826.driver "clang/test/CIR/pr826-merge-driver.sh %O %A %B %P"

# Path to the file's contents at the ancestor's version.
base="$1"

# Path to the file's contents at the current version.
current="$2"

# Path to the file's contents at the other branch's version (for nonlinear histories, there might be multiple other branches).
other="$3"

# The path of the file in the repository.
path="$4"

sed -E -e 's/ty_22([A-Za-z0-9_$]+[0-9])22/ty_\1_/g' -e 's/ty_22([A-Za-z0-9_$]+)22/ty_\1/g' < "$base" > "$base.tmp"
mv "$base.tmp" "$base"

sed -E -e 's/ty_22([A-Za-z0-9_$]+[0-9])22/ty_\1_/g' -e 's/ty_22([A-Za-z0-9_$]+)22/ty_\1/g' < "$current" > "$current.tmp"
mv "$current.tmp" "$current"

sed -E -e 's/ty_22([A-Za-z0-9_$]+[0-9])22/ty_\1_/g' -e 's/ty_22([A-Za-z0-9_$]+)22/ty_\1/g' < "$other" > "$other.tmp"
mv "$other.tmp" "$other"

git merge-file -Lcurrent -Lbase -Lother "$current" "$base" "$other"
