#import "ClevertapDirectcallFlutterPlugin.h"
#if __has_include(<clevertap_directcall_flutter/clevertap_directcall_flutter-Swift.h>)
#import <clevertap_directcall_flutter/clevertap_directcall_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "clevertap_directcall_flutter-Swift.h"
#endif

@implementation ClevertapDirectcallFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftClevertapDirectcallFlutterPlugin registerWithRegistrar:registrar];
}
@end
