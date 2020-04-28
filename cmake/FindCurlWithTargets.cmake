# ~~~
# Copyright 2018 Google Inc.
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

# gRPC always requires thread support.
find_package(Threads REQUIRED)


# use curl from umpire
set (CURL_DIR "${GCS_THRDPARTYHOME}/curl" CACHE INTERNAL "")
set (CURL_INCLUDE_DIR "${CURL_DIR}/include" CACHE INTERNAL "" )
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	set( CURL_LIBRARY "${CURL_DIR}/lib/libcurl_a.lib" CACHE INTERNAL "")
else () # OSX/Linux
	set( CURL_LIBRARY "${CURL_DIR}/lib/libcurl.a" CACHE INTERNAL "")
endif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
message(STATUS "using CURL_DIR: ${CURL_DIR}")

if (NOT TARGET CURL::libcurl)
	message(STATUS "defining curl lib")
	message(STATUS "CURL linkage will be static from a package")
	add_library(CURL::libcurl UNKNOWN IMPORTED)
	set_property(TARGET CURL::libcurl
				 APPEND
				 PROPERTY INTERFACE_INCLUDE_DIRECTORIES
						  "${CURL_INCLUDE_DIR}")
	# generator expressions don't seem to work for this property
	# and neither do COMPILE_DEFINITIONS, otherwise we could set the "CURL_STATICLIB" preprocessor definition here
	set_property(TARGET CURL::libcurl
				 APPEND
				 PROPERTY IMPORTED_LOCATION "${CURL_LIBRARY}")
	set_property(TARGET CURL::libcurl
				 APPEND
				 PROPERTY INTERFACE_LINK_LIBRARIES
						  OpenSSL::SSL
						  OpenSSL::Crypto
						  ZLIB::ZLIB)
	
	
	# On WIN32 and APPLE there are even more libraries needed for static
	# linking.
	if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
		# this assumes we are linking Windows CRT libs the same way as curl did when it was built, otherwise we would need to add libs here
		set_property(TARGET CURL::libcurl
					 APPEND
					 PROPERTY INTERFACE_LINK_LIBRARIES
					 crypt32 wsock32 ws2_32 wldap32.lib normaliz.lib)
	elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
		set_property(TARGET CURL::libcurl
					 APPEND
					 PROPERTY INTERFACE_LINK_LIBRARIES ldap)
	endif (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
endif (NOT TARGET CURL::libcurl)
