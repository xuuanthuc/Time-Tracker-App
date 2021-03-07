import 'package:flutter/material.dart';
import 'package:time_tracker_app/models/job.dart';
class JobListTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  const JobListTile({Key key,@required this.job, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.arrow_right),
      onTap: onTap,
    );
  }
}
