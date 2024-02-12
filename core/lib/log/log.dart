import 'package:core/log/feature_filter.dart';
import 'package:logger/logger.dart';

final MemoryOutput memoryOutput = MemoryOutput();

class Log {
  static final Logger _logger = Logger(
      filter: FeatureFilter(),
      output: MultiOutput(

        [ConsoleOutput(), memoryOutput],
      ),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 200,
        colors: false,
        printEmojis: true,
        printTime: true,
      ),
      level: Level.debug);

  static void d(String message) {
    _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(String message) {
    _logger.e(message);
  }
}
