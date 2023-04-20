import 'package:flutter/material.dart';
import 'package:to_do_list/todo_list.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String emailController = '';
  String _password = '';
  String _errorText = '';
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: homePage(),
    );
  }

  Widget buildEmail() => TextField(
        onChanged: (value) => setState(() => this.emailController = value),
        onSubmitted: (value) => setState(() => this.emailController = value),
        decoration: const InputDecoration(
          hintText: 'please input your email',
          labelText: 'email',
          icon: Icon(Icons.email),
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
      );

  Widget buildPassword() => TextField(
        onChanged: (value) => setState(() => this._password = value),
        onSubmitted: (value) => setState(() => this._password = value),
        decoration: InputDecoration(
          hintText: 'please input your password',
          labelText: 'Password',
          errorText: _errorText,
          icon: Icon(Icons.password),
          suffixIcon: IconButton(
            icon: isPasswordVisible
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
            onPressed: () => setState(() {
              isPasswordVisible = !isPasswordVisible;
            }),
          ),
          border: OutlineInputBorder(),
        ),
        obscureText: isPasswordVisible,
      );

  Widget homePage() => Center(
          child: ListView(
        padding: EdgeInsets.all(32),
        children: [
          buildEmail(),
          const SizedBox(height: 24),
          buildPassword(),
          const SizedBox(height: 24),
          TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                if (emailController == 'email' && _password == 'pass') {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TodoList()));
                } else if (_password != 'pass') {
                  setState(() {
                    _errorText = 'Wrong Password';
                  });
                }
              },
              child: Text('Submit'))
        ],
      ));
}
