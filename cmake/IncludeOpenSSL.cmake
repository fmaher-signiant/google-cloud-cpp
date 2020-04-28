

# openssl
 set( OPENSSL_ROOT_DIR ${GCS_THRDPARTYHOME}/openssl CACHE INTERNAL "")
 set( OPENSSL_INCLUDE_DIR "${OPENSSL_ROOT_DIR}/include" CACHE INTERNAL "")
 set( OPENSSL_LIB_DIR "${OPENSSL_ROOT_DIR}/lib" CACHE INTERNAL "")
 
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	set( OPENSSL_SSL_LIB "${OPENSSL_LIB_DIR}/libssl.lib" CACHE INTERNAL "")
	set( OPENSSL_CRYPTO_LIB "${OPENSSL_LIB_DIR}/libcrypto.lib" CACHE INTERNAL "")
else() # OSX/Linux
	find_package(Threads REQUIRED)
	
	set( OPENSSL_SSL_LIB "${OPENSSL_LIB_DIR}/libssl.a" CACHE INTERNAL "")
	set( OPENSSL_CRYPTO_LIB "${OPENSSL_LIB_DIR}/libcrypto.a" CACHE INTERNAL "")
endif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")   

#hack to make cmake realize that the include dir exists
file(MAKE_DIRECTORY "${OPENSSL_INCLUDE_DIR}")
add_library(OpenSSL::SSL STATIC IMPORTED)
set_property(TARGET OpenSSL::SSL
					 APPEND
					 PROPERTY INTERFACE_INCLUDE_DIRECTORIES
					 "${OPENSSL_INCLUDE_DIR}")
set_property(TARGET OpenSSL::SSL
					 APPEND
					 PROPERTY IMPORTED_LOCATION "${OPENSSL_SSL_LIB}")
					 
add_library(OpenSSL::Crypto STATIC IMPORTED)
set_property(TARGET OpenSSL::Crypto
					 APPEND
					 PROPERTY INTERFACE_INCLUDE_DIRECTORIES
					 "${OPENSSL_INCLUDE_DIR}")
set_property(TARGET OpenSSL::Crypto
					 APPEND
					 PROPERTY IMPORTED_LOCATION "${OPENSSL_CRYPTO_LIB}")
					 
if(NOT ${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	set_property(TARGET OpenSSL::Crypto
						 APPEND
						 PROPERTY INTERFACE_LINK_LIBRARIES
						 Threads::Threads)
	
endif(NOT ${CMAKE_SYSTEM_NAME} MATCHES "Windows")      

