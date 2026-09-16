// lib/page/login/register.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../tabbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const Color pageBackground = Color(0xFFF5FBF2);

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _mobileFocus = FocusNode();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _mobileController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameFocus.dispose();
    _mobileFocus.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please agree to the Terms of Service and Privacy Policy.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final requestData = {
        'username': _usernameController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'password': _passwordController.text,
      };

      // TODO: 调用 NestJS 注册接口

      await Future<void>.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful')));

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _socialRegister(String provider) {
    // FocusScope.of(context).unfocus();

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Continue with $provider'),

    //     duration: const Duration(seconds: 1),
    //   ),
    // );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const TabBarPage()),
      (route) => false,
    );
  }

  void _openTerms() {
    debugPrint('Open Terms of Service');
  }

  void _openPrivacyPolicy() {
    debugPrint('Open Privacy Policy');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.05;
    final heroHeight = width * 0.76;

    return Scaffold(
      backgroundColor: pageBackground,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const Positioned.fill(child: RegisterBackground()),
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
                      child: RegisterHero(horizontalPadding: horizontalPadding),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: RegisterCard(
                          formKey: _formKey,
                          usernameController: _usernameController,
                          mobileController: _mobileController,
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          usernameFocus: _usernameFocus,
                          mobileFocus: _mobileFocus,
                          firstNameFocus: _firstNameFocus,
                          lastNameFocus: _lastNameFocus,
                          emailFocus: _emailFocus,
                          passwordFocus: _passwordFocus,
                          confirmPasswordFocus: _confirmPasswordFocus,
                          hidePassword: _hidePassword,
                          hideConfirmPassword: _hideConfirmPassword,
                          agreedToTerms: _agreedToTerms,
                          isLoading: _isLoading,
                          onTogglePassword: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                          onToggleConfirmPassword: () {
                            setState(() {
                              _hideConfirmPassword = !_hideConfirmPassword;
                            });
                          },
                          onAgreementChanged: (value) {
                            setState(() {
                              _agreedToTerms = value;
                            });
                          },
                          onTermsTap: _openTerms,
                          onPrivacyTap: _openPrivacyPolicy,
                          onRegister: _register,
                          onFacebookTap: () => _socialRegister('Facebook'),
                          onAppleTap: () => _socialRegister('Apple'),
                          onGoogleTap: () => _socialRegister('Google'),
                          onLoginTap: () => Navigator.pop(context),
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

class RegisterBackground extends StatelessWidget {
  const RegisterBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FCF3), Color(0xFFF0F9EA), Color(0xFFF8FCF6)],
        ),
      ),
    );
  }
}

class RegisterHero extends StatelessWidget {
  final double horizontalPadding;

