// lib/page/login/reset.dart
import 'package:flutter/material.dart';

import '../../services/auth-service.dart';
import '../../core/network/api-exception.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  static const Color pageBackground = Color(0xFFF5FBF2);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();

    super.dispose();
  }

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your email.')));

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.instance.reset(email);

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Reset link sent'),
            content: Text('A password reset link has been sent to $email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
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

  void _openEmailSupport() {
    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening account recovery support'),
        duration: Duration(seconds: 1),
      ),
    );

    // TODO: 跳转 Customer Support 或 Account Recovery 页面。
  }

  void _goBack() {
    FocusScope.of(context).unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
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
            const Positioned.fill(child: ForgotPasswordBackground()),
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
                      child: ForgotPasswordHero(
                        horizontalPadding: horizontalPadding,
                        onBackTap: _goBack,
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                        ),
                        child: ForgotPasswordCard(
                          formKey: _formKey,
                          emailController: _emailController,
                          emailFocusNode: _emailFocusNode,
                          isLoading: _isLoading,
                          onSendResetLink: _sendResetLink,
                          onEmailSupportTap: _openEmailSupport,
                          onBackToLoginTap: _goBack,
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

class ForgotPasswordBackground extends StatelessWidget {
  const ForgotPasswordBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8FCF3), Color(0xFFF1F9EC), Color(0xFFF8FCF6)],
        ),
      ),
    );
  }
}

class ForgotPasswordHero extends StatelessWidget {
  final double horizontalPadding;
  final VoidCallback onBackTap;

  const ForgotPasswordHero({
    super.key,
    required this.horizontalPadding,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/login/reset-hero.png',
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
          left: horizontalPadding - 12,
          top: 10,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBackTap,
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 25,
                  color: Color(0xFF17352A),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: horizontalPadding,
          top: width * 0.23,
          width: width * 0.45,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Forgot\n',
                      style: TextStyle(color: Color(0xFF17372A)),
                    ),
                    TextSpan(
                      text: 'Password?',
                      style: TextStyle(color: Color(0xFF12A943)),
                    ),
                  ],
                ),
                style: TextStyle(
                  fontSize: 24,
                  height: 1.18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 19),
              Text(
                'No worries! Enter your email\n'
                'and we’ll send you a link to\n'
                'reset your password.',
                style: TextStyle(
                  color: Color(0xFF59665F),
                  fontSize: 12,
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ForgotPasswordCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final bool isLoading;
  final VoidCallback onSendResetLink;
  final VoidCallback onEmailSupportTap;
  final VoidCallback onBackToLoginTap;

  const ForgotPasswordCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.emailFocusNode,
    required this.isLoading,
    required this.onSendResetLink,
    required this.onEmailSupportTap,
    required this.onBackToLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(29),
        border: Border.all(color: const Color(0xFFDDE8DE)),
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
              'Enter your email address',
              style: TextStyle(
                color: Color(0xFF087F31),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            ForgotPasswordEmailField(
              controller: emailController,
              focusNode: emailFocusNode,
              onSubmitted: (_) {
                onSendResetLink();
              },
            ),
            const SizedBox(height: 12),
            const Text(
              'We’ll send you a link to reset your password.',
              style: TextStyle(
                color: Color(0xFF7B817E),
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SendResetLinkButton(isLoading: isLoading, onTap: onSendResetLink),
            const SizedBox(height: 24),
            const ForgotPasswordDivider(text: 'Or'),
            const SizedBox(height: 24),
            EmailSupportButton(onTap: onEmailSupportTap),
            const SizedBox(height: 36),
            BackToLoginPrompt(onTap: onBackToLoginTap),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordEmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onSubmitted;

  const ForgotPasswordEmailField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.email],
      onFieldSubmitted: onSubmitted,
      cursorColor: const Color(0xFF18A843),
      style: const TextStyle(color: Color(0xFF28352E), fontSize: 12),
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
      decoration: InputDecoration(
        hintText: 'Email Address',
        hintStyle: const TextStyle(color: Color(0xFFA1A8A4), fontSize: 12),
        prefixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F9EE),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              color: Color(0xFF18A843),
              size: 24,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 60,
          minHeight: 60,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        errorMaxLines: 2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFFDCE8DD), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFF24B74B), width: 1.7),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFFDC4C45)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Color(0xFFDC4C45), width: 1.5),
        ),
      ),
    );
  }
}

class SendResetLinkButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const SendResetLinkButton({
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
                      'Send Reset Link',
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

class ForgotPasswordDivider extends StatelessWidget {
  final String text;

  const ForgotPasswordDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE0E6E0), thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF8B918D), fontSize: 14),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE0E6E0), thickness: 1)),
      ],
    );
  }
}

class EmailSupportButton extends StatelessWidget {
  final VoidCallback onTap;

  const EmailSupportButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF49BC6B), width: 1.2),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mail_outline_rounded,
                color: Color(0xFF15933D),
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Can’t access your email?',
                style: TextStyle(
                  color: Color(0xFF15933D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BackToLoginPrompt extends StatelessWidget {
  final VoidCallback onTap;

  const BackToLoginPrompt({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'Remember your password? ',
            style: TextStyle(color: Color(0xFF4C8F5E), fontSize: 12),
          ),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Back to Login',
                style: TextStyle(
                  color: Color(0xFF128D3A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
