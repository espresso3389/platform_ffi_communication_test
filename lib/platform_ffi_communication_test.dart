import 'dart:async';
import 'dart:ffi';
import 'package:flutter/services.dart';

typedef Pfc_AllocateData = Uint64 Function(Uint64 size);
typedef AllocateData = int Function(int size);
typedef Pfc_PtrFromData = Pointer<Uint8> Function(Uint64 data);
typedef PtrFromData = Pointer<Uint8> Function(int data);
typedef Pfc_ReleaseData = Void Function(Uint64 data);
typedef ReleaseData = void Function(int data);

class FfiTest {
  static final _lib = DynamicLibrary.process();

  static final allocateData = _lib.lookupFunction<Pfc_AllocateData, AllocateData>('pfc_allocateData');
  static final ptrFromData  = _lib.lookupFunction<Pfc_PtrFromData, PtrFromData>('pfc_ptrFromData');
  static final releaseData  = _lib.lookupFunction<Pfc_ReleaseData, ReleaseData>('pfc_releaseData');

  static int test() {
    final size = 1024 * 1024;
    final buf = allocateData(size);
    final ptr = ptrFromData(buf);
    final arr = ptr.asTypedList(size);
    for (int i = 0; i < size; i++) {
      arr[i] = i;
    }
    int sum = 0;
    for (int i = 0; i < size; i++) {
      sum += arr[i];
    }
    print('sum=$sum');

    int addr = ptr.address;
    releaseData(buf);
    return addr;
  }
}

class PlatformFfiCommunicationTest {
  static const MethodChannel _channel =
      const MethodChannel('platform_ffi_communication_test');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> allocate(int size) async {
    return await _channel.invokeMethod('allocate', size);
  }
}
