import '../common/environment.dart';

abstract class BaseUrl extends EnvironmentData<String> {
  String getUrl() => getData();

  String? get getPemFilePath => null;
}
