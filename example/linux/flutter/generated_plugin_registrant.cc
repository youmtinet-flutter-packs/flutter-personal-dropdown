//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <personal_dropdown/personal_dropdown_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) personal_dropdown_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "PersonalDropdownPlugin");
  personal_dropdown_plugin_register_with_registrar(personal_dropdown_registrar);
}
