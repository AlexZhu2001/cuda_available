# Copyright (c) 2023 Alex
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import os
import subprocess
import sys

repo = "https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo"


def cmd(cmd: str):
    ret = subprocess.call(cmd, shell=True)
    if ret != 0:
        sys.exit(ret)


if __name__ == "__main__":
    cuda_ver = os.environ.get("CUDA_VERSION", None)
    cuda_tookit = "cuda-toolkit-" + "-".join(cuda_ver.split("."))
    cmd(f"yum-config-manager --add-repo {repo}")
    cmd("yum clean all")
    cmd(f"yum -y install {cuda_tookit}")
    
