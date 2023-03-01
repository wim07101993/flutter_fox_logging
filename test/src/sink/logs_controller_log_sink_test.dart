import 'package:flutter_fox_logging/src/sink/logs_controller_log_sink.dart';
import 'package:flutter_test/flutter_test.dart';
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
}
