import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/sink/console_stub.dart';
import 'package:flutter_fox_logging/src/sink/web_console_sink.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../faker_extensions.dart';

void main() {
  late Console mockConsole;
  late WebConsoleSink sink;

  setUp(() {
    mockConsole = MockConsole();

    sink = WebConsoleSink(mockConsole);
  });
  group('write', () {
    test('should write FINEST log levels as debug', () async {
      // arrange
      final fakeLogRecord = faker.logRecord(level: Level.FINEST);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockConsole.debug(fakeLogRecord));
    });

    test('should write FINER log levels as debug', () async {
      // arrange
      final fakeLogRecord = faker.logRecord(level: Level.FINER);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockConsole.debug(fakeLogRecord));
    });

    test('should write FINE log levels as log', () async {
      // arrange
      final fakeLogRecord = faker.logRecord(level: Level.FINE);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockConsole.log(fakeLogRecord));
    });

    test('should write CONFIG log levels as log', () async {
      // arrange
      final fakeLogRecord = faker.logRecord(level: Level.CONFIG);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockConsole.log(fakeLogRecord));
    });

    test('should write INFO log levels as info', () async {
      // arrange
      final fakeLogRecord = faker.logRecord(level: Level.INFO);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockConsole.info(fakeLogRecord));
    });

    test('should write WARNING log levels as warn', () async {
      // arrange
      final fakeLogRecord = faker.logRecord(level: Level.WARNING);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockConsole.warn(fakeLogRecord));
    });

    test('should write SEVERE log levels as error', () async {
      // arrange
      final fakeLogRecord = faker.logRecord(level: Level.SEVERE);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockConsole.error(fakeLogRecord));
    });

    test('should write SHOUT log levels as error', () async {
      // arrange
      final fakeLogRecord = faker.logRecord(level: Level.SHOUT);

      // act
      await sink.write(fakeLogRecord);

      // assert
      verify(() => mockConsole.error(fakeLogRecord));
    });
  });
}

class MockConsole extends Mock implements Console {}
