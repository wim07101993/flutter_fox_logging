import 'package:flutter_fox_logging/flutter_fox_logging.dart';
import 'package:flutter_fox_logging/src/sink/console_stub.dart'
    if (kIsWeb) 'dart:html';

/// A [LogSinkMixin] which uses the [Console] to write logs to.
class WebConsoleSink extends LogSink {
  WebConsoleSink(
    this.console, [
    super.logFilter,
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
