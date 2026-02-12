import 'dart:async';

import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final _checker = InternetConnectionChecker.instance;
  final _controller = StreamController<InternetConnectionStatus>.broadcast();

  Stream<InternetConnectionStatus> get status =>_checker.onStatusChange;
  Stream<InternetConnectionStatus> get onStatusChange => _controller.stream;

  void init() {
    _checker.onStatusChange.listen((status) {
      _controller.add(status);
    });
  }

  Future<bool> get hasInternet => _checker.hasConnection;
}
