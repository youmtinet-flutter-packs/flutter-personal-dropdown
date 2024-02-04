import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'personal_dropdown_platform_interface.dart';

/// An implementation of [PersonalDropdownPlatform] that uses method channels.
class MethodChannelPersonalDropdown extends PersonalDropdownPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('personal_dropdown');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
