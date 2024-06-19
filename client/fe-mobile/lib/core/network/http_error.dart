import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ErrorProcessing {
  Object handlerError(dynamic e);
}

class ErrorProcessingImp extends ErrorProcessing {
  @override
  Object handlerError(e) {
    return UnimplementedError(e.toString());
  }
}

final errorProcessingProvider = Provider((ref) => ErrorProcessingImp());
