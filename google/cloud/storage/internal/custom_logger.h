//
// Created by Francis Maher on 2020-05-05.
//

#ifndef GOOGLE_CLOUD_CPP_CUSTOM_LOGGER_H
#define GOOGLE_CLOUD_CPP_CUSTOM_LOGGER_H

#include <string>
#include <iostream>
#include <fstream>

void static log_string_to_custom_file(const std::string &prefix, const std::string &log_line) {
  std::ofstream myfile;
  myfile.open("/Users/fmaher/Logs/dds_object_agnt_gcscppsdk.log", std::ios::out | std::ios::app);
  myfile << prefix << ": " << log_line << std::endl;
  myfile.close();
}

void static log_string_to_custom_file(const char* prefix, const char* log_line) {
  log_string_to_custom_file(std::string(prefix), std::string(log_line));
}

#endif  // GOOGLE_CLOUD_CPP_CUSTOM_LOGGER_H
