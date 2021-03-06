if(@LIBTITLE@_FOUND)

  message(STATUS "@LIBTITLE@ is already included")

else(@LIBTITLE@_FOUND)

  message("-- Included @LIBTITLE@-@LIBVERSION@ Library")
  set(CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/cmake ${CMAKE_MODULE_PATH})

  INCLUDE_DIRECTORIES(@CMAKE_INSTALL_PREFIX@/include/@LIBTITLE@-@LIBVERSION@/ )

  STRING(REPLACE ":" ";" LD_PATHS "$ENV{LD_LIBRARY_PATH}")
  
  #------------------------------------------------------------------------------
 find_package(Qt4 COMPONENTS QtCore QtGui REQUIRED)
  if(QT4_FOUND)
    message(STATUS "@LIBTITLE@: Found QT4 at ${QT_LIBRARY_DIR}")
    include(${QT_USE_FILE})
    SET(2DX_LIBRARIES   ${QT_LIBRARIES} ${2DX_LIBRARIES})
    #add_definitions(-D__2DX__GL__)
    add_definitions(-D__2DX__QT4__)
  else(QT4_FOUND)
    message(STATUS "@LIBTITLE@: Qt4 not Found!")
  endif(QT4_FOUND)
  

  
  #------------------------------------------------------------------------------
  # Include myself
  if("${LIBTITLE}" STREQUAL "@LIBTITLE@")
    # We are building the library at the moment
    set(LIB_@LIBTITLE@ "")
    set(@LIBTITLE@_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})
  else("${LIBTITLE}" STREQUAL "@LIBTITLE@")
    message(STATUS "@LIBTITLE@: @LIBTITLE@_BINARY_DIR is ${@LIBTITLE@_BINARY_DIR}")
    find_library(LIB_@LIBTITLE@ @LIBTITLE@ PATHS ${@LIBTITLE@_BINARY_DIR})
    message(STATUS "@LIBTITLE@: Link with ${LIB_@LIBTITLE@}")
    SET(2DX_LIBRARIES  optimized ${LIB_@LIBTITLE@} ${2DX_LIBRARIES}) 
    # Include Files of this library
    INCLUDE_DIRECTORIES(@CMAKE_INSTALL_PREFIX@/include/@LIBTITLE@-@LIBVERSION@/ )
    message(STATUS "@LIBTITLE@: Include: @CMAKE_INSTALL_PREFIX@/include/@LIBTITLE@-@LIBVERSION@/")
  endif("${LIBTITLE}" STREQUAL "@LIBTITLE@")
  
  add_definitions(-D__CONF__)
  set(@LIBTITLE@_FOUND true)

endif(@LIBTITLE@_FOUND)
