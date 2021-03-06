import 'package:flutter/foundation.dart';

class Job{
  Job({@required this.name,@required this.rateHour});
  final String name;
  final int rateHour;
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'rateHour': rateHour,
    };
  }

}