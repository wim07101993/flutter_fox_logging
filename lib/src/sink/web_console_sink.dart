import 'package:flutter_fox_logging/flutter_fox_logging.dart';

export 'package:flutter_fox_logging/src/sink/console_stub.dart'
    if (kIsWeb) 'dart:html';

/// A [LogSinkMixin] which uses the [Console] to write logs to.
class WebConsoleSink with LogSinkMixin {
  /// Creates a sink which writes the log-records [filter] allows through to
  /// the [console].
  WebConsoleSink(
    this.console, [
    this.filter = const LogFilter.none(),
  ]);

  /// The console to write the logs to.
  final Console console;

  @override
  final LogFilter filter;

  @override
  Future<void> write(LogRecord logRecord) {
    if (logRecord.level == Level.FINER || logRecord.level == Level.FINEST) {
      console.debug(logRecord);
    } else if (logRecord.level == Level.INFO) {
      console.info(logRecord);
    } else if (logRecord.level == Level.WARNING) {
      console.warn(logRecord);
    } else if (logRecord.level == Level.SEVERE ||
        logRecord.level == Level.SHOUT) {
      console.error(logRecord);
    } else {
      console.log(logRecord);
    }
    return Future.value();
  }
}
