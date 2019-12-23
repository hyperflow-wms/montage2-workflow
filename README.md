# Pegasus Montage v2 worklow for HyperFlow

This is a port of Pegasus [Montage 2 workflow](https://github.com/pegasus-isi/montage-workflow-v2) to HyperFlow.

## Generate example workflows

Two scripts are provided to generate example workflows:
- `genwf-2mass.sh` (6k tasks)
- `genwf-dss.sh` (8k tasks)

The scripts invoke Docker images and create:
- HyperFlow workflow graph (`workflow.json`) in the current directory
- `data` subdirectory with workflow data (only index files, no `fits` image files) 

You can also directly use the `hyperflowwms/montage2-generator` image to generate other workflows, see the scripts for command examples.

## Download `fits` data

The bulk of workflow input data are images in the `fits` format which can be downloaded after the workflow has been generated:<br>

```sudo ./download_fits_files.sh data/rc.txt``` (sudo may be necessary due to root/root ownership of the `data` subfolder)

## Running workflow
The `hyperflowwms/montage2-worker` container is provided to run the workflows in a distributed infrastructure, e.g. using the [HyperFlow Kubernetes deployment](https://github.com/hyperflow-wms/hyperflow-k8s-deployment).

