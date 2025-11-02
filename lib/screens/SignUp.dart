import 'package:flutter/material.dart';
import 'package:ourproject/screens/Login.dart';
import '../../Themes/Style_Simple/Colors.dart';
import '../../Themes/Style_Simple/typography.dart';
import '../../Themes/Style_Simple/Styles.dart';
import '../../Themes/Style_Simple/Buttons.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account created successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo + Title Section
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 0),
                    Text(
                      'Create Your Account',
                      style: smartStockTextTheme.bodyMedium?.copyWith(
                        color: text1Color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Name Field
              Text('Name', style: smartStockTextTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: _inputDecoration(
                  hintText: 'Enter your full name',
                  icon: Icons.person_outline,
                ),
              ),
              const SizedBox(height: 18),

              // Email Field
              Text('Email', style: smartStockTextTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  hintText: 'Enter your email address',
                  icon: Icons.mail_outline,
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              Text('Password', style: smartStockTextTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: _inputDecoration(
                  hintText: 'Enter your password',
                  icon: Icons.lock_outline,
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() => showPassword = !showPassword);
                    },
                    child: Icon(
                      showPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: text2Color,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Confirm Password Field
              Text('Confirm Password', style: smartStockTextTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: confirmPasswordController,
                obscureText: !showConfirmPassword,
                decoration: _inputDecoration(
                  hintText: 'Re-enter your password',
                  icon: Icons.lock_outline,
                  suffix: GestureDetector(
                    onTap: () {
                      setState(
                          () => showConfirmPassword = !showConfirmPassword);
                    },
                    child: Icon(
                      showConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: text2Color,
                      size: 20,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'Sign Up',
                  onPressed: _handleSignUp,
                ),
              ),

              const SizedBox(height: 16),

              // Login Link
              Center(
                child: RichText(
                    text: TextSpan(
                  text: 'Already have an account? ',
                  style: smartStockTextTheme.bodyMedium
                      ?.copyWith(color: text1Color),
                  children: [
                    TextSpan(
                      text: 'Log In',
                      style: smartStockTextTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // REUSABLE INPUT FIELD DECORATION
  // ===========================================================
  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: smartStockTextTheme.bodyMedium?.copyWith(color: text2Color),
      prefixIcon: Icon(icon, color: text2Color, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
