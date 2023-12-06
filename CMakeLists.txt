cmake_minimum_required(VERSION 3.15...3.22)
project(cuda_available LANGUAGES CUDA CXX VERSION 0.1.0)

include(CheckLanguage)
check_language(CUDA)

find_package(Python 3.7 COMPONENTS Interpreter Development.Module REQUIRED)

add_subdirectory(pybind11)

aux_source_directory(src SOURCES)
pybind11_add_module(cuda_available ${SOURCES} WITH_SOABI)

target_link_libraries(cuda_available PRIVATE pybind11::headers)
# The install directory is the output (wheel) directory
install(TARGETS cuda_available DESTINATION cuda_available)