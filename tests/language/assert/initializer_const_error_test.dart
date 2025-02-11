// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class C {
  static bool check(x, y) => x < y;
  final int x;
  const C(this.x);
  // The expression is not a potentially constant expression.
  // This is a compile-time error even in production mode.
  const C.bc03(this.x, y) : assert(check(x, y));
  //                               ^^^^^^^^^^^
  // [analyzer] COMPILE_TIME_ERROR.INVALID_CONSTANT
  // [cfe] Method invocation is not a constant expression.
}

main() {
  var c = new C.bc03(1, 2);
  if (c.x != 1) throw "non-trivial use of c";
}
