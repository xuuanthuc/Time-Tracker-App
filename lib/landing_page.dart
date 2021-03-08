import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bottom_navigator_bar.dart';
import 'screens/authentication/views/sign_in_view.dart';
import 'services/auth.dart';
import 'services/database.dart';

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
            child: BottomNavigator(
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
