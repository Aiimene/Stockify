import 'package:flutter/material.dart';
import 'package:ourproject/screens/Login.dart';
import 'package:ourproject/screens/SignUp.dart';
import '../../Themes/Style_Simple/Colors.dart';
import '../../Themes/Style_Simple/Buttons.dart';
import '../../Themes/Style_Simple/typography.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final textTheme = smartStockTextTheme;

    return Scaffold(
      backgroundColor: white1Color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🌍 Language selector (top right)
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Français / العربية',
                    style: textTheme.labelSmall!.copyWith(
                      color: accentColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              // 📦 Centered logo + text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 200,
                  ),
                  //const SizedBox(height: 24),
                  //Text(
                  //  'Stockify',
                  //  style: textTheme.displayLarge!.copyWith(
                  //    fontSize: 28,
                  //    color: textColor,
                  //  ),
                  //),
                  Text(
                    'Manage your stock, sales, and growth',
                    style: textTheme.bodyMedium!.copyWith(
                      color: text1Color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              // 🔘 Bottom buttons (full width)
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: white1Color,
                        textStyle: textTheme.labelLarge,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: surfaceColor,
                        foregroundColor: textColor,
                        textStyle: textTheme.labelLarge!.copyWith(
                          color: textColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        side: const BorderSide(color: surfaceColor, width: 0),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: const Text('Login'),
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
