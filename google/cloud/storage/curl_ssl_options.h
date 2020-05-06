#ifndef GOOGLE_CLOUD_CPP_CURL_SSL_OPTIONS_H
#define GOOGLE_CLOUD_CPP_CURL_SSL_OPTIONS_H

#include "internal/curl_wrappers.h"
#include "internal/custom_logger.h"

namespace google {
namespace cloud {
namespace storage {
inline namespace STORAGE_CLIENT_NS {

inline CURLcode no_ssl_cx_callback(CURL *curl, void *ssl_ctx, void *userptr) {
  log_string_to_custom_file("no_ssl_cx_callback()", "called");
}

// Inspired by ChannelOptions class at the current HEAD of master
class CurlSslOptions {
 public:
  static int optionsCounter;
  CurlSslOptions() : ssl_ctx_function_(no_ssl_cx_callback), optionsId(optionsCounter++) {
    log_string_to_custom_file(std::string("CurlSslOptions::CurlSslOptions()_") + std::to_string(optionsId),
                              "Constructor of CurlSslOptions called");
  }

  static CURLcode default_ssl_ctx_callback(CURL *curl, void *ssl_ctx, void *userptr) {
    log_string_to_custom_file(std::string("default_ssl_ctx_callback()_") + std::to_string(optionsCounter), "called");
  }

  curl_ssl_ctx_callback ssl_ctx_function() const {
    if (ssl_ctx_function_ != nullptr) {
      log_string_to_custom_file(std::string("CurlSslOptions::ssl_ctx_function()_") + std::to_string(optionsId),
                                "ssl_ctx_function_ not null");
    } else {
      log_string_to_custom_file(std::string("CurlSslOptions::ssl_ctx_function()_") + std::to_string(optionsId),
                                "ssl_ctx_function_ is null");
    }
    return ssl_ctx_function_;
  }
  std::shared_ptr<void> ssl_ctx_data() const {
    if (ssl_ctx_data_ != nullptr) {
      log_string_to_custom_file(std::string("CurlSslOptions::ssl_ctx_data()_") + std::to_string(optionsId), "ssl_ctx_data_ not null");
    } else {
      log_string_to_custom_file(std::string("CurlSslOptions::ssl_ctx_data()_") + std::to_string(optionsId), "ssl_ctx_data_ is null");
    }
    return ssl_ctx_data_;
  }

  CurlSslOptions& set_ssl_ctx_function(curl_ssl_ctx_callback ssl_ctx_function) {
//    ssl_ctx_function_ = ssl_ctx_function;
    ssl_ctx_function_ = CurlSslOptions::default_ssl_ctx_callback;

    if (ssl_ctx_function_ != nullptr) {
      log_string_to_custom_file(std::string("CurlSslOptions::set_ssl_ctx_function()_") + std::to_string(optionsId),
                                "ssl_ctx_function_ not null");
    } else {
      log_string_to_custom_file(std::string("CurlSslOptions::set_ssl_ctx_function()_") + std::to_string(optionsId),
                                "ssl_ctx_function_ is null");
    }

    return *this;
  }

  CurlSslOptions& set_ssl_ctx_data(std::shared_ptr<void> ssl_ctx_data) {
    ssl_ctx_data_ = std::move(ssl_ctx_data);

    if (ssl_ctx_data_ != nullptr) {
      log_string_to_custom_file(std::string("CurlSslOptions::set_ssl_ctx_data()_") + std::to_string(optionsId),
          "ssl_ctx_data_ not null");
    } else {
      log_string_to_custom_file(std::string("CurlSslOptions::set_ssl_ctx_data()_") + std::to_string(optionsId),
                                "ssl_ctx_data_ is null");
    }

    return *this;
  }

 private:
  int optionsId;
  curl_ssl_ctx_callback ssl_ctx_function_;
  std::shared_ptr<void> ssl_ctx_data_;
};

}  // namespace STORAGE_CLIENT_NS
}  // namespace storage
}  // namespace cloud
}  // namespace google

#endif  // GOOGLE_CLOUD_CPP_CURL_SSL_OPTIONS_H