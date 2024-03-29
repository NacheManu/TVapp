import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_app/blocs/auth_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _pinController = TextEditingController();
  final _form = GlobalKey<FormState>();
  late String _enteredUsername = '';
  late String _enteredPin;
  bool _isAuthenticating = false;
  bool _isLogin = true;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthCubit authCubit) async {
    final isValid = _form.currentState!.validate();

    if (!isValid || _isAuthenticating) {
      return;
    }

    _form.currentState!.save();

    setState(() {
      _isAuthenticating = true;
    });

    if (_isLogin) {
      final user = await authCubit.authenticateUser(
        _enteredUsername,
        _enteredPin,
      );

      if (user != null) {
        context.go('/Home/$_enteredUsername');
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Login error, Make sure you are registered or verify the data entered.'),
          duration: Duration(milliseconds: 1500),
        ));
      }
    } else {
      final added = await authCubit.addUser(
        _enteredUsername,
        _enteredPin,
      );

      if (added) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User registered successfully')));
        _isLogin = true;
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User already exists'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    }

    setState(() {
      _isAuthenticating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 300,
                child: Image.asset('assets/images/TVicon.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          decoration:
                              InputDecoration(labelText: _isLogin ? 'Username ' : 'Create Username'),
                          enableSuggestions: false,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 4) {
                              return 'Please enter at least 4 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredUsername = value!;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            LengthLimitingTextInputFormatter(5),
                          ],
                          decoration:  InputDecoration(
                            labelText: _isLogin ? 'PIN ' : 'Create PIN',
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 0.5)),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                          ),
                          textAlign: TextAlign.center,
                          obscureText: true,
                          obscuringCharacter: '●',
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 5) {
                              return 'Please enter 5 characters.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPin = value!;
                          },
                        ),
                        const SizedBox(height: 12),
                        if (_isAuthenticating)
                          const CircularProgressIndicator(),
                        if (!_isAuthenticating)
                          ElevatedButton(
                            onPressed: () {
                              final authCubit = context.read<AuthCubit>();
                              _submit(authCubit);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isLogin ? 'Login ' : 'Sing Up'),
                          ),
                      ]),
                    ),
                  ),
                ),
              ),
              if (!_isAuthenticating)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin
                          ? 'You don\'t have an account?'
                          : 'Do you already have an account?',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Sign Up' : 'Login',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
