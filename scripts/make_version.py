# Copyright (c) 2023 Alex
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import os
import sys

VERSION = "0.2."

if __name__ == "__main__":
    cuda_ver = os.environ.get("CUDA_VERSION")
    if cuda_ver is None:
        print("CUDA_VERSION is not set!")
        sys.exit(-1)
    major,minor = cuda_ver.split(".")[:2]
    fp = "./src/VERSION.metadata"
    with open(fp, "w") as f:
        text = f"VERSION={VERSION}{major}{minor}"
        f.write(text)
        print(f"Result {text} write to {fp} succeed")
    