import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class INetworkInfo {
  Future<bool> get isConnected;
}

final networkInfoProvider = Provider<INetworkInfo>((ref) {
  final connectivity = Connectivity();
  return NetworkInfo(connectivity);
});

class NetworkInfo implements INetworkInfo {
  final Connectivity _connectivity;
  NetworkInfo(this._connectivity);

  @override
  Future<bool> get isConnected async {
    // Implement actual connectivity check logic here
    final result = await _connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    }
    return await _internetchha(); // Placeholder implementation
  }

  Future<bool> _internetchha() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
