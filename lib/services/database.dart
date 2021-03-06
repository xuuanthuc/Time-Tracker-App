import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/models/job.dart';

import 'api_path.dart';

abstract class Database{
  Future<void> createJobs(Job job);
}
class FirebaseDatabase implements Database{
  FirebaseDatabase({@required this.uid, @required this.jobId}) : assert(uid != null);
  final String uid;
  final String jobId;

  Future<void> createJobs(Job job) async
  // {
  //   final path = APIPath.job(uid, 'job_123');
  //
  //   final documentReference = Firestore.instance.document(path);  //tham chieu tai lieu
  //   //ghi du lieu vao vi tri tham chieu
  //   await documentReference.setData(job.toMap());
  // }
  => await _setData(path: APIPath.job(uid, 'job_12'),data: job.toMap());
  Future<void> _setData({String path, Map<String, dynamic> data}) async{
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }
}