cmake_minimum_required(VERSION 3.20)

project(Configurer64)

set(DOBBY_GENERATE_SHARED                  OFF CACHE BOOL "" FORCE)
set(DOBBY_DEBUG                            OFF CACHE BOOL "" FORCE)
set(NearBranch                             ON  CACHE BOOL "" FORCE)
set(DynamicBinaryInstrument                OFF CACHE BOOL "" FORCE)
set(FullFloatingPointRegisterPack          OFF CACHE BOOL "" FORCE)
set(EnableObfuscation                      OFF CACHE BOOL "" FORCE)
set(Plugin.SymbolResolver                  OFF CACHE BOOL "" FORCE)
set(Plugin.GlobalOffsetTableHook           ON  CACHE BOOL "" FORCE)
set(Plugin.LinkerLoadCallback              OFF CACHE BOOL "" FORCE)
set(Plugin.ApplicationEventMonitor         OFF CACHE BOOL "" FORCE)
set(Plugin.Android.BionicLinkerRestriction OFF CACHE BOOL "" FORCE)
add_subdirectory(deps/Dobby)

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

target_compile_options(${PROJECT_NAME} PRIVATE 
  -fpass-plugin=${CMAKE_SOURCE_DIR}/ollvm.dylib
)

target_link_libraries(${PROJECT_NAME} PRIVATE
  "-framework Foundation"
  "-framework CoreFoundation"
  "-framework AppKit"
  "-framework Cocoa"
)

target_link_libraries(${PROJECT_NAME} PRIVATE
  objc
  dobby
)

target_include_directories(${PROJECT_NAME} PRIVATE
  ${CMAKE_SOURCE_DIR}/Dobby/include
)
