set(ENTITLEMENTS_FILE "${CMAKE_SOURCE_DIR}/.github/macos/entitlements.plist")

set_target_properties(drmario64_recomp PROPERTIES
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_BUNDLE_NAME "Dr. Mario 64: Recompiled"
    MACOSX_BUNDLE_GUI_IDENTIFIER "io.github.nautxx.drmario64-recomp-plus"
    MACOSX_BUNDLE_BUNDLE_VERSION "1.0.0"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "1.0.0"
    MACOSX_BUNDLE_ICON_FILE "AppIcon.icns"
    MACOSX_BUNDLE_INFO_PLIST "${CMAKE_BINARY_DIR}/Info.plist"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "-"
    XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS "${ENTITLEMENTS_FILE}"
)

set(ICON_SOURCE "${CMAKE_SOURCE_DIR}/icons/512.png")
set(ICONSET_DIR "${CMAKE_BINARY_DIR}/AppIcon.iconset")
set(ICNS_FILE "${CMAKE_BINARY_DIR}/AppIcon.icns")

add_custom_command(
    OUTPUT "${ICNS_FILE}"
    COMMAND ${CMAKE_COMMAND} -E remove_directory "${ICONSET_DIR}"
    COMMAND ${CMAKE_COMMAND} -E make_directory "${ICONSET_DIR}"
    COMMAND sips -z 16 16 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_16x16.png"
    COMMAND sips -z 32 32 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_16x16@2x.png"
    COMMAND sips -z 32 32 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_32x32.png"
    COMMAND sips -z 64 64 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_32x32@2x.png"
    COMMAND sips -z 128 128 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_128x128.png"
    COMMAND sips -z 256 256 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_128x128@2x.png"
    COMMAND sips -z 256 256 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_256x256.png"
    COMMAND sips -z 512 512 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_256x256@2x.png"
    COMMAND sips -z 512 512 "${ICON_SOURCE}" --out "${ICONSET_DIR}/icon_512x512.png"
    COMMAND ${CMAKE_COMMAND} -E copy "${ICON_SOURCE}" "${ICONSET_DIR}/icon_512x512@2x.png"
    COMMAND iconutil -c icns "${ICONSET_DIR}" -o "${ICNS_FILE}"
    DEPENDS "${ICON_SOURCE}"
    COMMENT "Creating the macOS application icon"
    VERBATIM
)

set_source_files_properties("${ICNS_FILE}" PROPERTIES
    GENERATED TRUE
    MACOSX_PACKAGE_LOCATION "Resources"
)
target_sources(drmario64_recomp PRIVATE "${ICNS_FILE}")

configure_file(
    "${CMAKE_SOURCE_DIR}/.github/macos/Info.plist.in"
    "${CMAKE_BINARY_DIR}/Info.plist"
    @ONLY
)

add_custom_command(TARGET drmario64_recomp POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/assets"
        "$<TARGET_BUNDLE_DIR:drmario64_recomp>/Contents/Resources/assets"
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/icons"
        "$<TARGET_BUNDLE_DIR:drmario64_recomp>/Contents/Resources/icons"
    COMMAND ${CMAKE_COMMAND}
        "-DAPP_BUNDLE=$<TARGET_BUNDLE_DIR:drmario64_recomp>"
        "-DAPP_EXECUTABLE=$<TARGET_FILE:drmario64_recomp>"
        -P "${CMAKE_SOURCE_DIR}/.github/macos/fixup_bundle.cmake"
    COMMAND codesign
        --options runtime
        --no-strict
        --sign -
        --entitlements "${ENTITLEMENTS_FILE}"
        --deep
        --force
        "$<TARGET_BUNDLE_DIR:drmario64_recomp>"
    COMMENT "Bundling resources, libraries, and an ad-hoc signature"
    VERBATIM
)

install(TARGETS drmario64_recomp BUNDLE DESTINATION .)
