import 'dart:async';
import 'package:connectivity/connectivity.dart';

class Reachability extends Object {

  final Connectivity _connectivity = Connectivity();

  // network change subscription
  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult> connectivitySubscription;

  // current network status
  String _connectStatus = 'Unknown';
  String get connectStatus => _connectStatus;

  //Constant for check network status
  static String _connectivityMobile = "ConnectivityResult.mobile";
  static String _connectivityWifi = "ConnectivityResult.wifi";

  factory Reachability() {
    return _singleton;
  }

  static final Reachability _singleton = new Reachability._internal();
  Reachability._internal() {
    connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectStatus = result.toString();
      print("ConnectionStatus :: = $_connectStatus");
      // Stop loader
      if (!isInterNetAvaialble()) {
        // manually disconnect socket
        // SocketProvider().disconnectFromConnectToServer();

      }
      else {
        // Check socket connection
        // SocketProvider().connectToServer();
      }
    });
  }

  dispose() async {
    await this.connectivitySubscription?.cancel();
  }


  //cancel subscription for network change
  unregisterReachbilityChange() async {
    await this.dispose();
  }

  // set up initial
  Future<Null> setUpConnectivity() async {
    String connectionStatus;

    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      print("ConnectionStatus :: => $connectionStatus");
    } on Exception catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }

    _connectStatus = connectionStatus;
    print("ConnectionStatus :: => $_connectStatus");
  }

  // check for network available
  bool isInterNetAvaialble() {
    print("ConnectionStatus :: => $_connectStatus");
    return (_connectStatus == Reachability._connectivityMobile) || (_connectStatus == Reachability._connectivityWifi);
  }

}