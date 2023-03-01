import 'package:flutter_fox_logging/src/field_visibilities.dart';
import 'package:flutter_test/flutter_test.dart';

import '../faker_extensions.dart';

void main() {
  group('constructor', () {
    test('should set default values', () {
      // act
      const visibilities = LogFieldVisibilities();

      // assert
      expect(visibilities.icon, isFalse);
      expect(visibilities.loggerName, isTrue);
      expect(visibilities.time, isTrue);
    });

    test('should set provided fields', () {
      // arrange
      final fakeIcon = faker.randomGenerator.boolean();
      final fakeLoggerName = faker.randomGenerator.boolean();
      final fakeTime = faker.randomGenerator.boolean();

      // act
      final visibilities = LogFieldVisibilities(
        loggerName: fakeLoggerName,
        icon: fakeIcon,
        time: fakeTime,
      );

      // assert
      expect(visibilities.icon, fakeIcon);
      expect(visibilities.loggerName, fakeLoggerName);
      expect(visibilities.time, fakeTime);
    });
  });
}
