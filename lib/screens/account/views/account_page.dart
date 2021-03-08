import 'package:flutter/material.dart';
import 'package:time_tracker_app/services/auth.dart';

class AccountPage extends StatelessWidget {
  final AuthBase auth;
  AccountPage({ this.auth});
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
        title: Text('Account'),
        centerTitle: true,
        actions: [
          FlatButton(onPressed:() => _confirmSignOut(context) , child: Text('Log Out', style: TextStyle(color: Colors.white),))
        ],
      ),
    );
  }
}
