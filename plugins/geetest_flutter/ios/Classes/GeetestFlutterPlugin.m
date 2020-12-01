#import "GeetestFlutterPlugin.h"
#if __has_include(<geetest_flutter/geetest_flutter-Swift.h>)
#import <geetest_flutter/geetest_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "geetest_flutter-Swift.h"
#endif

@implementation GeetestFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftGeetestFlutterPlugin registerWithRegistrar:registrar];
}
@end
