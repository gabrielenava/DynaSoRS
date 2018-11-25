# CMake file
cmake_minimum_required(VERSION 2.8.11)

project(matlab-multi-body-sim)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

set(idyntree-matlab-multi-body-sim_SHARE_DIR "${CMAKE_INSTALL_PREFIX}/share/matlab-multi-body-sim")

install(CODE "MESSAGE(\"Fake installation. This repository simply acts as a container.\")")
