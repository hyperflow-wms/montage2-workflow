# Montage workflow data container

## Build and publish image

Usage:
- Use workflow generator to generate a Montage2 workflow
- Download workflow data using the script `download_fits_files.sh`
- Rename data dir to a meaningful name, e.g. `montage2-0.25` (it will be used to tag the Docker image)
- Run the following (set `WORKFLOW_DEGREE`, `NUMBER_OF_TASKS` and `WORKFLOW_DIR` appropriately):

```bash
# WORKFLOW_DIR points to the directory with workflow data
make push WORKFLOW_DEGREE=0.25 NUMBER_OF_TASKS=619 WORKFLOW_DIR=montage2-0.25
```
