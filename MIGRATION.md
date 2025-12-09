# Migration Guide

This document explains the repository reorganization and how to complete the migration.

## What Changed

The repository has been reorganized from a flat structure to a hierarchical one that clearly separates:
1. **Base images** (Montage + Node.js) from **worker images** (+ HyperFlow executor)
2. **Montage 5.0** from **Montage 6.0** support

## New Structure

```
montage2-workflow/
├── base-images/              # NEW: Base images
│   ├── montage5/            # Migrated from montage2-alpine/
│   └── montage6/            # NEW: Montage 6.0 support
├── worker-images/           # NEW: Worker images
│   ├── montage5-worker/    # Migrated from root Dockerfile
│   └── montage6-worker/    # NEW: Montage 6.0 worker
├── scripts/                 # NEW: Organized shell scripts
│   ├── download_fits_files.sh
│   ├── genwf-2mass.sh
│   ├── genwf-dss.sh
│   └── run.sh
├── workflow-generator/      # Unchanged
├── data-container/         # Unchanged
├── Makefile.new            # NEW: Top-level orchestration
└── README.new.md           # NEW: Updated documentation
```

## Image Name Changes

### Old Image Names (deprecated)
- `hyperflowwms/montage2-alpine-node-12:montage5.0-patched`
- `hyperflowwms/montage2-worker:je-1.3.4`

### New Image Names
**Base Images:**
- `hyperflowwms/montage-base:5.0-node12` (or `5.0-latest`)
- `hyperflowwms/montage-base:6.0-node20` (or `6.0-latest`)

**Worker Images:**
- `hyperflowwms/montage-worker:5.0-je1.3.4` (or `5.0-latest`)
- `hyperflowwms/montage-worker:6.0-je1.3.4` (or `6.0-latest`)

## Migration Steps

### Step 1: Review the Changes
Review the new structure and files:
- `Makefile.new` - New top-level build orchestration
- `README.new.md` - Updated documentation
- `base-images/` - Base image configurations
- `worker-images/` - Worker image configurations
- `scripts/` - Reorganized utility scripts

### Step 2: Backup Old Files (Optional)
```bash
# Backup old configuration
mkdir -p .backup
cp Makefile .backup/
cp README.md .backup/
cp Dockerfile .backup/
```

### Step 3: Copy Missing Files
The `Montage-master.tar.gz` file was not copied to `base-images/montage5/`. You need to copy it:

```bash
cp montage2-alpine/Montage-master.tar.gz base-images/montage5/
```

### Step 4: Activate New Configuration
```bash
# Replace old files with new ones
mv Makefile.new Makefile
mv README.new.md README.md
```

### Step 5: Test Builds
Test building the images locally before pushing:

```bash
# Test base image builds
make build-base-5
make build-base-6

# Test worker image builds (requires base images built first)
make build-worker-5
make build-worker-6
```

### Step 6: Update Scripts
If you have any scripts or CI/CD pipelines that reference the old image names, update them to use the new naming scheme.

### Step 7: Clean Up Old Files (Optional)
After successful migration and testing:

```bash
# Old root Dockerfile is now in worker-images/montage5-worker/
rm Dockerfile

# Old montage2-alpine is preserved but can be archived
# (Consider keeping it for reference until images are tested)
# mv montage2-alpine .backup/
```

## Backward Compatibility

To maintain backward compatibility, you can create alias tags:

```bash
# After building new images, create aliases for old names
docker tag hyperflowwms/montage-base:5.0-node12 \
  hyperflowwms/montage2-alpine-node-12:montage5.0-patched

docker tag hyperflowwms/montage-worker:5.0-je1.3.4 \
  hyperflowwms/montage2-worker:je-1.3.4

# Push aliases
docker push hyperflowwms/montage2-alpine-node-12:montage5.0-patched
docker push hyperflowwms/montage2-worker:je-1.3.4
```

## Testing Checklist

- [ ] Base images build successfully
  - [ ] `make build-base-5`
  - [ ] `make build-base-6`
- [ ] Worker images build successfully
  - [ ] `make build-worker-5`
  - [ ] `make build-worker-6`
- [ ] Montage 5.0 worker runs correctly
- [ ] Montage 6.0 worker runs correctly
- [ ] Workflow generation scripts work with updated paths
- [ ] CI/CD pipelines updated (if applicable)

## Rollback

If you need to rollback:

```bash
# Restore old files
cp .backup/Makefile .
cp .backup/README.md .
cp .backup/Dockerfile .

# Remove new directories
rm -rf base-images/ worker-images/ scripts/
```

## Questions or Issues?

If you encounter any issues during migration, check:
1. Docker daemon is running
2. You have sufficient disk space for building images
3. You have push access to `hyperflowwms` Docker Hub organization
4. Base images are built before worker images (workers depend on base)
