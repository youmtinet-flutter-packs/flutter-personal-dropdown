import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'personal_dropdown_method_channel.dart';

abstract class PersonalDropdownPlatform extends PlatformInterface {
  /// Constructs a PersonalDropdownPlatform.
  PersonalDropdownPlatform() : super(token: _token);

  static final Object _token = Object();

  static PersonalDropdownPlatform _instance = MethodChannelPersonalDropdown();

  /// The default instance of [PersonalDropdownPlatform] to use.
  ///
  /// Defaults to [MethodChannelPersonalDropdown].
  static PersonalDropdownPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PersonalDropdownPlatform] when
  /// they register themselves.
  static set instance(PersonalDropdownPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
