# ~~~
# Copyright 2017 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ~~~

# GTest always requires thread support.
find_package(Threads REQUIRED)

# When GTest is compiled with CMake, it exports GTest::gtest, GTest::gmock,
# GTest::gtest_main and GTest::gmock_main as link targets. On the other hand,
# the standard CMake module to discover GTest, it exports GTest::GTest, and does
# not export GTest::gmock.
#
# In this file we try to normalize the situation to the packages defined in the
# source.  Not perfect, but better than the mess we have otherwise.

function (google_cloud_cpp_create_googletest_aliases)
    # FindGTest() is a standard CMake module. It, unfortunately, *only* creates
    # targets for the googletest libraries (not gmock), and with a name that is
    # not the same names used by googletest: GTest::GTest vs. GTest::gtest and
    # GTest::Main vs. GTest::gtest_main. We create aliases for them:
    add_library(GTest_gtest INTERFACE)
    target_link_libraries(GTest_gtest INTERFACE GTest::GTest)
    add_library(GTest_gtest_main INTERFACE)
    target_link_libraries(GTest_gtest_main INTERFACE GTest::Main)
    add_library(GTest::gtest ALIAS GTest_gtest)
    add_library(GTest::gtest_main ALIAS GTest_gtest_main)
endfunction ()

function (google_cloud_cpp_gmock_library_import_location target lib)
    find_library(_library_release ${lib})
    find_library(_library_debug ${lib}d)

    if ("${_library_debug}" MATCHES "-NOTFOUND" AND "${_library_release}"
                                                    MATCHES "-NOTFOUND")
        message(FATAL_ERROR "Cannot find library ${lib} for ${target}.")
    elseif ("${_library_debug}" MATCHES "-NOTFOUND")
        set_target_properties(${target} PROPERTIES IMPORTED_LOCATION
                                                   "${_library_release}")
    elseif ("${_library_release}" MATCHES "-NOTFOUND")
        set_target_properties(${target} PROPERTIES IMPORTED_LOCATION
                                                   "${_library_debug}")
    else ()
        set_target_properties(${target} PROPERTIES IMPORTED_LOCATION_DEBUG
                                                   "${_library_debug}")
        set_target_properties(${target} PROPERTIES IMPORTED_LOCATION_RELEASE
                                                   "${_library_release}")
    endif ()
endfunction ()

function (google_cloud_cpp_transfer_library_properties target source)

    add_library(${target} UNKNOWN IMPORTED)
    get_target_property(value ${source} IMPORTED_LOCATION)
    if (NOT value)
        get_target_property(value ${source} IMPORTED_LOCATION_DEBUG)
        if (EXISTS "${value}")
            set_target_properties(${target} PROPERTIES IMPORTED_LOCATION
                                                       ${value})
        endif ()
        get_target_property(value ${source} IMPORTED_LOCATION_RELEASE)
        if (EXISTS "${value}")
            set_target_properties(${target} PROPERTIES IMPORTED_LOCATION
                                                       ${value})
        endif ()
    endif ()
    foreach (
        property
        IMPORTED_LOCATION_DEBUG
        IMPORTED_LOCATION_RELEASE
        IMPORTED_CONFIGURATIONS
        INTERFACE_INCLUDE_DIRECTORIES
        IMPORTED_LINK_INTERFACE_LIBRARIES
        IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG
        IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE)
        get_target_property(value ${source} ${property})
        message("*** ${source} ${property} ${value}")
        if (value)
            set_target_properties(${target} PROPERTIES ${property} "${value}")
        endif ()
    endforeach ()
endfunction ()

include(CTest)
if (NOT BUILD_TESTING AND NOT GOOGLE_CLOUD_CPP_TESTING_UTIL_ENABLE_INSTALL)
    # Tests are turned off via -DBUILD_TESTING, do not load the googletest or
    # googlemock dependency.
else ()
    if (NOT TARGET GMock::gmock)
	
	   	# use gmock from umpire
		set (GMOCK_DIR "${GCS_THRDPARTYHOME}/gmock" CACHE INTERNAL "")
		set (GMOCK_INCLUDE_DIR "${GMOCK_DIR}/include" CACHE INTERNAL "" )
		set (GMOCK_LIB_DIR "${GMOCK_DIR}/lib" CACHE INTERNAL "" )
		message(STATUS "using GMOCK_DIR: ${GMOCK_DIR}")

		# Use aliases because: The target name "GTest::gtest" is reserved or not valid for certain CMake features, 
		#	such as generator expressions, and may result in undefined behavior.		
		add_library(GTest_gtest INTERFACE)
		add_library(GTest_gtest_main INTERFACE)
		add_library(GTest_gmock INTERFACE)
		add_library(GTest_gmock_main INTERFACE)
   
		target_include_directories(GTest_gtest INTERFACE "${GMOCK_INCLUDE_DIR}")
		target_include_directories(GTest_gtest_main INTERFACE "${GMOCK_INCLUDE_DIR}")
		target_include_directories(GTest_gmock INTERFACE "${GMOCK_INCLUDE_DIR}")
		target_include_directories(GTest_gmock_main INTERFACE "${GMOCK_INCLUDE_DIR}")
		
		if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
			target_link_libraries(GTest_gtest INTERFACE $<$<CONFIG:Debug>:${GMOCK_LIB_DIR}/gtestd.lib>$<$<CONFIG:Release>:${GMOCK_LIB_DIR}/gtest.lib> )
			target_link_libraries(GTest_gtest_main INTERFACE $<$<CONFIG:Debug>:${GMOCK_LIB_DIR}/gtest_maind.lib>$<$<CONFIG:Release>:${GMOCK_LIB_DIR}/gtest_main.lib>)
			target_link_libraries(GTest_gmock INTERFACE 
				$<$<CONFIG:Debug>:${GMOCK_LIB_DIR}/gmockd.lib>$<$<CONFIG:Release>:${GMOCK_LIB_DIR}/gmock.lib>
				GTest_gtest
				GTest_gtest_main
				Threads::Threads)
			target_link_libraries(GTest_gmock_main INTERFACE 
				$<$<CONFIG:Debug>:${GMOCK_LIB_DIR}/gmock_maind.lib>$<$<CONFIG:Release>:${GMOCK_LIB_DIR}/gmock_main.lib>
				GTest_gmock 
				Threads::Threads)
		else () # OSX/Linux
			target_link_libraries(GTest_gtest INTERFACE ${GMOCK_LIB_DIR}/gtest.a)
			target_link_libraries(GTest_gtest_main INTERFACE ${GMOCK_LIB_DIR}/gtest_main.a)
			target_link_libraries(GTest_gmock INTERFACE 
				${GMOCK_LIB_DIR}/gmock.a
				GTest_gtest
				GTest_gtest_main
				Threads::Threads)
			target_link_libraries(GTest_gmock_main INTERFACE 
				${GMOCK_LIB_DIR}/gmock_main.a
				 GTest_gmock
				 Threads::Threads)
		endif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
		
		add_library(GTest::gtest ALIAS GTest_gtest)
		add_library(GTest::gtest_main ALIAS GTest_gtest_main)
		add_library(GTest::gmock ALIAS GTest_gmock)
		add_library(GTest::gmock_main ALIAS GTest_gmock_main)
    endif ()
endif ()
