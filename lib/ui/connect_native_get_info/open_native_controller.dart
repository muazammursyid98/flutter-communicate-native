import 'dart:async';
import 'dart:io';

import 'package:flutter_structure_app/BaseController.dart';
import 'package:flutter_structure_app/ui/connect_native_get_info/environment/environment_channel_service_location.dart';
import 'environment/environment_activity.dart';

class OpenNativeController extends BaseController {
  final String TAG = "OpenNativeController";
  bool isAvailable = false;

  String resultReading = "";
  String resultLocation = "";

  final environmentActivity = EnvironmentActivity();
  final EnvironmentChannelServiceLocation environmentLocation =
      EnvironmentChannelServiceLocation();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //receive by Method Channel
    environmentActivity.getMethodChannel().setMethodCallHandler((call) {
      if (call.method == EnvironmentActivity.resultMethod) {
        String result = call.arguments[EnvironmentActivity.argumentName];
        resultReading = result;
        update();
      }
      return Future.value(null);
    });

    //receive by Event Channel
    if(Platform.isAndroid){
      environmentLocation.resultSubscription =
          environmentLocation.result.listen((event) {
            resultLocation = event;
            update();
          });
    }
  }

  void startReading() async {
    print("startReading");
    isAvailable = await environmentActivity.openNativeView();
    update();
  }

  void startTracking() async {
    await environmentLocation.startTracking();
  }

  void stopTracking() async {
    await environmentLocation.stopTracking();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    environmentActivity.tearDown();
    environmentLocation.tearDown();
    super.dispose();
  }
}
