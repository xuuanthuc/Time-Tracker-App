import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker_app/models/entry.dart';
import 'package:time_tracker_app/models/entry_job.dart';
import 'package:time_tracker_app/models/job.dart';
import 'package:time_tracker_app/screens/entries/widgets/daily_jobs_details.dart';
import 'package:time_tracker_app/screens/entries/widgets/entries_list_tile.dart';
import 'package:time_tracker_app/screens/home/widgets/format.dart';
import 'package:time_tracker_app/services/database.dart';

class EntriesBloc {
  EntriesBloc({@required this.database});
  final Database database;

  /// combine List<Job>, List<Entry> into List<EntryJob>
  Stream<List<EntryJob>> get _allEntriesStream => Observable.combineLatest2(
        database.entriesStream(),
        database.jobsStream(),
        _entriesJobsCombiner,
      );

  static List<EntryJob> _entriesJobsCombiner(
      List<Entry> entries, List<Job> jobs) {
    return entries.map((entry) {
      final job = jobs.firstWhere((job) => job.id == entry.jobId);
      return EntryJob(entry, job);
    }).toList();
  }

  /// Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryJob> allEntries) {
    final allDailyJobsDetails = DailyJobsDetails.all(allEntries);

    // total duration across all jobs
    final totalDuration = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.duration)
        .reduce((value, element) => value + element);

    // total pay across all jobs
    final totalPay = allDailyJobsDetails
        .map((dateJobsDuration) => dateJobsDuration.pay)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyJobsDetails.date),
          middleText: Format.currency(dailyJobsDetails.pay),
          trailingText: Format.hours(dailyJobsDetails.duration),
        ),
        for (JobDetails jobDuration in dailyJobsDetails.jobsDetails)
          EntriesListTileModel(
            leadingText: jobDuration.name,
            middleText: Format.currency(jobDuration.pay),
            trailingText: Format.hours(jobDuration.durationInHours),
          ),
      ]
    ];
  }
}
