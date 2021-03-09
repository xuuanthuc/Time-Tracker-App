import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/screens/account/widgets/avatar.dart';
import 'package:time_tracker_app/services/auth.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context);
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
                  _signOut(context);
                },
                child: Text('YES'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        centerTitle: true,
        actions: [
          FlatButton(
              onPressed: () => _confirmSignOut(context),
              child: Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              ))
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: _buildUserInfo(user),
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          AvatarAccount(photoUrl: user.photoUrl,),
          SizedBox(
            height: 20,
          ),
          Text(user.displayName != null ? user.displayName : 'Current User', style: TextStyle(color: Colors.white, fontSize: 18),),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
