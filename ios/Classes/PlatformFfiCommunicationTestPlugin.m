#import "PlatformFfiCommunicationTestPlugin.h"
#if __has_include(<platform_ffi_communication_test/platform_ffi_communication_test-Swift.h>)
#import <platform_ffi_communication_test/platform_ffi_communication_test-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "platform_ffi_communication_test-Swift.h"
#endif

@implementation PlatformFfiCommunicationTestPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPlatformFfiCommunicationTestPlugin registerWithRegistrar:registrar];
}
@end
