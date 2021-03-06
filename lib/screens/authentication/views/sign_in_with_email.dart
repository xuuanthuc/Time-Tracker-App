import 'package:flutter/material.dart';
import 'package:time_tracker_app/screens/authentication/widgets/email_sign_in_form_bloc_base.dart';
import 'package:time_tracker_app/screens/authentication/widgets/sign_in_form.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In With Email'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(child: SignInFormBlocBase.create(context)),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

