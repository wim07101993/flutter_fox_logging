// This sink keeps extending the deprecated `LogSink` so consumers who declare
// it as a `LogSink` keep compiling, mirroring what `fox_logging` does with its
// own sinks. The supertype goes away in 3.0.0, with `fox_logging` 2.0.0.
// ignore_for_file: deprecated_member_use

import 'package:flutter_fox_logging/flutter_fox_logging.dart';

export 'package:flutter_fox_logging/src/sink/console_stub.dart'
    if (kIsWeb) 'dart:html';

/// A [LogSinkMixin] which uses the [Console] to write logs to.
class WebConsoleSink extends LogSink {
  /// Creates a sink which writes the log-records [filter] allows through to
  /// the [console].
  WebConsoleSink(
    this.console, [
    super.filter,
  ]);

  /// The console to write the logs to.
  final Console console;

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
