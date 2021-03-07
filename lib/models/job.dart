import 'package:flutter/foundation.dart';

class Job {
  Job({@required this.name, @required this.rateHour});

  final String name;
  final int rateHour;

  factory Job.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final int rateHour = data['rateHour'];
    return Job(name: name, rateHour: rateHour);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'rateHour': rateHour,
    };
  }
}
