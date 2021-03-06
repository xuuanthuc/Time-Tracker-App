import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_app/models/email_sign_in_model.dart';
import 'package:time_tracker_app/services/auth.dart';


class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});

  final AuthBase auth;
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelController => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  //TODO: Submit Button
  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == SignInFormEmailType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createWithEmailAndPassword(_model.email, _model.password);
      }
    } catch (error) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateToggle() => updateWith(
      email: '',
      password: '',
      isLoading: false,
      submitted: false,
      formType: _model.formType == SignInFormEmailType.signIn
          ? SignInFormEmailType.register
          : SignInFormEmailType.signIn);

  void updateWith({
    String email,
    String password,
    SignInFormEmailType formType,
    bool isLoading,
    bool submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
    //update model,
    //add updated model to _modelController
  }
}
