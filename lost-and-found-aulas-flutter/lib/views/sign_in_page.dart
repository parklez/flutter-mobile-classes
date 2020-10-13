import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:lost_and_found/services/auth.dart';
import 'package:lost_and_found/views/home_page.dart';
import 'package:lost_and_found/views/sign_up.page.dart';

class SignInPage extends StatefulWidget {
  static const String routeName = '/signin';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _showEmailTextField(),
        _showPasswordTextField(),
        _showSignInButton(),
        _showSignUpButton(),
      ],
    );
  }

  Widget _showEmailTextField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration:
          InputDecoration(hintText: 'Email', prefixIcon: Icon(Icons.email)),
    );
  }

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Widget _showPasswordTextField() {
    return TextField(
      controller: _passwordController,
      keyboardType: TextInputType.text,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Senha',
        prefixIcon: Icon(Icons.vpn_key),
        suffixIcon: IconButton(
          icon:
              Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: _toggleObscurePassword,
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    await Auth.signIn(email, password)
        .then(_onSignInSuccess)
        .catchError((error) {
      print('Caught error: $error');
      Flushbar(
        title: 'Erro',
        message: error.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    });
  }

  Future _onSignInSuccess(String userId) async {
    final user = await Auth.getUser(userId);
    await Auth.storeUserLocal(user);
    Navigator.pushReplacementNamed(context, HomePage.routeName);
  }

  Widget _showSignInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      child: RaisedButton(child: Text('LOGIN'), onPressed: _signIn),
    );
  }

  void _signUp() {
    Navigator.pushReplacementNamed(context, SignUpPage.routeName);
  }

  Widget _showSignUpButton() {
    return FlatButton(child: Text('Registrar-se'), onPressed: _signUp);
  }
}
