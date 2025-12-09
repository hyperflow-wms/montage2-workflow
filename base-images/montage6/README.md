# Montage 6.0 Base Image

This base image contains Montage 6.0 toolkit with Node.js 20 LTS.

## GCC Compatibility Patches

Montage 6.0 requires patches for compatibility with modern GCC (10+) which changed the default behavior for multiple definitions of global variables.

The following patches are applied during build:

1. **Montage/Makefile.LINUX (line 51)**: Add `-fcommon` flag to CFLAGS
   - Changes: `-std=c99` → `-std=c99 -fcommon`

2. **lib/src/coord/Makefile (line 3)**: Add `-fcommon` flag to CFLAGS

These patches allow Montage 6.0 to compile with GCC 10+ by reverting to the pre-GCC-10 behavior where tentative definitions are allowed.

## Image Tags

- `hyperflowwms/montage-base:6.0-node20` - Full version tag
- `hyperflowwms/montage-base:6.0-latest` - Latest build for Montage 6.0

## Building

```bash
make image  # Build locally
make push   # Build and push to Docker Hub
```
