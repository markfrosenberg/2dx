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
file(GLOB STD_SCRIPTS scripts-standard/*.script )
file(GLOB CSTM_SCRIPTS scripts-custom/*.script)
set(EXECUTE_ALL OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ WORLD_EXECUTE WORLD_READ)
install(FILES ${STD_SCRIPTS}  DESTINATION ${INSTALL_DIR}/scripts-standard PERMISSIONS ${EXECUTE_ALL})
install(FILES ${CSTM_SCRIPTS}  DESTINATION ${INSTALL_DIR}/scripts-custom PERMISSIONS ${EXECUTE_ALL})
