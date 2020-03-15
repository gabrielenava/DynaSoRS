# Install all files
file(GLOB utility_files "*.m")
install(FILES ${utility_files} DESTINATION ${CMAKE_INSTALL_PREFIX}/+mbs)

