
import 'package:time_tracker_app/models/entry.dart';
import 'package:time_tracker_app/models/job.dart';

class EntryJob {
  EntryJob(this.entry, this.job);

  final Entry entry;
  final Job job;
}
