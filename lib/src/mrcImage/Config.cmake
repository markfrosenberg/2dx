if(@LIBTITLE@_FOUND)

  message(STATUS "@LIBTITLE@ is already included")

else(@LIBTITLE@_FOUND)

  message("-- Included @LIBTITLE@-@LIBVERSION@ Library")
  set(CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX}/cmake ${CMAKE_MODULE_PATH})

  INCLUDE_DIRECTORIES(@CMAKE_INSTALL_PREFIX@/include/@LIBTITLE@-@LIBVERSION@/ )

  STRING(REPLACE ":" ";" LD_PATHS "$ENV{LD_LIBRARY_PATH}")
  
  #------------------------------------------------------------------------------
  set(USE_FFTWF TRUE)
  find_package(FFTW)
  if(FFTW_FOUND)
	message(STATUS "@LIBTITLE@: Found FFTW at ${FFTW_LIB}")
 	SET(2DX_LIBRARIES  ${FFTW_LIB} ${2DX_LIBRARIES})
  elseif(FFTW_FOUND)
	message(FATAL_ERROR "FFTW not found!")
  endif(FFTW_FOUND)
 
  find_package(Qt4 REQUIRED)
  if(QT4_FOUND)
    message(STATUS "@LIBTITLE@: Found QT4 at ${QT_LIBRARY_DIR}")
    SET(QT_INCLUDES  ${QT_QTCORE_INCLUDE_DIR}  ${QT_INCLUDES})
    include(${QT_USE_FILE})
    INCLUDE_DIRECTORIES(${QT_INCLUDES})
    #message(STATUS "@LIBTITLE@: Qt4: ${QT_LIBRARIES}")
    #SET(2DX_LIBRARIES   ${QT_LIBRARY_DIR}/libQtOpenGL.so ${QT_LIBRARY_DIR}/libQtNetwork.so  ${QT_LIBRARIES} ${2DX_LIBRARIES})
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
  else("${LIBTITLE}" STREQUAL "@LIBTITLE@")
    find_library(LIB_@LIBTITLE@ @LIBTITLE@)
    message(STATUS "@LIBTITLE@: Link with ${LIB_@LIBTITLE@}")
    SET(2DX_LIBRARIES  optimized ${LIB_@LIBTITLE@} ${2DX_LIBRARIES}) 
    # Include Files of this library
    INCLUDE_DIRECTORIES(@CMAKE_INSTALL_PREFIX@/include/@LIBTITLE@-@LIBVERSION@/ )
    message(STATUS "@LIBTITLE@: Include: @CMAKE_INSTALL_PREFIX@/include/@LIBTITLE@-@LIBVERSION@/")
  endif("${LIBTITLE}" STREQUAL "@LIBTITLE@")
  
  add_definitions(-D__CONF__)
  set(@LIBTITLE@_FOUND true)

endif(@LIBTITLE@_FOUND)