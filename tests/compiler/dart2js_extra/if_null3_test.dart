// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Regression for #24135: inference was not tracking `[]??=` correctly.
library tests.compiler.dart2js_extra.if_null3_test;

import "package:expect/expect.dart";

void main() {
  var map;
  (((map ??= {})['key1'] ??= {})['key2'] ??= {})['key3'] = 'value';
  Expect.equals('{key1: {key2: {key3: value}}}', '$map');
}
