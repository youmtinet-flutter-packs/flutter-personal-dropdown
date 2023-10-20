#include "include/personal_dropdown/personal_dropdown_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "personal_dropdown_plugin.h"

void PersonalDropdownPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  personal_dropdown::PersonalDropdownPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
