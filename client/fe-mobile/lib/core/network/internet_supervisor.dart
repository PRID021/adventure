import 'package:connectivity/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class InternetSupervisor {
  Future<bool> checkHaveInternet();
}

class InternetSupervisorImp implements InternetSupervisor {
  @override
  Future<bool> checkHaveInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}

final internetSupervisorProvider = Provider((ref) => InternetSupervisorImp());