  const RegisterHero({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/login/register-hero.png',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
            errorBuilder: (_, __, ___) {
              return const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8FCF3), Color(0xFFE3F5D9)],
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          left: horizontalPadding - 10,
          top: 12,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 25,
                  color: Color(0xFF18352A),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: horizontalPadding,
          top: 112,
          width: MediaQuery.sizeOf(context).width * 0.43,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Create Your\n',
                      style: TextStyle(color: Color(0xFF17372A)),
                    ),
                    TextSpan(
                      text: 'Account',
                      style: TextStyle(color: Color(0xFF10A943)),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Join YiPet and start your\n'
                          'happy pet journey! ',
                    ),
                    TextSpan(
                      text: '♥',
                      style: TextStyle(color: Color(0xFF18B94A)),
                    ),
                  ],
                ),
                style: TextStyle(
                  color: Color(0xFF68736D),
                  fontSize: 12,
                  height: 1.55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RegisterCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController usernameController;
  final TextEditingController mobileController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode usernameFocus;
  final FocusNode mobileFocus;
  final FocusNode firstNameFocus;
  final FocusNode lastNameFocus;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmPasswordFocus;
  final bool hidePassword;
  final bool hideConfirmPassword;
  final bool agreedToTerms;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final ValueChanged<bool> onAgreementChanged;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;
  final VoidCallback onRegister;
  final VoidCallback onFacebookTap;
  final VoidCallback onAppleTap;
  final VoidCallback onGoogleTap;
  final VoidCallback onLoginTap;

  const RegisterCard({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.mobileController,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.usernameFocus,
    required this.mobileFocus,
    required this.firstNameFocus,
    required this.lastNameFocus,
    required this.emailFocus,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.hidePassword,
    required this.hideConfirmPassword,
    required this.agreedToTerms,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onAgreementChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
    required this.onRegister,
    required this.onFacebookTap,
    required this.onAppleTap,
    required this.onGoogleTap,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 27, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(29),
        border: Border.all(color: const Color(0xFFE0E9DE)),
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
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RegisterTextField(
                    controller: usernameController,
                    focusNode: usernameFocus,
                    label: 'Username',
                    hintText: 'Username',
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => mobileFocus.requestFocus(),
                    validator: (value) {
                      final username = value?.trim() ?? '';

                      if (username.isEmpty) {
                        return 'Username is required';
                      }

                      if (username.length < 3) {
                        return 'At least 3 characters';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RegisterTextField(
                    controller: mobileController,
                    focusNode: mobileFocus,
                    label: 'Mobile',
                    hintText: 'Mobile',
                    icon: Icons.phone_iphone_rounded,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => firstNameFocus.requestFocus(),
                    validator: (value) {
                      final mobile = value?.trim() ?? '';

                      if (mobile.isEmpty) {
                        return 'Mobile is required';
                      }

                      if (mobile.length < 7) {
                        return 'Invalid mobile number';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RegisterTextField(
                    controller: firstNameController,
                    focusNode: firstNameFocus,
                    label: 'First Name',
                    hintText: 'First Name',
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => lastNameFocus.requestFocus(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'First name is required';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RegisterTextField(
                    controller: lastNameController,
                    focusNode: lastNameFocus,
                    label: 'Last Name',
                    hintText: 'Last Name',
                    icon: Icons.person_outline_rounded,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => emailFocus.requestFocus(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Last name is required';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            RegisterTextField(
              controller: emailController,
              focusNode: emailFocus,
              label: 'Email Address',
              hintText: 'Enter your email address',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => passwordFocus.requestFocus(),
              validator: (value) {
                final email = value?.trim() ?? '';

                if (email.isEmpty) {
                  return 'Email address is required';
                }

                final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                if (!emailRegExp.hasMatch(email)) {
                  return 'Please enter a valid email address';
                }

                return null;
              },
            ),
            const SizedBox(height: 14),
            RegisterTextField(
              controller: passwordController,
              focusNode: passwordFocus,
              label: 'Password',
              hintText: 'Enter your password',
              icon: Icons.lock_outline_rounded,
              obscureText: hidePassword,
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  hidePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,

                  size: 24,
                  color: const Color(0xFF94999C),
                ),
              ),
              onSubmitted: (_) => confirmPasswordFocus.requestFocus(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }

                if (value.length < 6) {
                  return 'Password must contain at least 6 characters';
                }

                return null;
              },
            ),
            const SizedBox(height: 14),
            RegisterTextField(
              controller: confirmPasswordController,
              focusNode: confirmPasswordFocus,
              label: 'Confirm Password',
              hintText: 'Confirm your password',
              icon: Icons.lock_outline_rounded,
              obscureText: hideConfirmPassword,
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                onPressed: onToggleConfirmPassword,
                icon: Icon(
                  hideConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,

                  size: 24,
                  color: const Color(0xFF94999C),
                ),
              ),
              onSubmitted: (_) => onRegister(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }

                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
            ),
            const SizedBox(height: 8),
            TermsAgreement(
              value: agreedToTerms,
              onChanged: onAgreementChanged,
              onTermsTap: onTermsTap,
              onPrivacyTap: onPrivacyTap,
            ),
            const SizedBox(height: 16),
            RegisterButton(isLoading: isLoading, onTap: onRegister),
            const SizedBox(height: 16),
            const RegisterDivider(text: 'Or continue with'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RegisterSocialButton(
                    label: 'Facebook',
                    imagePath: 'assets/images/login/facebook.png',
                    fallbackIcon: Icons.facebook,
                    fallbackColor: const Color(0xFF1877F2),
                    onTap: onFacebookTap,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RegisterSocialButton(
                    label: 'Apple',
                    imagePath: 'assets/images/login/apple.png',
                    fallbackIcon: Icons.apple,
                    fallbackColor: Colors.black,
                    onTap: onAppleTap,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RegisterSocialButton(
                    label: 'Google',
                    imagePath: 'assets/images/login/google.png',
                    fallbackIcon: Icons.g_mobiledata_rounded,
                    fallbackColor: const Color(0xFF4285F4),
                    onTap: onGoogleTap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AlreadyAccountPrompt(onTap: onLoginTap),
          ],
        ),
      ),
    );
  }
}

class RegisterTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hintText;
  final IconData icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;

  const RegisterTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hintText,
    required this.icon,
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
      cursorColor: _RegisterColors.primary,
      style: const TextStyle(color: _RegisterColors.textPrimary, fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(
          color: _RegisterColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(color: Color(0xFF9DA4A0), fontSize: 12),
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
          child: Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8EC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _RegisterColors.primary, size: 24),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: _RegisterColors.border,
            width: 1.1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: _RegisterColors.primary,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDD4E48)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDD4E48), width: 1.5),
        ),
      ),
    );
  }
}

class TermsAgreement extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const TermsAgreement({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            activeColor: _RegisterColors.primary,
            checkColor: Colors.white,
            side: const BorderSide(color: Color(0xFFCDD5CE), width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (newValue) {
              onChanged(newValue ?? false);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Color(0xFF626B66), fontSize: 10),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: const TextStyle(
                    color: _RegisterColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTermsTap,
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: const TextStyle(
                    color: _RegisterColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onPrivacyTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const RegisterButton({
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
                colors: [Color(0xFF1CBE4E), Color(0xFF13A943)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2C1CBE4E),
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
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterDivider extends StatelessWidget {
  final String text;

  const RegisterDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE0E6E0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF8B918D), fontSize: 10),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE0E6E0))),
      ],
    );
  }
}

class RegisterSocialButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final VoidCallback onTap;

  const RegisterSocialButton({
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
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E6E0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return Icon(fallbackIcon, color: fallbackColor, size: 24);
                },
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF26362E),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlreadyAccountPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const AlreadyAccountPrompt({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(color: Color(0xFF68736D), fontSize: 12),
        ),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text(
              'Login',
              style: TextStyle(
                color: _RegisterColors.primaryDark,
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

class _RegisterColors {
  static const primary = Color(0xFF19B94B);
  static const primaryDark = Color(0xFF11933B);
  static const textPrimary = Color(0xFF153526);
  static const border = Color(0xFFDDE8DE);
}
