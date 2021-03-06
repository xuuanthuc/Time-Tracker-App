import 'package:time_tracker_app/services/validators.dart';

enum SignInFormEmailType { signIn, register }

class EmailSignInModel  with EmmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.formType = SignInFormEmailType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  final SignInFormEmailType formType;
  final bool isLoading;
  final bool submitted;
  String get primaryText{
    return formType == SignInFormEmailType.signIn ? 'Sign In' : 'Register';
  }
  String get secondText {
  return  formType == SignInFormEmailType.signIn
        ? 'Don\'t have an account? Register'
        : 'Have an account? Sign In';
  }
  bool get canSubmit{
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }
  bool get passValid{
     return submitted && !passwordValidator.isValid(password);
  }
  bool get emailValid{
    return submitted && !emailValidator.isValid(email);
  }
  EmailSignInModel copyWith({
    String email,
    String password,
    SignInFormEmailType formType,
    bool isLoading,
    bool submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
