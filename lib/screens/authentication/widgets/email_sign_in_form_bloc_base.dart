import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/blocs/email_sign_in_bloc.dart';
import 'package:time_tracker_app/models/email_sign_in_model.dart';
import 'package:time_tracker_app/screens/authentication/widgets/custom_raised_button.dart';
import 'package:time_tracker_app/services/auth.dart';

class SignInFormBlocBase extends StatefulWidget {
  SignInFormBlocBase({@required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => SignInFormBlocBase(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInFormBlocBase> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  } //Dung de xoa het cac ban ghi du lieu khi widget khong con nua

  //TODO: Submit Button
  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Sign in failed'),
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

  void _toggleFormType() {
    widget.bloc.updateToggle();
    _emailEditingController.clear();
    _passwordEditingController.clear();
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(
      newFocus,
    );
  } //FocusNode Dung de chuyen con tro van ban tu hang email xuong password khi ban next

  //Disable Button when empty

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelController,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEmailTextField(model),
                SizedBox(
                  height: 5,
                ),
                _buildPasswordTextField(model),
                SizedBox(
                  height: 15,
                ),
                CustomRaiseButton(
                  text: model.primaryText,
                  textColor: Colors.white,
                  borderRadius: 10,
                  color: Colors.teal,
                  onPressed: model.canSubmit ? _submit : null,
                ),
                FlatButton(
                  onPressed: model.isLoading ? null : _toggleFormType,
                  child: Text(model.secondText),
                )
              ],
            ),
          );
        });
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@gmail.com',
          errorText: model.emailValid ? 'Email can\'t be empty' : null,
          enabled: model.isLoading == false),
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      onChanged: widget.bloc.updateEmail,
      controller: _emailEditingController,
      onEditingComplete: () => _emailEditingComplete(model),
      //ham thuc hien khi chuyen control van ban ra ben ngoai
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordEditingController,
      decoration: InputDecoration(
        labelText: 'Password',
        enabled: model.isLoading == false,
        hintText: '123456789',
        errorText: model.passValid ? 'Password can\'t be empty' : null,
      ),
      onChanged: widget.bloc.updatePassword,
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onEditingComplete: _submit,
    );
  }
}
