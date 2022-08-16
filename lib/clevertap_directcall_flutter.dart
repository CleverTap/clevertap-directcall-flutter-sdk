
import 'clevertap_directcall_flutter_platform_interface.dart';

class ClevertapDirectcallFlutter {
  Future<String?> getPlatformVersion() {
    return ClevertapDirectcallFlutterPlatform.instance.getPlatformVersion();
  }
}
