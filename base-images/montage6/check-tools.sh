#!/bin/sh
# Verifies that every Montage tool the workflow runs is on PATH.
#
# Montage's build does not stop when a module fails: some Makefiles run
# modules with a leading "-", others chain "make; make install" so only the
# last status counts. An incomplete build therefore still exits 0. This script
# turns a missing tool into a hard failure. The base image Dockerfile runs it
# after installing Montage, and the worker CI runs it against the finished
# worker image, mounted from the repository checkout.
#
# The list is the set of executables the generated workflow invokes as jobs
# (see workflow-generator/montage-workflow.py). mDiffFit runs mDiff and
# mFitplane as external commands, so those are included too.

set -u

tools="mProject mDiff mFitplane mDiffFit mConcatFit mBgModel mBackground mImgtbl mAdd mViewer"
missing=""

for t in $tools; do
    if command -v "$t" >/dev/null 2>&1; then
        echo "ok      $t"
    else
        echo "MISSING $t"
        missing="$missing $t"
    fi
done

if [ -n "$missing" ]; then
    echo "Missing Montage tools:$missing" >&2
    exit 1
fi
echo "All required Montage tools are present."
