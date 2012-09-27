// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Test that type checks occur on assignment to fields of native methods.

@native("*A")
class A {
  int foo;
}

@native("*B")
class B {
  String foo;
}

@native A makeA() { return new A(); }
@native B makeB() { return new B(); }

@native("""
function A() {}

function B() {}

makeA = function(){return new A;};
makeB = function(){return new B;};
""")
void setup();

expectThrows(action()) {
  bool threw = false;
  try {
    action();
  } catch (e) {
    threw = true;
  }
  Expect.isTrue(threw);
}

checkedModeTest() {
  var things = [makeA(), makeB()];
  var a = things[0];
  var b = things[1];

  a.foo = 123;
  expectThrows(() => a.foo = 'xxx');
  Expect.equals(123, a.foo);

  b.foo = 'hello';
  expectThrows(() => b.foo = 123);
  Expect.equals('hello', b.foo);

  // Check that we throw the same errors when the locals are typed.
  A aa = things[0];
  B bb = things[1];

  aa.foo = 124;
  expectThrows(() => aa.foo = 'xxx');
  Expect.equals(124, aa.foo);

  bb.foo = 'hello';
  expectThrows(() => bb.foo = 124);
  Expect.equals('hello', bb.foo);
}

uncheckedModeTest() {
  var things = [makeA(), makeB()];
  var a = things[0];
  var b = things[1];

  a.foo = 123;
  Expect.equals(123, a.foo);
  a.foo = 'xxx';
  Expect.equals('xxx', a.foo);

  b.foo = 'hello';
  Expect.equals('hello', b.foo);
  b.foo = 123;
  Expect.equals(b.foo, 123);

  // Check that we do not throw errors when the locals are typed.
  A aa = things[0];
  B bb = things[1];

  aa.foo = 124;
  Expect.equals(124, aa.foo);
  a.foo = 'yyy';
  Expect.equals('yyy', a.foo);

  b.foo = 'hello';
  Expect.equals('hello', b.foo);
  b.foo = 124;
  Expect.equals(b.foo, 124);
}

bool isCheckedMode() {
  var stuff = [1, 'string'];
  var a = stuff[0];
  // Checked-mode detection.
  try {
    String s = a;
    return false;
  } catch (e) {
    // Ignore.
  }
  return true;
}

main() {
  setup();

  if (isCheckedMode()) {
    checkedModeTest();
  } else {
    uncheckedModeTest();
  }
}
