import 'dart:math';

import 'package:circular_buffer/circular_buffer.dart';
import 'package:flutter/foundation.dart';
import 'package:fox_logging/fox_logging.dart';

class LogsController extends ChangeNotifier
    implements ValueListenable<Iterable<LogRecord>> {
  LogsController({
    ValueNotifier<Level>? minimumLevel,
    ValueNotifier<Map<String, bool>>? loggers,
  })  : _allLogs = CircularBuffer(maxLogCount),
        minimumLevel = minimumLevel ?? ValueNotifier(Level.ALL),
        loggers = loggers ?? ValueNotifier(const {}) {
    this.minimumLevel.addListener(notifyListeners);
    this.loggers.addListener(notifyListeners);
  }

  static const int maxLogCount = 1000;

  final ValueNotifier<Level> minimumLevel;
  final ValueNotifier<Map<String, bool>> loggers;

  List<LogRecord> _allLogs;

  @override
  Iterable<LogRecord> get value => _allLogs.where(applyFilter);

  Iterable<String> get allLoggers => _allLogs.map((l) => l.loggerName).toSet();

  set value(Iterable<LogRecord> value) {
    final newLogs = value.toList(growable: false);
    _allLogs = CircularBuffer.of(
      newLogs.sublist(max(newLogs.length - maxLogCount, 0)),
      maxLogCount,
    );
    notifyListeners();
  }

  void addLog(LogRecord logRecord) {
    _allLogs.add(logRecord);
    notifyListeners();
  }

  void addAllLogs(Iterable<LogRecord> logRecords) {
    _allLogs.addAll(logRecords);
    notifyListeners();
  }

  @override
  void dispose() {
    minimumLevel.removeListener(notifyListeners);
    loggers.removeListener(notifyListeners);
    super.dispose();
  }

  bool applyFilter(LogRecord logRecord) {
    final minimumLevel = this.minimumLevel.value;
    final loggers = this.loggers.value;
    return logRecord.level.value >= minimumLevel.value &&
        (loggers.isEmpty || (loggers[logRecord.loggerName] ?? false));
  }
}
