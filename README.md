# Pegasus Montage v2 worklow for HyperFlow

This is a port of Pegasus [Montage 2 workflow](https://github.com/pegasus-isi/montage-workflow-v2) to HyperFlow.

## Generate example workflows

Two scripts are provided to generate example workflows:
- `genwf-2mass.sh` (9805 tasks)
- `genwf-dss.sh` (6448 tasks)

The scripts invoke Docker images and create:
- HyperFlow workflow graph (`workflow.json`) in the current directory
- `data` subdirectory with workflow data (only index files, no `fits` image files) 

You can also directly use the `hyperflowwms/montage2-generator` image to generate other workflows, see the scripts for command examples.

## Download `fits` data

The bulk of workflow input data are images in the `fits` format which can be downloaded after the workflow has been generated:<br>

```sudo ./download_fits_files.sh data/rc.txt``` (sudo may be necessary due to root/root ownership of the `data` subfolder)

## Running workflow
The `hyperflowwms/montage2-worker` container is provided to run the workflows in a distributed infrastructure, e.g. using the [HyperFlow Kubernetes deployment](https://github.com/hyperflow-wms/hyperflow-k8s-deployment). Smaller workflows can be run on a single machine as follows (in directory with `workflow.json`):

```
docker run -d --name redis redis --bind 127.0.0.1
. run.sh
```

## Compile Montage to run on AWS Lambda

In order to run this workflow on AWS Lambda one has to compile and statically link montage.

Download montage
```
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

Do it for every executable.`make` project. Check with command `ldd` if program was correctly linked. You should see something like this:
```
ldd mAdd
output:
is not dynamic executable
```

Unfortunately there is a problem with `mViewer`. For some reason it cannot be statically linked against freetype library. Fortunately there is a solution to this problem.

Run docker with Amazon Linux 2 (this is the same image that is ran on AWS Lambda). Login into docker. Download or copy Montage. Try to make. Install missing packages. When successfully compiled execute:
```
ldd mViewer
Output:
libfreetype.so.6 => /usr/lib/x86_64-linux-gnu/libfreetype.so.6
<some other standard libraries>
```

Extract `libfreetype.so.6` as well as file that `libfreetype.so.6` is pointing to (at the time of writing this tutorial it was `libfreetype.so.6.10.0`)

All these files should be present while deploying AWS Lambda executor. If for some reason you do not want to statically link, you can run Amazon Linux 2 image and build executables there (libfreetype.so.6 still has to be copied from image and present in AWS Lambda execution package)