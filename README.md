# Pegasus Montage v2 workflow for HyperFlow

This is a port of Pegasus [Montage 2 workflow](https://github.com/pegasus-isi/montage-workflow-v2) to HyperFlow.

## Repository Structure

This repository builds Docker images for running Montage workflows with the HyperFlow workflow engine. It supports both Montage 5.0 and 6.0 with a clean hierarchical structure:

```
montage2-workflow/
├── base-images/              # Base images with Montage + Node.js
│   ├── montage5/            # Montage 5.0 + Node 12
│   └── montage6/            # Montage 6.0 + Node 20
├── worker-images/           # Worker images with HyperFlow executor
│   ├── montage5-worker/    # Montage 5.0 worker
│   └── montage6-worker/    # Montage 6.0 worker
├── workflow-generator/      # Workflow generation tools
├── data-container/         # Data container configuration
└── scripts/                # Utility scripts
```

## Docker Images and Tagging Schema

### Base Images
Base images contain Montage toolkit and Node.js runtime:

- **Montage 5.0**: `hyperflowwms/montage-base:5.0-node12`
  - Also tagged as: `hyperflowwms/montage-base:5.0-latest`

- **Montage 6.0**: `hyperflowwms/montage-base:6.0-node20`
  - Also tagged as: `hyperflowwms/montage-base:6.0-latest`

### Worker Images
Worker images add HyperFlow job executor to base images:

- **Montage 5.0 Worker**: `hyperflowwms/montage-worker:5.0-je1.3.4`
  - Also tagged as: `hyperflowwms/montage-worker:5.0-latest`

- **Montage 6.0 Worker**: `hyperflowwms/montage-worker:6.0-je1.3.4`
  - Also tagged as: `hyperflowwms/montage-worker:6.0-latest`

Tag format: `<montage-version>-je<executor-version>`

## Building Images

### Build all images
```bash
make build-all
```

### Build specific images
```bash
make build-base-5      # Build Montage 5.0 base image
make build-base-6      # Build Montage 6.0 base image
make build-worker-5    # Build Montage 5.0 worker image
make build-worker-6    # Build Montage 6.0 worker image
```

### Push to Docker Hub
```bash
make push-all          # Build and push all images
make push-worker-6     # Build and push only Montage 6.0 worker
```

### Help
```bash
make help              # Show all available targets
```

## Generate Example Workflows

Two scripts are provided to generate example workflows:
- `scripts/genwf-2mass.sh` (9805 tasks)
- `scripts/genwf-dss.sh` (6448 tasks)

The scripts invoke Docker images and create:
- HyperFlow workflow graph (`workflow.json`) in the current directory
- `data` subdirectory with workflow data (only index files, no `fits` image files)

You can also directly use the `hyperflowwms/montage2-generator` image to generate other workflows, see the scripts for command examples. For example, to generate smaller workflows, use a smaller value of the `--degrees` parameter.

## Download `fits` data

The bulk of workflow input data are images in the `fits` format which can be downloaded after the workflow has been generated:

```bash
sudo ./scripts/download_fits_files.sh data/rc.txt
```

(sudo may be necessary due to root/root ownership of the `data` subfolder)

## Running Workflows

The worker containers are provided to run workflows in a distributed infrastructure, e.g. using the [HyperFlow Kubernetes deployment](https://github.com/hyperflow-wms/hyperflow-k8s-deployment).

### Choose Your Montage Version

Specify which worker image to use based on your requirements:
- Montage 5.0: `hyperflowwms/montage-worker:5.0-latest`
- Montage 6.0: `hyperflowwms/montage-worker:6.0-latest`

### Running on a Single Machine

Smaller workflows can be run on a single machine as follows (in directory with `workflow.json`):

```bash
docker run -d --name redis redis --bind 127.0.0.1
./scripts/run.sh
```

## Montage Version Notes

### Montage 5.0
- Based on Alpine Linux with Node.js 12
- Includes patches for handling no-overlap cases in mProject and mDiffFit
- See [base-images/montage5/patches.diff](base-images/montage5/patches.diff) for details

### Montage 6.0
- Based on Debian Bookworm with Node.js 20 LTS
- Includes GCC 10+ compatibility patches (`-fcommon` flag)
- See [base-images/montage6/README.md](base-images/montage6/README.md) for details

## Compile Montage to run on AWS Lambda

In order to run this workflow on AWS Lambda one has to compile and statically link montage.

Download montage:
```bash
wget http://montage.ipac.caltech.edu/download/Montage_v5.0.tar.gz
```

Extract the files.

In order to statically link needed executables we have to go to folders that are building following tasks:
```
mImgtbl
mBackground
mAdd
mDiffFit
mConcatFit
mBgModel
mProject
mDiff
mFitplane
```

Example for mAdd:

1. Go to `<montage folder>/MontageLib/Add`
2. Open `Makefile.LINUX`
3. Add `-static -static-libgcc` to `LIBS` variable

Do it for every executable. `make` project. Check with command `ldd` if program was correctly linked. You should see something like this:
```bash
ldd mAdd
# output:
# is not dynamic executable
```

Unfortunately there is a problem with `mViewer`. For some reason it cannot be statically linked against freetype library. Fortunately there is a solution to this problem.

Run docker with Amazon Linux 2 (this is the same image that is ran on AWS Lambda). Login into docker. Download or copy Montage. Try to make. Install missing packages. When successfully compiled execute:
```bash
ldd mViewer
# Output:
# libfreetype.so.6 => /usr/lib/x86_64-linux-gnu/libfreetype.so.6
# <some other standard libraries>
```

Extract `libfreetype.so.6` as well as file that `libfreetype.so.6` is pointing to (at the time of writing this tutorial it was `libfreetype.so.6.10.0`)

All these files should be present while deploying AWS Lambda executor. If for some reason you do not want to statically link, you can run Amazon Linux 2 image and build executables there (libfreetype.so.6 still has to be copied from image and present in AWS Lambda execution package)
