import 'package:flutter_health_connect/flutter_health_connect.dart';

class FitnessDetails {
  List<HealthConnectDataType> types = [HealthConnectDataType.Steps];

  Future<int> fetchTotalSteps() async {
    var now = DateTime.now();

    var startTime = DateTime(now.year, now.month, now.day); // Start of today
    var endTime = DateTime.now();
    final requests = <Future>[];
    Map<String, dynamic> typePoints = {};
    for (var type in types) {
      requests.add(HealthConnectFactory.getRecord(
        type: type,
        startTime: startTime,
        endTime: endTime,
      ).then((value) => typePoints.addAll({type.name: value})));
    }
    await Future.wait(requests);
    var stepList = typePoints['Steps']['records'];
    var totalSteps = 0;
    for (var step in stepList) {
      totalSteps += step['count'] as int;
    }
    if(totalSteps >10000){
      totalSteps = 10000;
    }
    return totalSteps;
  }


}
