class LogFieldVisibilities {
  const LogFieldVisibilities({
    this.icon = false,
    this.loggerName = true,
    this.time = true,
  });

  final bool icon;
  final bool loggerName;
  final bool time;

  LogFieldVisibilities copyWithIcon({required bool icon}) {
    return LogFieldVisibilities(
      icon: icon,
      loggerName: loggerName,
      time: time,
    );
  }

  LogFieldVisibilities copyWithLoggerName({required bool loggerName}) {
    return LogFieldVisibilities(
      icon: icon,
      loggerName: loggerName,
      time: time,
    );
  }

  LogFieldVisibilities copyWithTime({required bool time}) {
    return LogFieldVisibilities(
      icon: icon,
      loggerName: loggerName,
      time: time,
    );
  }
}
