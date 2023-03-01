import 'dart:async';

import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../faker_extensions.dart';

void main() {
  group('constructor', () {
    test('should listen for logs from the stream', () async {
      // arrange
      final logStreamController = StreamController<LogRecord>.broadcast();
      final logRecord1 = faker.logRecord();
      final logRecord2 = faker.logRecord();
      final logRecord3 = faker.logRecord();

      // act
      final controller = StreamedLogsController(
        logs: logStreamController.stream,
      );

      // arrange 2
      logStreamController.add(logRecord1);
      logStreamController.add(logRecord2);
      logStreamController.add(logRecord3);
      await Future.delayed(const Duration(milliseconds: 1));

      // act
      expect(controller.value, [logRecord1, logRecord2, logRecord3]);
    });
  });

  group('dispose', () {
    test('should cancel subscription', () async {
      // arrange
      final mockStreamSubscription = MockStreamSubscription<LogRecord>();
      final mockStream = MockStream<LogRecord>();
      when(() => mockStream.listen(any()))
          .thenAnswer((i) => mockStreamSubscription);
      when(() => mockStreamSubscription.cancel())
          .thenAnswer((i) => Future.value());
      final controller = StreamedLogsController(logs: mockStream);

      // act
      controller.dispose();
      await Future.delayed(const Duration(milliseconds: 1));

      // assert
      verify(() => mockStreamSubscription.cancel());
    });
  });
}

class MockStream<T> extends Mock implements Stream<T> {}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {}
