import 'dart:math';
import 'package:flutter/material.dart';
import 'package:assignment1/models/index.dart';
import 'package:assignment1/components/custom_text_field.dart';
import 'package:assignment1/components/custom_dropdown_field.dart';
import 'package:assignment1/components/custom_button.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback onSignupSuccess;
  final VoidCallback onToggleMode;

  const SignupForm({
    super.key,
    required this.onSignupSuccess,
    required this.onToggleMode,
  });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedCampus;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCampus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select your campus'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay for premium feel
    await Future.delayed(const Duration(milliseconds: 800));

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Check if email already exists
      final existingUsers = await userStore.findAll();
      final alreadyExists = existingUsers.any(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      if (alreadyExists) {
        throw Exception('An account with this email already exists.');
      }

      // Generate random campus ID matching the patterns
      final prefix = _selectedCampus == 'Kigali Campus' ? 'ALU-RW-' : 'ALU-MU-';
      final randomNum = 1000 + Random().nextInt(9000);
      final campusId = '$prefix$randomNum';

      // Create new user entity
      final newUser = User(
        fullName: name,
        email: email,
        campusId: campusId,
        campusName: _selectedCampus,
        password: password,
      );

      await userStore.add(newUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created! Welcome, $name. Please log in.'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        widget.onSignupSuccess();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name Field
          CustomTextField(
            controller: _nameController,
            hintText: 'Full Name',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              if (value.trim().length < 3) {
                return 'Name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email Field
          CustomTextField(
            controller: _emailController,
            hintText: 'Email Address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              var val = value?.trim();
              if (val == null || val.isEmpty) {
                return 'Please enter your email';
              }
              if (!val.contains('@')) {
                return 'Please enter valid email address';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password Field
          CustomTextField(
            controller: _passwordController,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline_rounded,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Campus Selection Dropdown
          CustomDropdownField<String>(
            value: _selectedCampus,
            hintText: 'Select Campus',
            prefixIcon: Icons.school_outlined,
            items: const [
              DropdownMenuItem(
                value: 'Kigali Campus',
                child: Text('Kigali Campus'),
              ),
              DropdownMenuItem(
                value: 'Mauritius Campus',
                child: Text('Mauritius Campus'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedCampus = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select your campus';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Submit Button
          CustomButton(
            text: 'Create Account',
            onPressed: _handleSignup,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
