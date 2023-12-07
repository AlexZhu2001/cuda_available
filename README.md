## cuda_available

A package for checking available CUDA device information

![GitHub License](https://img.shields.io/github/license/AlexZhu2001/cuda_available)
![PyPI - Version](https://img.shields.io/pypi/v/cuda-available)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/alexzhu2001/cuda_available/build.yml)

**WARNING: The last field of version is related to cuda version**

**0.1.117 is using CUDA 11.7 COMPILER to build**

**0.1.118 is using CUDA 11.8 COMPLIER to build**

### Usage
#### Get count of cuda device
```Python
from cuda_avaliable import cuda_avaliable

cnt = cuda_avaliable.getCudaDeviceCount()
print(f"Cuda device count: {cnt}")
```

#### Get infomation of cuda device
```Python
from cuda_avaliable import cuda_avaliable

cnt = cuda_avaliable.getCudaDeviceCount()
for idx in range(cnt):
    info = cuda_avaliable.CudaDeviceInfo(idx)
    print(f"ID: {info.id}")
    print(f"Name: {info.name}")
    print(f"ComputeCapability: {info.computeCapability}")
    print(f"TotalGlobalVmem: {info.totalGlobalVmem}")
    print(f"PciId: {info.pciId}")
    print(f"UsingTccDriver: {info.isTccDriver}")
    print("===================================")
```

