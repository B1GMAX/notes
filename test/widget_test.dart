// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notes/main.dart';

class Other {
  void doSomething(JFrame jFrame) {
    print('frame-$jFrame');
  }
}

class JFrame {}

class MyFrame extends JFrame {
  Other other = Other();

  void method() {
    other.doSomething(this);
    print('this-$this');
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    MyFrame().method();

  });
}
