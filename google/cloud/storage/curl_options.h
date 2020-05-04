#ifndef GOOGLE_CLOUD_CPP_CURL_OPTIONS_H
#define GOOGLE_CLOUD_CPP_CURL_OPTIONS_H

#include "internal/curl_wrappers.h"

namespace google {
namespace cloud {
namespace storage {
inline namespace STORAGE_CLIENT_NS {

// Inspired by ChannelOptions class at the current HEAD of master
class CurlOptions {
 public:
  CurlOptions() : ssl_ctx_function_(nullptr) {}
  curl_ssl_ctx_callback ssl_ctx_function() const { return ssl_ctx_function_; }
  std::shared_ptr<void> ssl_ctx_data() const { return ssl_ctx_data_; }

  CurlOptions& set_ssl_ctx_function(curl_ssl_ctx_callback ssl_ctx_function) {
    ssl_ctx_function_ = ssl_ctx_function;
    return *this;
  }

  CurlOptions& set_ssl_ctx_data(std::shared_ptr<void> ssl_ctx_data) {
    ssl_ctx_data_ = std::move(ssl_ctx_data);
    return *this;
  }

 private:
  curl_ssl_ctx_callback ssl_ctx_function_;
  std::shared_ptr<void> ssl_ctx_data_;
};

inline std::shared_ptr<CurlOptions> GetDefaultCurlOptions() {
  return std::make_shared<CurlOptions>();
}


}  // namespace STORAGE_CLIENT_NS
}  // namespace storage
}  // namespace cloud
}  // namespace google

#endif  // GOOGLE_CLOUD_CPP_CURL_OPTIONS_H