# Note: Using Sqlite instead of QSqlDatabase for better compatibility.

find_package(Qt6 COMPONENTS Gui Network OpenGL OpenGLWidgets Widgets)
if (NOT Qt6_FOUND)
    find_package(Qt5 5.15 COMPONENTS Gui Network OpenGL Widgets REQUIRED)
endif ()

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
    add_definitions("-DQT_COMPILING_QIMAGE_COMPAT_CPP")
    add_definitions("-D_USE_MATH_DEFINES")
    if (NOT MSVC)
        add_definitions("-Wno-deprecated-declarations")
        add_definitions("-Wno-inconsistent-missing-override")
        add_definitions("-Wno-macro-redefined")
        add_definitions("-Wno-microsoft-exception-spec")
        add_definitions("-Wno-unknown-argument")
        add_definitions("-Wno-unknown-warning-option")
        add_definitions("-Wno-unused-command-line-argument")
        add_definitions("-Wno-unused-local-typedef")
        add_definitions("-Wno-unused-private-field")
    endif ()
endif()

target_sources(
    mbgl-core
    PRIVATE
        ${PROJECT_SOURCE_DIR}/platform/$<IF:$<PLATFORM_ID:Windows>,qt/src/bidi.cpp,default/src/mbgl/text/bidi.cpp>
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gfx/headless_backend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gfx/headless_frontend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/include/mbgl/gl/headless_backend.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gfx/headless_backend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gfx/headless_frontend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/gl/headless_backend.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/i18n/collator.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/layermanager/layer_manager.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/platform/time.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/asset_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/database_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/file_source_manager.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/file_source_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/local_file_request.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/local_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/main_resource_loader.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline_database.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/offline_download.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/online_file_source.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/storage/sqlite3.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/compression.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/src/mbgl/util/monotonic_timer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/async_task.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/async_task_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/number_format.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/gl_functions.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/headless_backend_qt.cpp
        $<$<BOOL:${MBGL_PUBLIC_BUILD}>:${PROJECT_SOURCE_DIR}/platform/qt/src/http_file_source.cpp>
        $<$<BOOL:${MBGL_PUBLIC_BUILD}>:${PROJECT_SOURCE_DIR}/platform/qt/src/http_file_source.hpp>
        $<$<BOOL:${MBGL_PUBLIC_BUILD}>:${PROJECT_SOURCE_DIR}/platform/qt/src/http_request.cpp>
        $<$<BOOL:${MBGL_PUBLIC_BUILD}>:${PROJECT_SOURCE_DIR}/platform/qt/src/http_request.hpp>
        ${PROJECT_SOURCE_DIR}/platform/qt/src/local_glyph_rasterizer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_image.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_logging.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/run_loop.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/run_loop_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/string_stdlib.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/thread.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/thread_local.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/timer.cpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/timer_impl.hpp
        ${PROJECT_SOURCE_DIR}/platform/qt/src/utf.cpp
)

target_compile_definitions(
    mbgl-core
    PRIVATE QT_IMAGE_DECODERS
    PUBLIC __QT__ MBGL_USE_GLES2
)

target_include_directories(
    mbgl-core
    PRIVATE ${PROJECT_SOURCE_DIR}/platform/default/include
)

include(${PROJECT_SOURCE_DIR}/vendor/nunicode.cmake)

find_package(ZLIB REQUIRED)
find_package(ICU COMPONENTS i18n uc REQUIRED)
find_package(sqlite3 CONFIG REQUIRED)

target_link_libraries(
    mbgl-core
    PRIVATE
        ZLIB::ZLIB
        ICU::i18n ICU::uc
        Qt::Core
        Qt::Gui
        Qt::Network
        Qt::OpenGL
        $<TARGET_NAME_IF_EXISTS:Qt::OpenGLWidgets>
        mbgl-vendor-nunicode
        sqlite3
)

if (0)
add_library(
    qmapboxgl SHARED
    ${PROJECT_SOURCE_DIR}/platform/qt/include/qmapbox.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/include/qmapboxgl.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapbox.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_map_observer.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_map_observer.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_map_renderer.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_map_renderer.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_p.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_renderer_backend.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_renderer_backend.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_scheduler.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qmapboxgl_scheduler.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_conversion.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_geojson.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/src/qt_geojson.hpp
)

# FIXME: Because of rapidjson conversion
target_include_directories(
    qmapboxgl
    PRIVATE ${PROJECT_SOURCE_DIR}/src
)

target_include_directories(
    qmapboxgl
    PUBLIC ${PROJECT_SOURCE_DIR}/platform/qt/include
)

target_compile_definitions(
    qmapboxgl
    PRIVATE QT_BUILD_MAPBOXGL_LIB
)

target_link_libraries(
    qmapboxgl
    PRIVATE
        Qt::Core
        Qt::Gui
        mbgl-compiler-options
        mbgl-core
)

add_executable(
    mbgl-qt
    ${PROJECT_SOURCE_DIR}/platform/qt/app/main.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/app/mapwindow.cpp
    ${PROJECT_SOURCE_DIR}/platform/qt/app/mapwindow.hpp
    ${PROJECT_SOURCE_DIR}/platform/qt/resources/common.qrc
)

# Qt public API should keep compatibility with old compilers for legacy systems
set_property(TARGET mbgl-qt PROPERTY CXX_STANDARD 98)

target_link_libraries(
    mbgl-qt
    PRIVATE
        Qt::Widgets
        Qt::Gui
        mbgl-compiler-options
        qmapboxgl
)

add_executable(
    mbgl-test-runner
    ${PROJECT_SOURCE_DIR}/platform/qt/test/main.cpp
)

target_include_directories(
    mbgl-test-runner
    PUBLIC ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/test/include
)

target_compile_definitions(
    mbgl-test-runner
    PRIVATE WORK_DIRECTORY=${PROJECT_SOURCE_DIR}
)

target_link_libraries(
    mbgl-test-runner
    PRIVATE
        Qt::Gui
        Qt::OpenGL
        mbgl-compiler-options
        pthread
)

if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
    target_link_libraries(
        mbgl-test-runner
        PRIVATE -Wl,-force_load mbgl-test
    )
else()
    target_link_libraries(
        mbgl-test-runner
        PRIVATE -Wl,--whole-archive mbgl-test -Wl,--no-whole-archive
    )
endif()

find_program(MBGL_QDOC NAMES qdoc)

if(MBGL_QDOC)
    add_custom_target(mbgl-qt-docs)

    add_custom_command(
        TARGET mbgl-qt-docs PRE_BUILD
        COMMAND
            ${MBGL_QDOC}
            ${PROJECT_SOURCE_DIR}/platform/qt/config.qdocconf
            -outputdir
            ${CMAKE_BINARY_DIR}/docs
    )
endif()

add_test(NAME mbgl-test-runner COMMAND mbgl-test-runner WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
endif()