cmake_minimum_required(VERSION 3.10)
project(load81 C)

# Set CMake to use C99 standard
set(CMAKE_C_STANDARD 99)

# Find SDL and required SDL extensions
find_package(SDL REQUIRED)
find_library(SDL_IMAGE_LIBRARY SDL_image REQUIRED)
find_library(SDL_GFX_LIBRARY SDL_gfx REQUIRED)


# Include directories
include_directories(
    ${SDL_INCLUDE_DIR}
    ${SDL_GFX_INCLUDE_DIR}
    ${SDL_IMAGE_INCLUDE_DIR}
    ${SDL_MIXER_INCLUDE_DIR}
    ${SDL_NET_INCLUDE_DIR}
    ${SDL_RTF_INCLUDE_DIR}
    ${SDL_SOUND_INCLUDE_DIR}
    ${SDL_TTF_INCLUDE_DIR}
    ${CMAKE_SOURCE_DIR}/lua/src
)

# Platform-specific customizations
if(APPLE)
    include_directories(
		/usr/local/Cellar/sdl_gfx/2.0.27/include/SDL/
		/usr/local/Cellar/sdl_image/1.2.12_10/include/SDL/
		/usr/local/Cellar/sdl_mixer/1.2.12_6/include/SDL/
		/usr/local/Cellar/sdl_net/1.2.8_1/include/SDL/
		/usr/local/Cellar/sdl_rtf/0.1.0/include/SDL/
		/usr/local/Cellar/sdl_sound/1.0.3_2/include/SDL/
		/usr/local/Cellar/sdl_ttf/include/SDL)
endif()

# Find SDL dependencies
#find_package(SDL_gfx REQUIRED)
#find_package(SDL_image REQUIRED)


# Compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -Wall -W")

# Source files
set(SOURCES
    load81.c
    editor.c
    framebuffer.c
)

# Lua library target
add_custom_command(
    OUTPUT ${CMAKE_SOURCE_DIR}/lua/src/liblua.a
    COMMAND ${CMAKE_MAKE_PROGRAM} ansi
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/lua
    COMMENT "Building Lua library"
)

add_custom_target(liblua ALL
    DEPENDS ${CMAKE_SOURCE_DIR}/lua/src/liblua.a
)

# Add the library to the linker path
add_library(lua_lib STATIC IMPORTED)
set_target_properties(lua_lib PROPERTIES
    IMPORTED_LOCATION ${CMAKE_SOURCE_DIR}/lua/src/liblua.a
)

# Define the executable
add_executable(load81 ${SOURCES})

# Custom command to set macOS quarantine attribute
#add_custom_command(
#    TARGET load81 POST_BUILD
#    COMMAND bash -c "/usr/bin/xattr -w com.apple.quarantine \"0002;\$(printf %x \$(date +%s));load81;\$(/usr/bin/uuidgen)\" load81"
#    COMMENT "Setting macOS quarantine attribute for load81"
#)

# Link the libraries
target_link_libraries(load81
    lua_lib
    m
    ${SDL_LIBRARY}
    ${SDL_GFX_LIBRARY}
    ${SDL_IMAGE_LIBRARY}
)

# Ensure liblua is built before load81
add_dependencies(load81 liblua)

# Add custom clean targets
add_custom_target(clean-lua
    COMMAND ${CMAKE_MAKE_PROGRAM} clean
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/lua
)

add_custom_target(distclean
    COMMAND ${CMAKE_BUILD_TOOL} clean
    COMMAND ${CMAKE_MAKE_PROGRAM} clean
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/lua
)
