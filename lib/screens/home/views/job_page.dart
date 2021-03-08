import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/models/job.dart';
import 'package:time_tracker_app/screens/home/views/edit_job_page.dart';
import 'package:time_tracker_app/screens/home/widgets/job_list_tile.dart';
import 'package:time_tracker_app/screens/home/widgets/list_job_builder.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';

class JobsPage extends StatelessWidget {
  final AuthBase auth;

  JobsPage({@required this.auth});

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Sign Out'),
            content: Text('Are you sure that you want to logout?'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () async {
                  await Navigator.of(context).pop();
                  _signOut();
                },
                child: Text('YES'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Jobs'),
        actions: [
          FlatButton.icon(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () => _confirmSignOut(context),
            label: Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditJobPage.show(context),
      ),
      body: _buildContent(context),
      backgroundColor: Colors.white,
    );
  }
}

Widget _buildContent(BuildContext context) {
  final database = Provider.of<Database>(context);
  database.jobsStream();
  return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, index) => Dismissible(
            key: ValueKey(index),
            background: Container(
              margin: EdgeInsets.only(bottom: 8),
              color: Colors.redAccent,
            ),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) {
              //tra ve gia tri xac nhan true hay false, true thi tiep tuc thuc hien
              return showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Are you sure??'),
                        content: Text('Delete your order!'),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(ctx)
                                    .pop(false); //tra lai ket qua vi false
                              },
                              child: Text('No')),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop(
                                    true); // tro ve nhung tiep tuc thuc hien cau lenh onDismiss
                              },
                              child: Text('Yes')),
                        ],
                      ));
            },
            onDismissed: (dismiss) => _delete(context, index),
            child: JobListTile(
              job: index,
              onTap: () => EditJobPage.show(context, job: index),
            ),
          ),
        );
      });
}

Future<void> _delete(BuildContext context, Job job) async {
  final database = Provider.of<Database>(context);
  await database.delete(job);
}
