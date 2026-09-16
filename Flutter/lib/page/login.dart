// lib/page/login.dart
import 'package:flutter/material.dart';

import '../services/auth-service.dart';
import '../core/network/api-exception.dart';

import 'login/reset.dart';
import 'tabbar.dart';
import 'login/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const Color pageBackground = Color(0xFFF5FBF3);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _hidePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email and password.')),
      );

      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      await AuthService.instance.login(email: email, password: password);

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const TabBarPage()),
        (route) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong. Please try again.')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _forgotPassword() {
    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResetPage()),
    );
  }

  void _signUp() {
    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  Future<void> _socialLogin(String provider) async {
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Continue with $provider'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.055;
    final heroHeight = width * 0.76;

    return Scaffold(
      backgroundColor: pageBackground,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            const Positioned.fill(child: LoginBackground()),
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(bottom: media.viewInsets.bottom + 28),
                child: Column(
                  children: [
                    SizedBox(
                      height: heroHeight,
                      child: LoginHero(horizontalPadding: horizontalPadding),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: LoginCard(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          emailFocusNode: _emailFocusNode,
                          passwordFocusNode: _passwordFocusNode,
                          hidePassword: _hidePassword,
                          isLoading: _isLoading,
                          onTogglePassword: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          onForgotPassword: _forgotPassword,
                          onLogin: _login,
                          onFacebookLogin: () {
                            _socialLogin('Facebook');
                          },
                          onAppleLogin: () {
                            _socialLogin('Apple');
                          },
                          onGoogleLogin: () {
                            _socialLogin('Google');
                          },
                          onSignUp: _signUp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginBackground extends StatelessWidget {
  const LoginBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FCF4), Color(0xFFF3FAEE), Color(0xFFF8FCF6)],
        ),
      ),
    );
  }
}

class LoginHero extends StatelessWidget {
  final double horizontalPadding;

  const LoginHero({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/login/login-hero.png',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            errorBuilder: (_, __, ___) {
              return const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF7FCF2), Color(0xFFE6F6DB)],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 48,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Welcome Back '),
                    TextSpan(
                      text: '♥',
                      style: TextStyle(color: Color(0xFF18B94A), fontSize: 22),
                    ),
                  ],
                ),
                style: TextStyle(
                  color: Color(0xFF153526),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Happy Pet, Happy Life',
                style: TextStyle(
                  color: Color(0xFF68736D),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: horizontalPadding,
          top: 132,
          child: const YiPetHeroLogo(),
        ),
      ],
    );
  }
}

class YiPetHeroLogo extends StatelessWidget {
  const YiPetHeroLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF18B94A),
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1818B94A),
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              "assets/images/splash/logo.png",
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.pets_rounded,
                  color: Colors.white,
                  size: 44,
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'YiPet',
              style: TextStyle(
                color: Color(0xFF07983A),
                fontSize: 42,
                height: 1,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'All-in-one care for\n'
                        'your furry family ',
                  ),
                  TextSpan(
                    text: '♥',
                    style: TextStyle(color: Color(0xFF18B94A)),
                  ),
                ],
              ),
              style: TextStyle(
                color: Color(0xFF405148),
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final bool hidePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;
  final VoidCallback onFacebookLogin;
  final VoidCallback onAppleLogin;
  final VoidCallback onGoogleLogin;
  final VoidCallback onSignUp;

  const LoginCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.hidePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onForgotPassword,
    required this.onLogin,
    required this.onFacebookLogin,
    required this.onAppleLogin,
    required this.onGoogleLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.97),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFDDE9DD)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login to your account',
              style: TextStyle(
                color: Color(0xFF087F31),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            LoginTextField(
              controller: emailController,
              focusNode: emailFocusNode,
              hintText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: Icons.mail_outline_rounded,
              onSubmitted: (_) {
                passwordFocusNode.requestFocus();
              },
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) {
                  return 'Please enter your email address';
                }

                final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegExp.hasMatch(email)) {
                  return 'Please enter a valid email address';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            LoginTextField(
              controller: passwordController,
              focusNode: passwordFocusNode,
              hintText: 'Password',
              obscureText: hidePassword,
              textInputAction: TextInputAction.done,
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF90979A),
                  size: 24,
                ),
              ),
              onSubmitted: (_) {
                onLogin();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }

                if (value.length < 6) {
                  return 'Password must contain at least 6 characters';
                }

                return null;
              },
            ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onForgotPassword,
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF148E3D),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 7,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 12),
            LoginPrimaryButton(isLoading: isLoading, onTap: onLogin),
            const SizedBox(height: 16),
            const LoginDivider(text: 'Or continue with'),
            const SizedBox(height: 16),
            SocialLoginButton(
              label: 'Continue with Facebook',
              imagePath: 'assets/images/login/facebook.png',
              fallbackIcon: Icons.facebook_rounded,
              fallbackColor: const Color(0xFF1877F2),
              onTap: onFacebookLogin,
            ),
            const SizedBox(height: 8),
            SocialLoginButton(
              label: 'Continue with Apple',
              imagePath: 'assets/images/login/apple.png',
              fallbackIcon: Icons.apple_rounded,
              fallbackColor: Colors.black,
              onTap: onAppleLogin,
            ),
            const SizedBox(height: 8),
            SocialLoginButton(
              label: 'Continue with Google',
              imagePath: 'assets/images/login/google.png',
              fallbackIcon: Icons.g_mobiledata_rounded,
              fallbackColor: const Color(0xFF4285F4),
              onTap: onGoogleLogin,
            ),
            const SizedBox(height: 16),
            SignUpPrompt(onTap: onSignUp),
          ],
        ),
      ),
    );
  }
}

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      cursorColor: const Color(0xFF18A843),
      style: const TextStyle(color: Color(0xFF28352E), fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFA1A8A4),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(11),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F9EF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(prefixIcon, color: const Color(0xFF18A843), size: 24),
          ),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDCE8DD), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF24B74B), width: 1.7),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDC4C45)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFDC4C45), width: 1.5),
        ),
      ),
    );
  }
}

class LoginPrimaryButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const LoginPrimaryButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLoading ? 0.75 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isLoading ? null : onTap,
          child: Ink(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF20BE51), Color(0xFF13AB43)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3320BE51),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginDivider extends StatelessWidget {
  final String text;

  const LoginDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE0E6E0), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF8B918D), fontSize: 10),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE0E6E0), thickness: 1)),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.imagePath,
    required this.fallbackIcon,
    required this.fallbackColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E6E0)),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: Center(
                  child: Image.asset(
                    imagePath,
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return Icon(fallbackIcon, color: fallbackColor, size: 30);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF27372F),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 56),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const SignUpPrompt({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Don’t have an account? ',
          style: TextStyle(color: Color(0xFF68736D), fontSize: 12),
        ),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Sign up',
              style: TextStyle(
                color: Color(0xFF15933D),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
