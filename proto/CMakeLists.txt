cmake_minimum_required(VERSION 3.8)
project(16K)

set(CMAKE_C_STANDARD 99)

if(MSVC)
    add_definitions(
        -D_CRT_SECURE_NO_DEPRECATE
        -D_CRT_SECURE_NO_WARNINGS
        )
endif()

add_executable(proto WIN32
    bullet.c
    data.c
    data_levels.h
    data_levels_2.h
    enemies.c
    enemies.h
    game.c
    item.c
    item.h
    level.c
    level.h
    main.c
    physics.c
    physics.h
    player.c
    player.h
    proto.h
    sprites.c
    )

if(MSVC)
    set_property(TARGET proto PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
endif()

if(WIN32)
    target_include_directories(proto PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/sdl2/include")

    if(CMAKE_SIZEOF_VOID_P EQUAL 4)
        set(dir "${CMAKE_CURRENT_SOURCE_DIR}/sdl2/lib/x86")
    else()
        set(dir "${CMAKE_CURRENT_SOURCE_DIR}/sdl2/lib/x64")
    endif()

    if(MSVC)
        set(outdir "${CMAKE_CURRENT_BINARY_DIR}/$<CONFIG>")
    else()
        set(outdir "${CMAKE_CURRENT_BINARY_DIR}")
    endif()

    add_custom_command(OUTPUT "${outdir}/SDL2.dll"
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${outdir}"
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${dir}/SDL2.dll" "${outdir}/SDL2.dll"
        )

    add_custom_target(SDL2
        DEPENDS "${outdir}/SDL2.dll"
        SOURCES "${dir}/SDL2.dll"
        )

    add_dependencies(proto SDL2)
    target_link_libraries(proto "${dir}/SDL2main.lib" "${dir}/SDL2.lib")
endif()
