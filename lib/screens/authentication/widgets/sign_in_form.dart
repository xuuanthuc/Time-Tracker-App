import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/models/email_sign_in_model.dart';
import 'package:time_tracker_app/screens/authentication/widgets/custom_raised_button.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/validators.dart';



class SignInForm extends StatefulWidget with EmmailAndPasswordValidators {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  String get _email => _emailEditingController.text;

  String get _password => _passwordEditingController.text;
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  SignInFormEmailType _typeForm = SignInFormEmailType.signIn;
  bool submitted = false;
  bool _isLoading = false;
  @override
  void dispose(){
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }//Dung de xoa het cac ban ghi du lieu khi widget khong con nua
  //TODO: Submit Button
  Future<void> _submit() async {
    final auth = Provider.of<AuthBase>(context);
    setState(() {
      submitted = true;
      _isLoading = true;
    });
    try {
      if (_typeForm == SignInFormEmailType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createWithEmailAndPassword(_email, _password);
      }
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFormType() {
    setState(() {
      _typeForm = _typeForm == SignInFormEmailType.signIn
          ? SignInFormEmailType.register
          : SignInFormEmailType.signIn;
    });
    _emailEditingController.clear();
    _passwordEditingController.clear();
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(
      newFocus,
    );
  } //FocusNode Dung de chuyen con tro van ban tu hang email xuong password khi ban next

  //Disable Button when empty
  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _primaryText =
        _typeForm == SignInFormEmailType.signIn ? 'Sign In' : 'Register';
    final _secondaryText = _typeForm == SignInFormEmailType.signIn
        ? 'Don\'t have an account? Register'
        : 'Have an account? Sign In';
    bool _enableSubmit = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmailTextField(),
          SizedBox(
            height: 5,
          ),
          _buildPasswordTextField(),
          SizedBox(
            height: 15,
          ),
          CustomRaiseButton(
            text: _primaryText,
            textColor: Colors.white,
            borderRadius: 10,
            color: Colors.teal,
            onPressed: _enableSubmit ? _submit : null,
          ),
          FlatButton(
            onPressed: _isLoading ? null : _toggleFormType,
            child: Text(_secondaryText),
          )
        ],
      ),
    );
  }

  TextField _buildEmailTextField() {
    bool emailValid = submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@gmail.com',
          errorText: emailValid ? 'Email can\'t be empty' : null,
          enabled: _isLoading == false),
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      onChanged: (email) => _updateState(),
      controller: _emailEditingController,
      onEditingComplete: _emailEditingComplete,
      //ham thuc hien khi chuyen control van ban ra ben ngoai
      textInputAction: TextInputAction.next,
    );
  }

  TextField _buildPasswordTextField() {
    bool passwordValid =
        submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordEditingController,
      decoration: InputDecoration(
        labelText: 'Password',
        enabled: _isLoading == false,
        hintText: '123456789',
        errorText: passwordValid ? 'Password can\'t be empty' : null,
      ),
      onChanged: (password) => _updateState(),
      focusNode: _passwordFocusNode,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onEditingComplete: _submit,
    );
  }
}
