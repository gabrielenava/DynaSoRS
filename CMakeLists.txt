# MBS core - cmake file for building the project
#
# Author: Gabriele Nava
#
# First release: 2020
#
# CopyPolicy: Released under the terms of the LGPLv2.1 or later, see LGPL.TXT
#
cmake_minimum_required(VERSION 2.8.11)

project(mbs_CORE)

# Add core functions
add_subdirectory(core-functions)

# Add utlities 
add_subdirectory(utility-functions)

