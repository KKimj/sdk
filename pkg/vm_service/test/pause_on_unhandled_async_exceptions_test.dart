// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: unused_catch_clause, empty_catches

import 'package:test/test.dart';
import 'package:vm_service/vm_service.dart';

import 'common/service_test_common.dart';
import 'common/test_helper.dart';

// AUTOGENERATED START
//
// Update these constants by running:
//
// dart pkg/vm_service/test/update_line_numbers.dart pkg/vm_service/test/pause_on_unhandled_async_exceptions_test.dart
//
const LINE_A = 66;
// AUTOGENERATED END

class Foo {}

String doThrow() {
  throw 'TheException';
  // ignore: dead_code
  return 'end of doThrow';
}

Future<void> asyncThrower() async {
  // ignore: await_only_futures
  await 0; // force async gap
  doThrow();
}

Future<void> testeeMain() async {
  try {
    // This is a regression case for https://dartbug.com/53334:
    // we should recognize `then(..., onError: ...)` as a catch
    // all exception handler.
    await asyncThrower().then(
      (v) => v,
      onError: (e, st) {
        // Caught and ignored.
      },
    );

    await asyncThrower().onError((error, stackTrace) {
      // Caught and ignored.
    });

    try {
      await asyncThrower();
    } on String catch (e) {
      // Caught and ignored.
    }

    try {
      await asyncThrower();
    } catch (e) {
      // Caught and ignored.
    }

    // This does not catch the exception.
    try {
      await asyncThrower(); // LINE_A
    } on double catch (e) {}
  } on Foo catch (e) {}
}

final tests = <IsolateTest>[
  hasStoppedWithUnhandledException,
  (VmService service, IsolateRef isolateRef) async {
    final isolateId = isolateRef.id!;
    final stack = await service.getStack(isolateId);
    expect(stack.asyncCausalFrames, isNotNull);
    final asyncStack = stack.asyncCausalFrames!;
    expect(asyncStack.length, greaterThanOrEqualTo(4));
    expect(asyncStack[0].function!.name, 'doThrow');
    expect(asyncStack[1].function!.name, 'asyncThrower');
    expect(asyncStack[2].kind, FrameKind.kAsyncSuspensionMarker);
    expect(asyncStack[3].kind, FrameKind.kAsyncCausal);
    expect(asyncStack[3].function!.name, 'testeeMain');
    expect(asyncStack[3].location!.line, LINE_A);
  },
];

void main([args = const <String>[]]) => runIsolateTests(
      args,
      tests,
      'pause_on_unhandled_async_exceptions_test.dart',
      pauseOnUnhandledExceptions: true,
      testeeConcurrent: testeeMain,
      extraArgs: extraDebuggingArgs,
    );
