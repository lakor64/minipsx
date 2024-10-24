# MiniROS cmake dispatcher

set(BOOT_TARGETS "hal;halacpi;halaacpi;halapic;halxbox;halpc98;bootvid;ntoskrnl;ntkrnlmp;kdcom;kdvbox")
set(LIB_TARGETS "ntdll;ntdll_vista;psxsc;psxcrt")
set(BOOT_SUBSYSTEM_TARGETS "smss;csrss;csrsrv;psxsrv;psxss;os2ss")
#set(INF_TARGETS "unattend")

macro(fix_cd_path)
    set(_CD_NO_CAB 1)

    string(LENGTH "${_CD_TARGET}" CD_TARGET_LEN)

    if ("${CD_TARGET_LEN}" STREQUAL "0")
        set(_TARGET ${_CD_NAME_ON_CD})
    else()
        set(_TARGET ${_CD_TARGET})
    endif()

    string(LENGTH "${_TARGET}" TARGET_LEN)

    if ("${_CD_DESTINATION}" STREQUAL "reactos/system32/drivers")
        set(_CD_DESTINATION "reactos/boot/drivers")
    endif()

    if ("${_CD_DESTINATION}" STREQUAL "reactos/inf")
        set(_CD_DESTINATION "reactos/etc/inf")
    endif()

    if ("${_CD_DESTINATION}" STREQUAL "reactos/system32/config")
        set(_CD_DESTINATION "reactos/etc/hive")
    endif()
    
    if (NOT "${TARGET_LEN}" STREQUAL "0")
        list(FIND BOOT_TARGETS ${_TARGET} HAVE_BOOT)
        if (NOT "${HAVE_BOOT}" STREQUAL "-1")
            set(_CD_DESTINATION "reactos/boot")
        endif()
        list(FIND LIB_TARGETS ${_TARGET} HAVE_LIB)
        if (NOT "${HAVE_LIB}" STREQUAL "-1")
            set(_CD_DESTINATION "reactos/lib")
        endif()
        list(FIND BOOT_SUBSYSTEM_TARGETS ${_TARGET} HAVE_SUBSYS)
        if (NOT "${HAVE_SUBSYS}" STREQUAL "-1")
            set(_CD_DESTINATION "reactos/boot/subsys")
        endif()
        #list(FIND INF_TARGETS ${_TARGET} HAVE_INF)
        #if (NOT "${HAVE_INF}" STREQUAL "-1")
        #    set(_CD_DESTINATION "reactos/etc/inf")
        #endif()
    endif()

    string(FIND "${_CD_FILE}" ".nls" HAVE_NLS)

    if (NOT "${HAVE_NLS}" STREQUAL "-1")
        set(_CD_DESTINATION "reactos/etc/nls")
    endif()
endmacro()

function(rm_ros_inc TARGET)
    set_property(TARGET "${TARGET}" PROPERTY INCLUDE_DIRECTORIES "${CMAKE_SOURCE_DIR}/pxss/include")
endfunction()
