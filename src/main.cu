#include <pybind11/pybind11.h>
#include <string>
#include <tuple>
#include <cuda_runtime.h>
#include <exception>
#include <sstream>

using namespace std;
namespace py = pybind11;

#define CONCAT(a, b) a##b
#define CONCAT3(a, b, c) a##b##c
#define STR(x) #x
#define GETTER(prop) \
    const auto CONCAT(get_, prop)() const { return this->prop; }
#define PROP(name, doc) def_property_readonly(STR(name), &CudaDeviceInfo::CONCAT(get_, name), doc)
#define MACRO_STRINGIFY(x) STR(x)

class CudaError : public exception
{
private:
    const char *reason;

public:
    CudaError(const char *error_str)
        : reason(error_str)
    {
    }
    const char *what() const noexcept override
    {
        return this->reason;
    }
};

class CudaDeviceInfo
{
private:
    int id;                            /* device id of device */
    string name;                       /* ASCII string identifying device */
    tuple<int, int> computeCapability; /* compute capability */
    size_t totalGlobalVmem;            /* Global memory available on device in bytes */
    tuple<int, int, int> pciId;        /* PCI bus ID, PCI device ID, PCI domain ID of this device */
    bool isTccDriver;                  /* true if device is a Tesla device using TCC driver, false otherwise  */

public:
    GETTER(id)
    GETTER(name)
    GETTER(computeCapability)
    GETTER(totalGlobalVmem)
    GETTER(pciId)
    GETTER(isTccDriver)

public:
    CudaDeviceInfo(int id)
    {
        cudaDeviceProp prop = {0};
        cudaError_t error = cudaGetDeviceProperties(&prop, id);
        if (error != cudaSuccess)
        {
            auto err_str = cudaGetErrorString(error);
            throw CudaError(err_str);
        }
        this->id = id;
        this->name = prop.name;
        this->computeCapability = make_tuple(prop.major, prop.minor);
        this->totalGlobalVmem = prop.totalGlobalMem;
        this->pciId = make_tuple(prop.pciBusID, prop.pciDeviceID, prop.pciDomainID);
        this->isTccDriver = prop.tccDriver;
    }
};

string repr_for_info(const CudaDeviceInfo &a)
{
    auto [ccx, ccy] = a.get_computeCapability();
    auto [pcix, pciy, pciz] = a.get_pciId();
    string tcc = a.get_isTccDriver()
                     ? "True"
                     : "False";
    stringstream ss;
    ss << "{" << endl
       << "\t.Id = " << a.get_id() << endl
       << "\t.Name = " << a.get_name() << endl
       << "\t.Compute Capability = " << ccx << "." << ccy << endl
       << "\t.Total Global Video Memory = " << a.get_totalGlobalVmem() / 1024.0 / 1024.0 << "MBytes" << endl
       << "\t.PCI Id = " << pcix << "." << pciy << "." << pciz << endl
       << "\t Is using TCC driver = " << tcc << endl
       << "}" << endl;
    string output;
    ss >> output;
    return output;
}

int getCudaDeviceCount()
{
    int cnt = 0;
    cudaError_t error = cudaGetDeviceCount(&cnt);
    if (error != cudaSuccess)
    {
        auto err_str = cudaGetErrorString(error);
        throw CudaError(err_str);
    }
    return cnt;
}

PYBIND11_MODULE(cuda_available, m)
{
    m.doc() = R"pbdoc(
        cuda_available module
        -----------------------

        .. currentmodule:: cuda_available

        .. autosummary::
           :toctree: _generate

           CudaDeviceInfo
           getCudaDeviceCount
    )pbdoc";
    py::class_<CudaDeviceInfo>(m, "CudaDeviceInfo", R"pbdoc(
        Get device infomation of cuda device with given device_id
    )pbdoc")
        .def(py::init<int>())
        .PROP(id, "device id of device")
        .PROP(name, "ASCII string identifying device")
        .PROP(computeCapability, "compute capability")
        .PROP(totalGlobalVmem, "Global memory available on device in bytes")
        .PROP(pciId, "PCI bus ID, PCI device ID, PCI domain ID of this device")
        .PROP(isTccDriver, "true if device is a Tesla device using TCC driver, false otherwise")
        .def("__repr__", &repr_for_info)
        .def("__str__", &repr_for_info);

    m.def("getCudaDeviceCount", &getCudaDeviceCount, R"pbdoc(
        Get available cuda device count
    )pbdoc");
    py::register_local_exception<CudaError>(m, "CudaError");

#ifdef VERSION_INFO
    m.attr("__version__") = MACRO_STRINGIFY(VERSION_INFO);
#else
    m.attr("__version__") = "dev";
#endif
}