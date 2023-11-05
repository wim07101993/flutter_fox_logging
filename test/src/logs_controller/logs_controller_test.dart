import 'package:flutter/foundation.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../faker_extensions.dart';
import '../../mocks.dart';

void main() {
  late ValueNotifier<Level> fakeMinimumLevel;
  late ValueNotifier<Map<String, bool>> fakeLoggers;

  late LogsController controller;

  setUp(() {
    fakeMinimumLevel = ValueNotifier(Level.ALL);
    fakeLoggers = ValueNotifier(const {});
    controller = LogsController(
      minimumLevel: fakeMinimumLevel,
      loggers: fakeLoggers,
    );
  });

  group('constructor', () {
    test('should set minimum-level', () {
      // arrange
      final minimumLevel = ValueNotifier(faker.logLevel());

      // act
      final controller = LogsController(minimumLevel: minimumLevel);

      // assert
      expect(controller.minimumLevel, minimumLevel);
    });

    test('should set loggers', () {
      // arrange
      final loggers = ValueNotifier({
        for (var i = 0; i < faker.randomGenerator.integer(10); i++)
          faker.lorem.word(): faker.randomGenerator.boolean(),
      });

      // act
      final controller = LogsController(loggers: loggers);

      // assert
      expect(controller.loggers, loggers);
    });

    test('should create a log collection with max size 1000', () {
      // act
      final controller = LogsController();

      // assert
      expect(controller.value, isEmpty);
      for (var i = 0; i < 1000; i++) {
        controller.addLog(faker.logRecord());
      }
      expect(controller.value.length, 1000);

      // arrange 2
      final secondLogRecord = controller.value.toList(growable: false)[1];
      final lastLogRecord = faker.logRecord();

      // act 2
      controller.addLog(lastLogRecord);

      // assert 2
      expect(controller.value.length, 1000);
      expect(controller.value.first, secondLogRecord);
      expect(controller.value.last, lastLogRecord);
    });

    test('should set default values', () {
      // act
      final controller = LogsController();

      // assert
      expect(controller.value, isNotNull);
      expect(controller.minimumLevel.value, Level.ALL);
    });

    test('should notify listeners when minimum level changes', () {
      // arrange
      final listener = MockListener();
      final minimumLevel = ValueNotifier(faker.logLevel());
      final controller = LogsController(minimumLevel: minimumLevel);
      controller.addListener(listener.call);

      // act
      minimumLevel.value = faker.logLevel(minimumLevel.value);

      // assert
      verify(() => listener());
    });

    test('should notify listeners when loggers changes', () {
      // arrange
      final listener = MockListener();
      final loggers = ValueNotifier<Map<String, bool>>(const {});
      final controller = LogsController(loggers: loggers);
      controller.addListener(listener.call);

      // act
      loggers.value = {
        faker.lorem.word(): faker.randomGenerator.boolean(),
      };

      // assert
      verify(() => listener());
    });
  });

  group('get value', () {
    test('should return a list of the filtered logs', () {
      // arrange
      const visibleLoggerName = 'visible';
      const invisibleLoggerName = 'invisible';
      final visibleLog = faker.logRecord(
        level: Level.WARNING,
        loggerName: visibleLoggerName,
      );
      final fineLog = faker.logRecord(
        level: Level.FINE,
        loggerName: visibleLoggerName,
      );
      final invisibleLog = faker.logRecord(
        level: Level.SEVERE,
        loggerName: invisibleLoggerName,
      );
      controller.addLog(visibleLog);
      controller.addLog(fineLog);
      controller.addLog(invisibleLog);

      controller.loggers.value = {
        visibleLoggerName: true,
        invisibleLoggerName: false,
      };
      controller.minimumLevel.value = Level.WARNING;

      // act
      final logs = controller.value;

      // assert
      expect(logs, contains(visibleLog));
      expect(logs, isNot(contains(fineLog)));
      expect(logs, isNot(contains(invisibleLog)));

      // act 2
      controller.minimumLevel.value = Level.FINE;

      // assert 2
      expect(logs, contains(visibleLog));
      expect(logs, contains(fineLog));
      expect(logs, isNot(contains(invisibleLog)));

      // act 3
      controller.minimumLevel.value = Level.WARNING;
      controller.loggers.value = {
        visibleLoggerName: true,
        invisibleLoggerName: true,
      };

      // assert 3
      expect(logs, contains(visibleLog));
      expect(logs, isNot(contains(fineLog)));
      expect(logs, contains(invisibleLog));

      // act 3
      controller.minimumLevel.value = Level.ALL;
      controller.loggers.value = {
        visibleLoggerName: true,
        invisibleLoggerName: true,
      };

      // assert 3
      expect(logs, contains(visibleLog));
      expect(logs, contains(fineLog));
      expect(logs, contains(invisibleLog));
    });
  });

  group('set value', () {
    test('should convert logs-list to circular buffer', () {
      // arrange
      final logs = faker.randomGenerator.amount(
        (i) => faker.logRecord(),
        LogsController.maxLogCount,
      );
      final firstLog = logs[0];

      // act
      controller.value = logs;

      // assert
      logs.clear();
      expect(controller.value, isNotEmpty);
      expect(controller.value.first, firstLog);
    });

    test('should create a log collection with max size 1000', () {
      // act
      controller.value = List.generate(1001, (index) => faker.logRecord());

      // assert
      expect(controller.value.length, 1000);

      // arrange 2
      final secondLogRecord = controller.value.toList(growable: false)[1];
      final lastLogRecord = faker.logRecord();

      // act 2
      controller.addLog(lastLogRecord);

      // assert 2
      expect(controller.value.length, 1000);
      expect(controller.value.first, secondLogRecord);
      expect(controller.value.last, lastLogRecord);
    });

    test('should notify listeners', () {
      // arrange
      final mockListener = MockListener();
      final logs = List.generate(
        faker.randomGenerator.integer(10),
        (index) => faker.logRecord(),
      );
      controller.addListener(mockListener.call);

      // act
      controller.value = logs;

      // assert
      verify(() => mockListener());
    });
  });

  group('get allLoggers', () {
    test('should get all the distinct loggers of the logs', () {
      // arrange
      final logs = [
        faker.logRecord(loggerName: 'logger1'),
        faker.logRecord(loggerName: 'logger1'),
        faker.logRecord(loggerName: 'logger1'),
        faker.logRecord(loggerName: 'logger2'),
        faker.logRecord(loggerName: 'logger2'),
        faker.logRecord(loggerName: 'logger3'),
        faker.logRecord(loggerName: 'logger3'),
        faker.logRecord(loggerName: 'logger4'),
      ];
      controller.value = logs;

      // act
      final allLoggers = controller.allLoggers;

      // assert
      expect(allLoggers, contains('logger1'));
      expect(allLoggers, contains('logger2'));
      expect(allLoggers, contains('logger3'));
      expect(allLoggers, contains('logger4'));
      expect(allLoggers, hasLength(4));
    });
  });

  group('addLog', () {
    late String fakeLoggerName;
    late LogRecord fakeLogRecord;
    late ValueNotifier<Map<String, bool>> fakeLoggers;

    late LogsController controller;

    setUp(() {
      fakeLoggerName = faker.lorem.word();
      fakeLoggers = ValueNotifier({fakeLoggerName: true});
      fakeLogRecord = faker.logRecord(loggerName: fakeLoggerName);

      controller = LogsController(loggers: fakeLoggers);
    });

    test('should add a log to the list', () {
      // act
      controller.addLog(fakeLogRecord);

      // assert
      expect(controller.value, contains(fakeLogRecord));
    });

    test('should notify listeners', () {
      // arrange
      final mockListener = MockListener();
      controller.addListener(mockListener.call);

      // act
      controller.addLog(fakeLogRecord);

      // assert
      verify(() => mockListener());
    });
  });

  group('dispose', () {
    test('should remove all minimumLevel listeners', () {
      // arrange
      fakeMinimumLevel = MockValueNotifier();
      final controller = LogsController(minimumLevel: fakeMinimumLevel);

      // act
      controller.dispose();

      // assert
      verify(() => fakeMinimumLevel.removeListener(controller.notifyListeners));
    });

    test('should remove all loggers listeners', () {
      // arrange
      fakeLoggers = MockValueNotifier();
      final controller = LogsController(loggers: fakeLoggers);

      // act
      controller.dispose();

      // assert
      verify(() => fakeLoggers.removeListener(controller.notifyListeners));
    });
  });

  group('applyFilter', () {
    test('should check whether the level is high enough', () {
      // arrange
      final level = faker.logLevel();
      final loggerName = faker.lorem.word();
      fakeMinimumLevel.value = level;
      fakeLoggers.value = {loggerName: true};

      final tooLow = faker.logRecord(
        level: Level(faker.lorem.word(), level.value - 1),
        loggerName: loggerName,
      );
      final justGood = faker.logRecord(
        level: Level(faker.lorem.word(), level.value),
        loggerName: loggerName,
      );
      final higher = faker.logRecord(
        level: Level(faker.lorem.word(), level.value + 1),
        loggerName: loggerName,
      );

      // assert
      expect(controller.applyFilter(tooLow), isFalse);
      expect(controller.applyFilter(justGood), isTrue);
      expect(controller.applyFilter(higher), isTrue);
    });

    test('should check whether the logger should be shown', () {
      // arrange
      final loggerName = faker.lorem.word();
      fakeMinimumLevel.value = Level.ALL;
      fakeLoggers.value = {loggerName: true};

      final invisible = faker.logRecord(
        loggerName: faker.lorem.sentence(),
      );
      final visible = faker.logRecord(
        loggerName: loggerName,
      );

      // assert
      expect(controller.applyFilter(invisible), isFalse);
      expect(controller.applyFilter(visible), isTrue);
    });
  });
}
