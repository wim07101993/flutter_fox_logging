import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:mocktail/mocktail.dart';

class MockLogsController extends Mock implements LogsController {}

class MockValueNotifier<T> extends Mock implements ValueNotifier<T> {}

class MockListener extends Mock implements _Listener {}

class _Listener {
  void call() {}
}
