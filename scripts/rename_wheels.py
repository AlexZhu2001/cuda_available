# Copyright (c) 2023 Alex
#
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import os
import shutil

ROOT = "./wheelhouse"

if __name__ == "__main__":
    cuda_ver = os.environ.get("CUDA_VERSION", None)
    if cuda_ver is None:
        print("Error: cannot find env CUDA_VERSION")
        os.exit(-1)
    major, minor = cuda_ver.split(".")[:2]
    files = os.listdir(ROOT)
    for f in files:
        names = f.split("-")
        temp = names[1]
        temp += f"+cu{major}.{minor}"
        names[1] = temp
        new_name = "-".join(names)
        shutil.move(os.path.join(ROOT, f), os.path.join(ROOT, new_name))
    