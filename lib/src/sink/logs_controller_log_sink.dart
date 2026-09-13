// This sink keeps extending the deprecated `LogSink` so consumers who declare
// it as a `LogSink` keep compiling, mirroring what `fox_logging` does with its
// own sinks. The supertype goes away in 3.0.0, with `fox_logging` 2.0.0.
// ignore_for_file: deprecated_member_use

import 'package:flutter_fox_logging/src/logs_controller/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

/// A [LogSinkMixin] which writes logs to a [LogsController].
class LogsControllerLogSink extends LogSink {
  /// Creates a sink which adds the log-records [filter] allows through to
  /// the [controller].
  LogsControllerLogSink({
    required this.controller,
    LogFilter filter = const LogFilter.none(),
  }) : super(filter);

  /// The controller to add the logs to.
  final LogsController controller;

  @override
  Future<void> write(LogRecord logRecord) {
    controller.addLog(logRecord);
    return Future.value();
  }
}
