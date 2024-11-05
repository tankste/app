import 'dart:io';

import 'package:core/log/feature_filter.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final MemoryOutput memoryOutput = MemoryOutput();

class Log {
  static File? _logFile;
  static Logger? _logger;

  static init() async {
    Directory tempDir = await getTemporaryDirectory();
    _logFile = File(
        "${tempDir.path}${Platform.pathSeparator}${DateTime.now().millisecondsSinceEpoch}_tankste_log.txt");

    _logger = Logger(
        filter: FeatureFilter(),
        output: MultiOutput([
          ConsoleOutput(),
          memoryOutput,
          FileOutput(file: _logFile!, overrideExisting: true)
        ]),
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 200,
          colors: false,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.dateAndTime,
        ),
        level: Level.all);
  }

  static File? getFile() {
    return _logFile;
  }

  static void d(String message) {
    _logger?.d(message);
  }

  static void i(String message) {
    _logger?.i(message);
  }

  static void w(String message) {
    _logger?.w(message);
  }

  static void e(String message) {
    _logger?.e(message);
  }

  static void exception(Exception exception) {
    _logger?.t(exception);
  }
}
