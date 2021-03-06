import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/blocs/sign_in_bloc.dart';
import 'package:time_tracker_app/screens/authentication/views/sign_in_with_email.dart';
import 'package:time_tracker_app/screens/authentication/widgets/custom_raised_button.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInView extends StatelessWidget {
  final SignInBloc bloc;
  SignInView({@required this.bloc});

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<SignInBloc>(
      dispose: (context, bloc) => bloc.dispose(),
      create: (_) => SignInBloc(auth: auth),
      child: Consumer<SignInBloc>(builder: (context, bloc, _) => SignInView(bloc: bloc,)),
    );
  }

  Future<void> _signInWithAnonymously(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context);
    try {
      await bloc.signInWithAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context);
    try {
      await bloc.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    final bloc = Provider.of<SignInBloc>(context);
    try {
      await bloc.signInWithFacebook();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailSignInPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
      ),
      body: StreamBuilder(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildCenter(context, snapshot.data);
          }),
    );
  }

  Widget _buildCenter(BuildContext context, bool isLoading) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    "Sign In",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
            SizedBox(
              height: 18.0,
            ),
            CustomRaiseButton(
              assetName: 'assets/svgs/google.svg',
              assetColor: Colors.white,
              text: "Sign in With Google",
              color: Colors.red,
              textColor: Colors.white,
              borderRadius: 10,
              onPressed: () => _signInWithGoogle(context),
            ),
            SizedBox(
              height: 8.0,
            ),
            CustomRaiseButton(
              assetName: 'assets/svgs/facebook.svg',
              assetColor: Colors.white,
              text: "Sign in With Facebook",
              color: Color(0xFF334D92),
              textColor: Colors.white,
              borderRadius: 10,
              onPressed: () => _signInWithFacebook(context),
            ),
            SizedBox(
              height: 8.0,
            ),
            CustomRaiseButton(
              text: "Sign in With Email",
              color: Colors.teal,
              textColor: Colors.white,
              borderRadius: 10,
              onPressed: () => _signInWithEmail(context),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text("Or"),
            SizedBox(
              height: 8.0,
            ),
            CustomRaiseButton(
              text: "Go Anonymous",
              color: Colors.amberAccent,
              textColor: Colors.black87,
              borderRadius: 10,
              onPressed: () => _signInWithAnonymously(context),
            ),
          ],
        ),
      ),
    );
  }
}
