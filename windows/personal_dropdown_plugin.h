#ifndef FLUTTER_PLUGIN_PERSONAL_DROPDOWN_PLUGIN_H_
#define FLUTTER_PLUGIN_PERSONAL_DROPDOWN_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace personal_dropdown {

class PersonalDropdownPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  PersonalDropdownPlugin();

  virtual ~PersonalDropdownPlugin();

  // Disallow copy and assign.
  PersonalDropdownPlugin(const PersonalDropdownPlugin&) = delete;
  PersonalDropdownPlugin& operator=(const PersonalDropdownPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace personal_dropdown

#endif  // FLUTTER_PLUGIN_PERSONAL_DROPDOWN_PLUGIN_H_
