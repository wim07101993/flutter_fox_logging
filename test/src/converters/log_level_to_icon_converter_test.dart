import 'package:flutter/material.dart';
import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const IconData fakeDefault = IconData(0xe000);
  const IconData fakeFinest = IconData(0xe001);
  const IconData fakeFiner = IconData(0xe002);
  const IconData fakeFine = IconData(0xe003);
  const IconData fakeConfig = IconData(0xe004);
  const IconData fakeInfo = IconData(0xe005);
  const IconData fakeWarning = IconData(0xe006);
  const IconData fakeSevere = IconData(0xe007);
  const IconData fakeShout = IconData(0xe008);

  late LogLevelToIconConverter converter;

  setUp(() {
    converter = const LogLevelToIconConverter(
      defaultValue: fakeDefault,
      finest: fakeFinest,
      finer: fakeFiner,
      fine: fakeFine,
      config: fakeConfig,
      info: fakeInfo,
      warning: fakeWarning,
      severe: fakeSevere,
      shout: fakeShout,
    );
  });

  test('should be a [LogLevelConverter]', () {
    expect(converter, isA<LogLevelConverter<IconData?>>());
  });

  group('constructor', () {
    test('should set the fields', () {
      expect(converter.defaultValue, fakeDefault);
      expect(converter.finest, fakeFinest);
      expect(converter.finer, fakeFiner);
      expect(converter.fine, fakeFine);
      expect(converter.config, fakeConfig);
      expect(converter.info, fakeInfo);
      expect(converter.warning, fakeWarning);
      expect(converter.severe, fakeSevere);
      expect(converter.shout, fakeShout);
    });

    test('should set values to defaults if not given', () {
      // act
      converter = const LogLevelToIconConverter();

      // assert
      expect(converter.finest, Icons.code);
      expect(converter.finer, Icons.bug_report);
      expect(converter.fine, null);
      expect(converter.config, Icons.settings);
      expect(converter.info, Icons.info);
      expect(converter.warning, Icons.warning);
      expect(converter.severe, Icons.error);
      expect(converter.shout, Icons.bolt);
      expect(converter.defaultValue, null);
    });
  });
}
