## cuda_available

A package for checking available CUDA device information

### Usage
#### Get count of cuda device
```Python
from cuda_avaliable import getCudaDeviceCount

cnt = getCudaDeviceCount()
print(f"Cuda device count: {cnt}")
```

#### Get infomation of cuda device
```Python
from cuda_avaliable import getCudaDeviceCount, CudaDeviceInfo

cnt = getCudaDeviceCount()
for idx in range(cnt):
    info = CudaDeviceInfo(idx)
    print(f"ID: {info.id}")
    print(f"Name: {info.name}")
    print(f"ComputeCapability: {info.computeCapability}")
    print(f"TotalGlobalVmem: {info.totalGlobalVmem}")
    print(f"PciId: {info.pciId}")
    print(f"UsingTccDriver: {info.isTccDriver}")
    print("===================================")
```

