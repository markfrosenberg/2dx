############################################################################
# A 2dx CMake install script                                               #
############################################################################
# Creates the necessary symbolic links to the kernel                       #
# The author was:                                                          #
# 2011 Marcel Arheit                                                       #
############################################################################
#
cmake_minimum_required(VERSION 2.6)
if(CMAKE_HOST_UNIX)
	message("IN CONF SCRIPT")
	execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink kernel/config ${CMAKE_INSTALL_PREFIX}/config)
endif(CMAKE_HOST_UNIX)


