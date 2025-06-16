# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appChess_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appChess_autogen.dir/ParseCache.txt"
  "appChess_autogen"
  )
endif()
