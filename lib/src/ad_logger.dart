import 'package:flutter/services.dart';

class NendAdLogger {
  /// Setting the log level. Can control the type of output log.
  /// Default value is [NendAdLogLevel.off].
  /// Check [NendAdLogLevel] for details.
  static Future<void> setLogLevel(NendAdLogLevel logLevel) async {
    final channel = MethodChannel('nend_plugin/ad_logger', JSONMethodCodec());
    await channel.invokeMethod('setLogLevel', {'logLevel': logLevel.levelIndex});
    print('level: $logLevel');
  }
}

/// Log level settings are below.
enum NendAdLogLevel {
  /// Output debug info to log.
  debug,

  /// Output info to the log about the successful process, result, etc.
  info,

  /// Output a warning to the log about the no images or invalid parameter, etc.
  warn,

  /// Output an error to the log about the failed process, result, etc.
  error,

  /// Does not output to the log.
  off,
}

extension NendAdLogLevelExtension on NendAdLogLevel {
  static final list = {
    NendAdLogLevel.debug: 1,
    NendAdLogLevel.info: 2,
    NendAdLogLevel.warn: 3,
    NendAdLogLevel.error: 4,
    NendAdLogLevel.off: null
  };

  int? get levelIndex => list[this];
}
