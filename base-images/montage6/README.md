# Montage 6.0 Base Image

This base image contains the Montage 6.0 toolkit with Node.js 20 LTS. The
worker image (`worker-images/montage6-worker`) builds on it.

## GCC compatibility patch

Montage 6.0 defines some globals in several translation units and relies on
the linker merging them. gcc 10 and later default to `-fno-common`, so those
modules fail to link with "multiple definition" errors. `changes.patch` adds
`-fcommon` to the 44 Makefiles that need it. They cover the top-level
`Montage/Makefile.LINUX`, the affected `MontageLib` modules, `lib/src/coord`,
and the `util` tools.

## Tool check

Montage's build does not stop when a module fails. `MontageLib/Makefile` runs
each module with a leading `-`. The top-level `Makefile` and `grid/Makefile`
run `(cd X; make; make install)`, where only the last command's status counts.
A build with a missing patch therefore exits 0 and produces an image without
tools such as `mViewer`.

`check-tools.sh` lists every Montage tool the workflow runs and fails if any
of them is not on `PATH`. The Dockerfile runs it after installing Montage, so
an incomplete build fails. The worker CI runs the same script against the
finished worker image, which catches a broken base published by other means.

## Image tags

- `hyperflowwms/montage-base:6.0-node20` - full version tag
- `hyperflowwms/montage-base:6.0-latest` - latest build for Montage 6.0

## Building

The GitHub Actions workflow `.github/workflows/montage6-base.yml` builds the
image for every change to this directory and pushes it when the change lands
on master. A successful push on master triggers a rebuild and push of the
Montage 6 worker, so the published worker is built on the published base.

A manual run of the base workflow with `push` enabled does not trigger the
worker. Run the `montage6-worker` workflow manually with `push` enabled
afterwards.

To build locally:

```bash
make image  # Build locally (always --no-cache)
make push   # Build and push to Docker Hub
```
