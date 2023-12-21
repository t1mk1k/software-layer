#!/bin/bash
#
# Script to install scripts from the software-layer repo into the EESSI software stack

display_help() {
  echo "usage: $0 [OPTIONS]"
  echo "  -p | --prefix          -  prefix to copy the scripts to"
  echo "  -h | --help            -  display this usage information"
}


POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -o|--prefix)
      INSTALL_PREFIX="$2"
      shift 2
      ;;
    -h|--help)
      display_help  # Call your function
      # no shifting needed here, we're done.
      exit 0
      ;;
    -*|--*)
      echo "Error: Unknown option: $1" >&2
      exit 1
      ;;
    *)  # No more options
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift
      ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}"

TOPDIR=$(dirname $(realpath $0))

# Subdirs for generic scripts
SCRIPTS_DIR_SOURCE=${TOPDIR}/scripts/  # Source dir
SCRIPTS_DIR_TARGET=${INSTALL_PREFIX}/scripts/  # Target dir

# Create target dir
mkdir -p ${SCRIPTS_DIR_TARGET}

# Copy scripts into this prefix
for file in utils.sh; do
    cp ${SCRIPTS_DIR_SOURCE}/${file} ${SCRIPTS_DIR_TARGET}/${file}
done
# Subdirs for GPU support
NVIDIA_GPU_SUPPORT_DIR_SOURCE=${TOPDIR}/gpu_support/nvidia/  # Source dir
NVIDIA_GPU_SUPPORT_DIR_TARGET=${INSTALL_PREFIX}/gpu_support/nvidia/  # Target dir

# Create target dir
mkdir -p ${NVIDIA_GPU_SUPPORT_DIR_TARGET}

# Copy files from this directory into the prefix
# To be on the safe side, we dont do recursive copies, but we are explicitely copying each individual file we want to add
for file in install_cuda_host_injections.sh link_nvidia_host_injections.sh; do
    cp ${NVIDIA_GPU_SUPPORT_DIR_SOURCE}/${file} ${NVIDIA_GPU_SUPPORT_DIR_TARGET}/${file}
done