import 'package:flutter_fox_logging/src/sink/logs_controller_log_sink.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fox_logging/fox_logging.dart';
import 'package:mocktail/mocktail.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late MockLogsController mockController;

  late LogsControllerLogSink sink;

  setUp(() {
    mockController = MockLogsController();

    sink = LogsControllerLogSink(controller: mockController);
  });

  test('should be a [LogSink] until 3.0.0', () {
    // Consumers may declare this sink as a `LogSink`; the supertype stays
    // until `fox_logging` drops it in 2.0.0.
    // ignore: deprecated_member_use
    expect(sink, isA<LogSink>());
  });

  group('constructor', () {
    test('should let every log-record through by default', () {
      expect(sink.filter, isA<NoLogFilter>());
    });

    test('should set the given filter', () {
      // arrange
      const filter = LogFilter.level(Level.WARNING);

      // act
      sink = LogsControllerLogSink(
        controller: mockController,
        filter: filter,
      );

      // assert
      expect(sink.filter, filter);
    });
  });

  group('write', () {
    test('should write the log to the controller', () async {
      // arrange
      final fakeLogRecord = faker.logRecord();

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockController.addLog(fakeLogRecord));
    });
  });

  group('log', () {
    test(
      'should write the log to the controller if the filter allows it',
      () async {
        // arrange
        sink = LogsControllerLogSink(
          controller: mockController,
          filter: const LogFilter.level(Level.WARNING),
        );
        final fakeLogRecord = faker.logRecord(level: Level.SEVERE);

        // act
        await sink.log(fakeLogRecord);

        // assert
        verify(() => mockController.addLog(fakeLogRecord));
      },
    );

    test(
      'should not write the log to the controller if the filter blocks it',
      () async {
        // arrange
        sink = LogsControllerLogSink(
          controller: mockController,
          filter: const LogFilter.level(Level.WARNING),
        );
        final fakeLogRecord = faker.logRecord(level: Level.FINE);

        // act
        await sink.log(fakeLogRecord);

        // assert
        verifyNever(() => mockController.addLog(fakeLogRecord));
      },
    );
  });
}
