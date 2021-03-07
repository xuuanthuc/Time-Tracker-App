import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/models/job.dart';
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

  Future<void> _createJobs(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context);
      await database.createJobs(Job(name: 'hello', rateHour: 1));
    } on PlatformException catch (error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Operation failed'),
              content: Text(error.message),
              actions: [
                FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'))
              ],
            );
          });
    }
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
        onPressed: () => _createJobs(context),
      ),
      body: _buildContent(context),
    );
  }
}

Widget _buildContent(BuildContext context) {
  final database = Provider.of<Database>(context);
  database.jobsStream();
  return StreamBuilder<List<Job>>(
    stream: database.jobsStream(),
    builder: (context, snapshot) {
      if(snapshot.hasData){
        final jobs = snapshot.data;
        final children = jobs.map((e) => Text(e.name)).toList();
        return ListView(children: children,);
      } if(snapshot.hasError){
        return Text('Some error occurred');
      }
        return Center(child: CircularProgressIndicator(),);
    }
  );
}