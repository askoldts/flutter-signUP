import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../widgets/fieldValidationStatus.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      minimumSize: const Size(240, 48));

  bool _emailValid = false;
  bool _passwordValid = false;
  String _emailError = '';
  String _passwordError = '';

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  bool hasValidLength(String value) => value.length >= 8;

  bool hasUpperCase(String value) => value.contains(RegExp(r'[A-Z]'));

  bool hasNumber(String value) => value.contains(RegExp(r'\d'));

  void _validateFields() {
    final formState = _formKey.currentState;
    if (formState != null) {
      setState(() {
        _emailValid = formState.fields['email']?.validate() ?? false;
        _passwordValid = formState.fields['password']?.validate() ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Sign Up')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          onChanged: () {
            _formKey.currentState?.save();
            setState(() {
              _emailValid =
                  _formKey.currentState?.fields['email']?.validate() ?? false;
              _passwordValid =
                  _formKey.currentState?.fields['password']?.validate() ??
                      false;
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildEmailField(),
              SizedBox(height: 16),
              _buildPasswordField(),
              SizedBox(height: 20),
              if (!_passwordError.isEmpty)
                const Center(
                    child: SizedBox(
                        width: 240,
                        child:Center(
                            child: Text(
                                "This password doesn't look right. Please try again or reset it now.",
                                style: TextStyle(
                                  color: Colors.red,
                                )))
                    )),
              if (_passwordError.isEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldValidationStatus(
                      field: true,
                      validationBy: hasValidLength(
                          _formKey.currentState?.fields['password']?.value ??
                              ''),
                      text: '8 characters or more (no spaces)',
                    ),
                    FieldValidationStatus(
                      field: true,
                      validationBy: hasUpperCase(
                          _formKey.currentState?.fields['password']?.value ??
                              ''),
                      text: '1 uppercase letter',
                    ),
                    FieldValidationStatus(
                      field: true,
                      validationBy: hasNumber(
                          _formKey.currentState?.fields['password']?.value ??
                              ''),
                      text: 'At least one digit',
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient:
                    LinearGradient(colors: [Colors.cyan, Colors.indigo]),
                  ),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      _validateFields();
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        print(_formKey.currentState?.value);
                      } else {
                        setState(() {
                          final formErrors = _formKey.currentState?.fields;
                          _emailError = formErrors?['email']?.errorText ?? '';
                          _passwordError =
                              formErrors?['password']?.errorText ?? '';
                        });
                      }
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return FormBuilderTextField(
      name: 'email',
      focusNode: _emailFocus,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: _emailError.isNotEmpty
                ? Colors.red
                : _emailValid
                ? Colors.green
                : Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      style: TextStyle(
        color: _emailError.isNotEmpty
            ? Colors.red
            : _emailValid
            ? Colors.green
            : Colors.black,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is empty';
        }
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Invalid email address';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _emailError = '';
          _emailValid = false;
        });
      },
    );
  }

  Widget _buildPasswordField() {
    return FormBuilderTextField(
      name: 'password',
      focusNode: _passwordFocus,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: _passwordError.isNotEmpty
                ? Colors.red
                : _passwordValid
                ? Colors.green
                : Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      style: TextStyle(
        color: _passwordError.isNotEmpty
            ? Colors.red
            : _passwordValid
            ? Colors.green
            : Colors.black,
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is empty';
        }
        if (!hasValidLength(value) ||
            !hasUpperCase(value) ||
            !hasNumber(value)) {
          return 'Invalid password';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _passwordError = '';
          _passwordValid = false;
        });
      },
    );
  }
}
