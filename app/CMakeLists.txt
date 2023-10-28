# MBS app - cmake file for building the project
#
# Author: Gabriele Nava
#
# First release: 2020
#
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT
#
cmake_minimum_required(VERSION 2.8.11)

project(FAKE_INSTALLATION)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
set(TEMPORARY_SHARE_DIR "${CMAKE_INSTALL_PREFIX}/share/TEMP")

install(CODE "MESSAGE(\"Fake Installation. This repository simply acts as a container.\")")
