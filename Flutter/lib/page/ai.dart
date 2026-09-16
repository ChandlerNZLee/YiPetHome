// lib/page/ai.dart
import 'package:flutter/material.dart';

import 'ai/ai-chat.dart';

import '../view-models/ai.dart';

class AIPage extends StatefulWidget {
  const AIPage({super.key});

  @override
  State<AIPage> createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> {
  static const Color textPrimary = Color(0xFF17191D);
  static const Color background = Color(0xFFFCFDFB);

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<AiActionData> _actions = const [
    AiActionData(
      title: 'Image Analysis',
      subtitle: 'Analyze pet’s skin,\nwound or behavior',
      imagePath: 'assets/images/ai/image-analysis.png',
      icon: Icons.camera_alt_outlined,
    ),
    AiActionData(
      title: 'Symptom Checker',
      subtitle: 'Check possible\nhealth issues',
      imagePath: 'assets/images/ai/symptom.png',
      icon: Icons.health_and_safety_outlined,
    ),
    AiActionData(
      title: 'Food Advisor',
      subtitle: 'Get diet advice\nfor your pet',
      imagePath: 'assets/images/ai/food.png',
      icon: Icons.restaurant_menu_rounded,
    ),
    AiActionData(
      title: 'Behavior Help',
      subtitle: 'Solve behavior\nproblems',
      imagePath: 'assets/images/ai/behavior.png',
      icon: Icons.favorite_border_rounded,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      _focusNode.requestFocus();

      return;
    }

    _controller.clear();

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 1)),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AIChatPage(initialMessage: text)),
    );
  }

  void _startVoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice input'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openAction(AiActionData data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data.title), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.055;

    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              15,
              horizontalPadding,
              media.viewInsets.bottom + 28,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AiHero(),
                const SizedBox(height: 4),
                AiQuestionBox(
                  controller: _controller,
                  focusNode: _focusNode,
                  onVoiceTap: _startVoice,
                  onSubmitted: (_) => _sendMessage(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Try these',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(_actions.length, (index) {
                  final action = _actions[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == _actions.length - 1 ? 0 : 8,
                    ),
                    child: AiActionCard(
                      data: action,
                      onTap: () => _openAction(action),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AiHero extends StatelessWidget {
  const AiHero({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: width * 0.48 + 16,
      child: Stack(
        children: [
          Positioned(
            left: 3,
            top: 48,
            width: width * 0.46,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello!',
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                    color: AiColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'I’m YiPet AI',
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w700,
                    color: AiColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'How can I help you\nand your pet today?',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.55,
                    color: AiColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -4,
            top: 16,
            width: width * 0.48,
            child: Image.asset(
              'assets/images/ai/robot.png',
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
              errorBuilder: (_, __, ___) {
                return const Center(
                  child: Icon(
                    Icons.smart_toy_rounded,
                    size: 150,
                    color: AiColors.primary,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AiQuestionBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onVoiceTap;
  final ValueChanged<String> onSubmitted;

  const AiQuestionBox({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onVoiceTap,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AiColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AIChatPage()),
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ask anything about\nyour pet...',
                    hintStyle: TextStyle(
                      color: Color(0xFF92969E),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AiColors.primary,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onVoiceTap,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.mic_none_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AiActionCard extends StatelessWidget {
  final AiActionData data;
  final VoidCallback onTap;

  const AiActionCard({super.key, required this.data, required this.onTap});

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
          height: 80,
          padding: const EdgeInsets.fromLTRB(15, 13, 14, 13),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AiColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x07000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 60,
                child: Center(
                  child: Image.asset(
                    data.imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.pets,
                        size: 58,
                        color: AiColors.primary,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AiColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.25,
                        color: AiColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F9EE),
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, size: 24, color: AiColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
