import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
//import 'package:mini_chat_app/auth/auth_service.dart';
import 'package:mini_chat_app/widgets/standard_button.dart';
//import 'package:mini_chat_app/screens/home_screen.dart'; 
import 'package:mini_chat_app/utils/app_strings.dart'; 
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:mini_chat_app/providers/auth_provider.dart' ;


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(); 
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //final AuthService _authService = AuthService();

  bool _isLogin = false; 
  bool _isEmailLoading = false;

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _nameValidator(String? value) {
    if (!_isLogin) {
      if (value == null || value.trim().isEmpty) {
        return AppStrings.errorNameRequired;
      }
      if (value.trim().length < 3) {
        return AppStrings.errorNameLength;
      }
    }
    return null;
  }
  
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.errorEmailRequired;
    }
    if (value.length < 6) {
    return AppStrings.errorEmailTooShort;
    }
    if (value.length > 254) {
     return AppStrings.errorEmailTooLong;
    }
    if (!value.contains('@') || !value.contains('.')) {
      return AppStrings.errorEmailInvalidFormat;
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.errorPasswordRequired;
    }

    if (!_isLogin) {
      if (value.length < 8) {
        return AppStrings.errorPasswordLength;
      }

      bool hasUppercase = false;
      bool hasLowercase = false;
      bool hasDigit = false;

      for (final char in value.runes) {
        final character = String.fromCharCode(char);
        
        final code = character.codeUnitAt(0);

        if (code >= '0'.codeUnitAt(0) && code <= '9'.codeUnitAt(0)) {
          hasDigit = true;
        } 
        else if (code >= 'A'.codeUnitAt(0) && code <= 'Z'.codeUnitAt(0)) {
          hasUppercase = true;
        }
        else if (code >= 'a'.codeUnitAt(0) && code <= 'z'.codeUnitAt(0)) {
          hasLowercase = true;
        }
      }

      if (!hasUppercase) {
        return AppStrings.errorPasswordUppercase;
      }
      if (!hasLowercase) {
        return AppStrings.errorPasswordLowercase;
      }
      if (!hasDigit) {
        return AppStrings.errorPasswordDigit;
      }
    }
    
    return null;
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Future<void> _submitEmailAuth() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() => _isEmailLoading = true);
  //     final email = _emailController.text.trim();
  //     final password = _passwordController.text.trim();
  //     final name = _nameController.text.trim();
      
  //     try {
  //       await (_isLogin 
  //         ? _authService.signIn(email: email, password: password)
  //         : _authService.signUp(name: name, email: email, password: password));
        
  //       await _analytics.logEvent(
  //           name: 'auth_completed',
  //           parameters: {
  //               'auth_type': _isLogin ? 'sign_in' : 'sign_up',
  //               'method': 'email_password',
  //           },
  //       );

  //       Navigator.of(context).pushReplacement(
  //         MaterialPageRoute(
  //           builder: (context) => MainScreen(userName: name)
  //         )
  //       );

  //     } on FirebaseAuthException catch (e) {
  //       String errorMessage = AppStrings.errorAuthFailed;

  //       if (_isLogin) {
  //           if (e.code == 'user-not-found' || e.code == 'wrong-password') {
  //               errorMessage = AppStrings.errorAuthInvalidCredentials;
  //           } else if (e.code == 'too-many-requests') {
  //               errorMessage = AppStrings.errorAuthTooManyRequests;
  //           } else {
  //               errorMessage = e.message ?? AppStrings.errorSignInFailedUnknown;
  //           }
  //       } else {
  //           if (e.code == 'email-already-in-use') {
  //               errorMessage = AppStrings.errorAuthEmailInUse;
  //           } else if (e.code == 'weak-password') {
  //               errorMessage = AppStrings.errorAuthWeakPassword;
  //           } else if (e.code == 'invalid-email') {
  //               errorMessage = AppStrings.errorAuthInvalidEmail;
  //           } else {
  //               errorMessage = e.message ?? AppStrings.errorSignUpFailedUnknown;
  //           }
  //       }
  //       _showError(errorMessage);
  //     } finally {
  //       if (mounted) setState(() => _isEmailLoading = false);
  //     }
  //   }
  //}

  Future<void> _submitEmailAuth() async {
  if (_formKey.currentState!.validate()) {
    setState(() => _isEmailLoading = true);

    final authProvider = context.read<AuthProvider>();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    try {
      if (_isLogin) {
        await authProvider.signIn(email: email, password: password);
      } else {
        await authProvider.signUp(
          name: name,
          email: email,
          password: password,
        );
      }

      await _analytics.logEvent(
        name: 'auth_completed',
        parameters: {
          'auth_type': _isLogin ? 'sign_in' : 'sign_up',
          'method': 'email_password',
        },
      );

      // ❌ НЕ НАВІГУЄМО НІКУДИ
      // AuthWrapper сам перемкне екран

    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? AppStrings.errorAuthFailed);
    } finally {
      if (mounted) setState(() => _isEmailLoading = false);
    }
  }
}

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     await _authService.signInWithGoogle();

  //     await _analytics.logEvent(
  //           name: 'auth_completed',
  //           parameters: {
  //               'auth_type': 'sign_in',
  //               'method': 'google',
  //           },
  //     );
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MainScreen()));
  //   } on FirebaseAuthException catch (e) {
  //     _showError(e.message ?? AppStrings.errorGoogleSignInFailed);
  //   } catch (e) {
  //     _showError(AppStrings.errorGoogleSignInCancelled);
  //   }
  // }
  Future<void> _signInWithGoogle() async {
  try {
    await context.read<AuthProvider>().signInWithGoogle();

    await _analytics.logEvent(
      name: 'auth_completed',
      parameters: {
        'auth_type': 'sign_in',
        'method': 'google',
      },
    );
  } catch (e) {
    _showError(AppStrings.errorGoogleSignInFailed);
  }
}

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required String? Function(String?) validator,
    IconData? prefixIcon,
    bool obscureText = false,
  }) {
    const borderRadius = BorderRadius.all(Radius.circular(15));
    const activeBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Color(0xFF0049BD), width: 2), 
    );
    const errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Colors.red, width: 2),
    );
    const defaultBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide.none,
    );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(color: Color(0xFF1B1918), fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Color(0xFF0049BD)) : null,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontWeight: FontWeight.normal),
        filled: true,
        fillColor: Colors.white,
        border: defaultBorder,
        enabledBorder: defaultBorder,
        focusedBorder: activeBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color authScreenBackground = Color(0xFF81D4FA); 
    
    return Scaffold(
      backgroundColor: authScreenBackground, 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 100),
                const Text(
                  AppStrings.appTitle,
                  style: TextStyle(
                    color: Color(0xFF0049BD),
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    letterSpacing: 0,
                  ),
                ),
                const Text(
                  AppStrings.tagline,
                  style: TextStyle(
                    color: Color(0xFF1B1918),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (!_isLogin) 
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildInputField(
                            controller: _nameController,
                            hintText: AppStrings.fieldNameHint,
                            validator: _nameValidator,
                            prefixIcon: Icons.person_outline,
                          ),
                        ),
                        _buildInputField(
                          controller: _emailController,
                          hintText: AppStrings.fieldEmailHint,
                          validator: _emailValidator,
                          prefixIcon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _passwordController,
                          hintText: AppStrings.fieldPasswordHint,
                          validator: _passwordValidator,
                          prefixIcon: Icons.lock_outline,
                          obscureText: true,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                StandardButton(
                  text: _isLogin ? AppStrings.buttonSignIn : AppStrings.buttonSignUp,
                  onPressed: _isEmailLoading ? null : _submitEmailAuth,
                  isLoading: _isEmailLoading,
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _formKey.currentState?.reset();
                      _passwordController.clear();
                      _nameController.clear(); 
                    });
                  },
                  child: Text(
                    _isLogin 
                     ? AppStrings.linkNewUser 
                     : AppStrings.linkExistingUser,
                      style: const TextStyle(
                      color: Color(0xFF1B1918),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                StandardButton(
                  text: AppStrings.buttonSignInGoogle,
                  onPressed: _signInWithGoogle,
                  isLoading: false,
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF1B1918),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}