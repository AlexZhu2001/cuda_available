# Copyright (c) 2023 Alex
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT


import os
import subprocess
import sys

repo = r"https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb"

def cmd(cmd: str):
    ret = subprocess.call(cmd, shell=True)
    if ret != 0:
        sys.exit(ret)


if __name__ == "__main__":
    cuda_ver = os.environ.get("CUDA_VERSION", None)
    cuda_tookit = "cuda-toolkit-" + "-".join(cuda_ver.split("."))
    cmd(f"wget {repo}")
    cmd(f"sudo dpkg -i cuda-keyring_1.1-1_all.deb")
    cmd("sudo apt-get update")
    cmd(f"sudo apt-get -y install {cuda_tookit}")
    