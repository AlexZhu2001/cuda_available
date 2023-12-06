# Copyright (c) 2023 Alex
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

import os

VERSION = "0.1.0"
CUDA_VERSION = ''.join(os.environ["CUDA_VERSION"].split('.')[:-1])

with open("/tmp/VERSION", 'w') as f:
    f.write(f"{VERSION}+cu{CUDA_VERSION}")

print("Version write to /tmp/VERSION")