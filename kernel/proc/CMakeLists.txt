############################################################################
# A 2dx CMakeLists.txt                                                  #
############################################################################
# The author was:                                                          #
# 2010 Marcel Arheit                                                       #
############################################################################
#
cmake_minimum_required(VERSION 2.6)
get_filename_component(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} NAME)
if(INSTALL_DIR)
	set(INSTALL_DIR ${INSTALL_DIR}/${DIRECTORY})
else(INSTALL_DIR)
	set(INSTALL_DIR ${CMAKE_INSTALL_PREFIX}/kernel/${DIRECTORY})
endif(INSTALL_DIR)
file(GLOB COM_SCRIPTS *.com)
file(GLOB PYTHON_SCRIPTS *.py)
set(HELP_SCRIPTS
	2dx_makedirs
	2dx_merge_makedirs
	dummy.aph
	initialize
	lin
	linblock
	lindoubl2
	lindouble
	linhash
	protest 
)
set(PROC ${COM_SCRIPTS} ${PYTHON_SCRIPTS} ${HELP_SCRIPTS}) 
set(EXECUTE_ALL OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ WORLD_EXECUTE WORLD_READ)
install(FILES ${PROC} DESTINATION ${INSTALL_DIR} PERMISSIONS ${EXECUTE_ALL})
install(SCRIPT install_symlink.cmake)

add_subdirectory(movie)
