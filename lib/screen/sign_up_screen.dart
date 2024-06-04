import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';
import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign-up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              Text('* Please use a valid email address.'),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _userNameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your user name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0), // Spacer(

              ElevatedButton(
                child: isLoading ? const CircularProgressIndicator() : const Text('Sign-up'),
                onPressed: () async {
                  if (isLoading) return;
                  if (_formKey.currentState!.validate()) {
                    await _signUp(
                      email: _emailController.text,
                      userName: _userNameController.text,
                      password: _passwordController.text,
                    );
                    if (!mounted) return;
                    // Navigator.of(context).pop();

                    MaterialPageRoute(builder: (context) => const HomeScreen());
                  }
                },
              ),
              TextButton(
                child: const Text('Go to Login'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUp({
    required String email,
    required String userName,
    required String password,
  }) async {
    // Set loading state to true
    setState(() {
      isLoading = true;
    });

    // Try to sign up with Supabase
    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'username': userName},
      );
    } on AuthException catch (error) {
      // Catch any errors with signing up
      showErrorSnackBar(context, message: error.message);
    } on Exception catch (error) {
      // Catch any other errors
      showErrorSnackBar(context, message: error.toString());
    } finally {
      // showErrorSnackBar(context, message: 'signup is complete');
      showErrorSnackBar(context, message: 'Please verify your email');
      // Set loading state to false
      setState(() {
        isLoading = false;
      });
    }
  }
}

