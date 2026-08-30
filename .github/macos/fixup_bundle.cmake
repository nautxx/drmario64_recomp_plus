include(BundleUtilities)

if(NOT DEFINED APP_EXECUTABLE)
    message(FATAL_ERROR "APP_EXECUTABLE was not provided")
endif()

if(NOT DEFINED APP_BUNDLE)
    message(FATAL_ERROR "APP_BUNDLE was not provided")
endif()

set(SEARCH_DIRS
    "${APP_BUNDLE}/Contents/Frameworks"
    "/opt/homebrew/lib"
    "/usr/local/lib"
)

fixup_bundle("${APP_EXECUTABLE}" "" "${SEARCH_DIRS}")
