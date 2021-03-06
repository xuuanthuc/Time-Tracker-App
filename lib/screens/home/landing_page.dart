import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/screens/authentication/views/sign_in_view.dart';
import 'package:time_tracker_app/screens/home/views/job_page.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInView.create(context);
          }
          return Provider<Database>(
            create: (_) => FirebaseDatabase(uid: user.uid),
            child: JobsPage(
              auth: auth,
            ),
          );
        } else {
          return Scaffold(
              backgroundColor: Colors.grey[200],
              body: Center(
                child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}
