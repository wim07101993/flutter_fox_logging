import 'package:flutter_fox_logging/src/logs_controller/logs_controller.dart';
import 'package:fox_logging/fox_logging.dart';

/// A [LogSinkMixin] which writes logs to a [LogsController].
class LogsControllerLogSink with LogSinkMixin {
  /// Creates a sink which adds the log-records [filter] allows through to
  /// the [controller].
  LogsControllerLogSink({
    required this.controller,
    this.filter = const LogFilter.none(),
  });

  /// The controller to add the logs to.
  final LogsController controller;

  @override
  final LogFilter filter;

  @override
  Future<void> write(LogRecord logRecord) {
    controller.addLog(logRecord);
    return Future.value();
  }
}
