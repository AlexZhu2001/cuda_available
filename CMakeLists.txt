cmake_minimum_required(VERSION 3.15...3.22)
project(cuda_available LANGUAGES CUDA CXX VERSION 0.1.0)

include(CheckLanguage)
check_language(CUDA)

find_package(Python 3.7 COMPONENTS Interpreter Development REQUIRED)
add_subdirectory(pybind11)

if(DEFINED ENV{CUDA_PATH_LINUX})
    set(CUDA_PATH ENV{CUDA_PATH_LINUX})
    set(path ENV{PATH})
    string(CONCAT path path ":" ${CUDA_PATH} "/bin")
    set(ENV{PATH} path)
    set(ld_path ENV{LD_LIBRARY_PATH})
    string(CONCAT ld_path ld_path ":" ${CUDA_PATH} "/lib" ":" ${CUDA_PATH} "/lib64")
    set(ENV{LD_LIBRARY_PATH} ld_path)
endif()

if(DEFINED SKBUILD_PROJECT_VERSION)
    set(VERSION_INFO ${SKBUILD_PROJECT_VERSION})
endif()

aux_source_directory(src SOURCES)
pybind11_add_module(cuda_available ${SOURCES})