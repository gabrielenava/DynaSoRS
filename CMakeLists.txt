cmake_minimum_required(VERSION 2.8.11)

project(matlab-multi-body-sim_CORE)

# Add core 
add_subdirectory(core-functions)

# Add utlities 
add_subdirectory(utility-functions)

# Add wrappers 
add_subdirectory(wrappers)
