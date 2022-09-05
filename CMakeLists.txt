cmake_minimum_required(VERSION 3.20)

project(UIWarp)

add_library(${PROJECT_NAME} SHARED
  src/main.cpp
)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_17)

target_compile_options(${PROJECT_NAME} PRIVATE
  -stdlib=libc++
  -fno-rtti
  -fvisibility=hidden
  -fvisibility-inlines-hidden
)

# Add OLLVM plugin if exists
if (EXISTS ${CMAKE_SOURCE_DIR}/ollvm.dylib)
  target_compile_options(${PROJECT_NAME} PRIVATE 
    -fpass-plugin=${CMAKE_SOURCE_DIR}/ollvm.dylib
  )
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE
  "-framework Foundation"
  "-framework CoreFoundation"
  "-framework AppKit"
  "-framework Cocoa"
)

target_link_libraries(${PROJECT_NAME} PRIVATE
  objc
)
