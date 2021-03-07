import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:time_tracker_app/models/job.dart';
import 'package:time_tracker_app/services/firestore_services.dart';

import 'api_path.dart';

abstract class Database {
  Future<void> createJobs(Job job);

  Stream<List<Job>> jobsStream();
}

class FirebaseDatabase implements Database {
  FirebaseDatabase({
    @required this.uid,
  }) : assert(uid != null);
  final String uid;
  final _services = FirestoreService.instance;

  Stream<List<Job>> jobsStream() => _services.collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.fromMap(data));

  // {
  //   final path = APIPath.jobs(uid);
  //   final reference = Firestore.instance.collection(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map(
  //     //tao map qua luong snapshot va moi muc ben trong map la mot collection (snapshot)
  //     (snapshot) => snapshot.documents
  //         .map(
  //           //truy cap tai lieu ben collection (snapshot) va goi map de convert map vao mot danh sach Job
  //           (snapshot) => Job.fromMap(snapshot.data),
  //         ).toList());
  //   // snapshots.listen((event) {event.documents.forEach((element) {print(element.data);});});
  // }

  Future<void> createJobs(Job job) async
      // {
      //   final path = APIPath.job(uid, 'job_123');
      //
      //   final documentReference = Firestore.instance.document(path);  //tham chieu tai lieu
      //   //ghi du lieu vao vi tri tham chieu
      //   await documentReference.setData(job.toMap());
      // }
      =>
      await _setData(path: APIPath.job(uid, DateTime.now().toString()), data: job.toMap());

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    await reference.setData(data);
  }
}
