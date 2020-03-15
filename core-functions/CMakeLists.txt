# Install all files
file(GLOB core_files "*.m")
install(FILES ${core_files} DESTINATION ${CMAKE_INSTALL_PREFIX}/+mbs)
