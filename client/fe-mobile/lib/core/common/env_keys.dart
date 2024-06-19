import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvKeys {
  static String host = "HOST";
  static String scheme = "SCHEME";
  static String geminiHost = "GEMINI_HOST";
  static String geminiScheme = "GEMINI_SCHEME";
}

class EnvironmentLoader {
  static late String host;
  static late String scheme;

  static late String geminiHost;
  static late String geminiScheme;

  EnvironmentLoader._internal();

  static Future<void> load(DotEnv dotEnv) async {
    host = dotEnv.env[EnvKeys.host]!;
    scheme = dotEnv.env[EnvKeys.scheme]!;
    geminiHost = dotEnv.env[EnvKeys.geminiHost]!;
    geminiScheme = dotEnv.env[EnvKeys.geminiScheme]!;
  }
}
