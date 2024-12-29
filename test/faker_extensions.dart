import 'dart:async';

import 'package:faker/faker.dart' show Faker, faker;
import 'package:flutter/material.dart';
import 'package:fox_logging/fox_logging.dart';

export 'package:faker/faker.dart' show Faker, faker;

extension FakerExtensions on Faker {
  LogRecord logRecord({
    Level? level,
    String? message,
    String? loggerName,
    Object? error,
    StackTrace? stackTrace,
    Zone? zone,
    Object? object,
  }) {
    return LogRecord(
      level ?? logLevel(),
      message ?? faker.lorem.sentence(),
      loggerName ?? faker.lorem.word(),
      error ?? faker.nullOr(() => faker.lorem.sentence()),
      stackTrace ?? faker.nullOr(() => StackTrace.current),
      zone ?? faker.nullOr(() => Zone.current),
      object ?? faker.nullOr(() => faker.lorem.sentence()),
    );
  }

  Level logLevel([Level? differentFrom]) {
    final value = faker.randomGenerator.integer(Level.OFF.value);
    return Level(
      faker.lorem.word(),
      differentFrom != null && value == differentFrom.value ? value - 1 : value,
    );
  }

  Color color() => Color(faker.randomGenerator.integer(0xFFFFFFFF));

  T? nullOr<T>(T Function() value) {
    return randomGenerator.boolean() ? value() : null;
  }
}
