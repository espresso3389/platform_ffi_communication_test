import Flutter
import UIKit

func dataToInt(_ data: NSMutableData) -> UInt64 {
  let unmanaged = Unmanaged<NSMutableData>.passRetained(data)
  let p = unmanaged.toOpaque()
  return UInt64(UInt(bitPattern: p))
}

@_cdecl("pfc_allocateData")
func allocate(_ size: UInt64) -> UInt64 {
  guard let m = NSMutableData(capacity: Int(truncatingIfNeeded: size)) else { return 0 }
  return dataToInt(m)
}

func int2Data(_ data: UInt64) -> NSMutableData? {
  guard let p = UnsafeMutableRawPointer(bitPattern: UInt(truncatingIfNeeded: data)) else { return nil }
  return Unmanaged<NSMutableData>.fromOpaque(p).takeUnretainedValue()
}

@_cdecl("pfc_ptrFromData")
func int2Ptr(_ data: UInt64) -> UnsafeMutableRawPointer {
  guard let p = UnsafeMutableRawPointer(bitPattern: UInt(truncatingIfNeeded: data)) else { return UnsafeMutableRawPointer(bitPattern: 0)! }
  return Unmanaged<NSMutableData>.fromOpaque(p).takeUnretainedValue().mutableBytes
}

@_cdecl("pfc_releaseData")
func intRelease(_ data: UInt64) {
  guard let p = UnsafeMutableRawPointer(bitPattern: UInt(truncatingIfNeeded: data)) else { return }
  Unmanaged<NSMutableData>.fromOpaque(p).release()
}


public class SwiftPlatformFfiCommunicationTestPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "platform_ffi_communication_test", binaryMessenger: registrar.messenger())
    let instance = SwiftPlatformFfiCommunicationTestPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "test" {
      result(allocate(call.arguments as? UInt64 ?? 0))
    }
    result("iOS " + UIDevice.current.systemVersion)
  }
}
