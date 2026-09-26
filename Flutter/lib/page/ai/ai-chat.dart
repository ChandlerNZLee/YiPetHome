// lib/page/ai/ai-chat.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../services/ai-service.dart';
import '../../core/network/api-exception.dart';

class AIChatPage extends StatefulWidget {
  final String? initialMessage;

  const AIChatPage({super.key, this.initialMessage});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final stt.SpeechToText _speech = stt.SpeechToText();
  final ImagePicker _picker = ImagePicker();

  final List<AiChatMessage> _messages = [];

  bool _isListening = false;
  bool _isSending = false;

  File? selectedImage;

  final List<String> _suggestions = const [
    'What can I feed my dog?',
    'How often should I groom my pet?',
    'Recommend pet products',
  ];

  @override
  void initState() {
    super.initState();

    final initial = widget.initialMessage?.trim();

    if (initial != null && initial.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = initial;
        _sendMessage();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    _speech.stop();

    super.dispose();
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _goBack() {
    FocusScope.of(context).unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  // ============================================================
  // IMAGE
  // ============================================================

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null || !mounted) return;

      setState(() {
        selectedImage = File(image.path);
      });

      _focusNode.requestFocus();
    } catch (e) {
      if (!mounted) return;

      _showError('Unable to select image.');
    }
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<void> _sendMessage() async {
    if (_isSending) return;

    final value = _controller.text.trim();
    final File? image = selectedImage;

    if (value.isEmpty && image == null) {
      return;
    }

    final String message = value.isNotEmpty
        ? value
        : 'Please analyze this image.';

    setState(() {
      _messages.add(
        AiChatMessage(
          type: AiChatMessageType.user,
          text: message,
          image: image,
        ),
      );

      selectedImage = null;
      _isSending = true;
    });

    _controller.clear();
    FocusScope.of(context).unfocus();

    _scrollToBottomDelayed();

    try {
      final response = image != null
          ? await AIService.instance.sendVisionMessage(value, image)
          : await AIService.instance.sendMessage(value);

      if (!mounted) return;

      setState(() {
        _messages.add(
          AiChatMessage(type: AiChatMessageType.ai, text: response.message),
        );
      });
    } on ApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          AiChatMessage(type: AiChatMessageType.error, text: e.message),
        );
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _messages.add(
          const AiChatMessage(
            type: AiChatMessageType.error,
            text: 'Sorry, I couldn\'t connect to YiPet AI. Please try again.',
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });

        _scrollToBottomDelayed();
      }
    }
  }

  void _sendSuggestion(String value) {
    if (_isSending) return;

    _controller.text = value;

    _controller.selection = TextSelection.collapsed(offset: value.length);

    _sendMessage();
  }

  // ============================================================
  // SCROLL
  // ============================================================

  void _scrollToBottomDelayed() {
    Future.delayed(const Duration(milliseconds: 120), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  // ============================================================
  // VOICE
  // ============================================================

  Future<void> _toggleVoice() async {
    if (_isSending) return;

    if (_isListening) {
      await _stopVoice();
      return;
    }

    final available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
          }
        }
      },
      onError: (error) {
        if (!mounted) return;

        setState(() {
          _isListening = false;
        });

        _showError('Speech recognition failed: ${error.errorMsg}');
      },
    );

    if (!available) {
      if (!mounted) return;

      _showError('Speech recognition is not available.');

      return;
    }

    setState(() {
      _isListening = true;
    });

    await _speech.listen(
      onResult: (result) {
        if (!mounted) return;

        final text = result.recognizedWords;

        setState(() {
          _controller.text = text;

          _controller.selection = TextSelection.collapsed(offset: text.length);
        });
      },
    );
  }

  Future<void> _stopVoice() async {
    await _speech.stop();

    if (!mounted) return;

    setState(() {
      _isListening = false;
    });

    _focusNode.requestFocus();
  }

  // ============================================================
  // ERROR
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _AiColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            AiChatHeader(onBackTap: _goBack),

            const Divider(height: 1, thickness: 1, color: _AiColors.border),

            // Messages
            Expanded(
              child: _messages.isEmpty ? _buildWelcome() : _buildMessages(),
            ),

            // Selected image
            if (selectedImage != null)
              SelectedImagePreview(
                image: selectedImage!,
                onRemove: removeImage,
              ),

            // Input
            AiChatInputBar(
              controller: _controller,
              focusNode: _focusNode,
              onSend: _sendMessage,
              onVoiceTap: _toggleVoice,
              onImageTap: pickImage,
              isListening: _isListening,
              isSending: _isSending,
              bottomPadding: bottomPadding,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 32),
        child: Column(
          children: [
            // Robot
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: _AiColors.primarySoft,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/ai_chat/robot-avatar.png',
                  width: 58,
                  height: 58,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.smart_toy_rounded,
                      size: 42,
                      color: _AiColors.primary,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'How can I help you?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                height: 1.2,
                fontWeight: FontWeight.w800,
                color: _AiColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Ask YiPet AI anything about your pet, grooming, feeding, products or daily care.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: _AiColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 36),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suggested questions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _AiColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            ..._suggestions.map(
              (suggestion) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SuggestionCard(
                  text: suggestion,
                  onTap: () => _sendSuggestion(suggestion),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
      itemCount: _messages.length + (_isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isSending && index == _messages.length) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 22),
            child: AiTypingBubble(),
          );
        }

        final message = _messages[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 22),
          child: switch (message.type) {
            AiChatMessageType.user => UserMessageBubble(
              message: message.text,
              image: message.image,
            ),
            AiChatMessageType.ai => AiMessageBubble(message: message.text),
            AiChatMessageType.error => AiErrorBubble(message: message.text),
          },
        );
      },
    );
  }
}

// ============================================================
// HEADER
// ============================================================

class AiChatHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const AiChatHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBackTap,
              borderRadius: BorderRadius.circular(50),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: _AiColors.textPrimary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 2),

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _AiColors.primarySoft,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/ai_chat/robot-avatar.png',
                width: 34,
                height: 34,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.smart_toy_rounded,
                    size: 24,
                    color: _AiColors.primary,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: 11),

          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YiPet AI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _AiColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    _OnlineDot(),
                    SizedBox(width: 6),
                    Text(
                      'AI Assistant',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: _AiColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnlineDot extends StatelessWidget {
  const _OnlineDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: _AiColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ============================================================
// SUGGESTION
// ============================================================

class SuggestionCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SuggestionCard({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _AiColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _AiColors.primarySoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: _AiColors.primary,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: _AiColors.textPrimary,
                  ),
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: _AiColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// USER MESSAGE
// ============================================================

class UserMessageBubble extends StatelessWidget {
  final String message;
  final File? image;

  const UserMessageBubble({super.key, required this.message, this.image});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.78),
        padding: image == null
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 13)
            : const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: _AiColors.userBubble,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.file(image!, width: 240, fit: BoxFit.cover),
              ),

            if (image != null && message.isNotEmpty) const SizedBox(height: 6),

            if (message.isNotEmpty)
              Padding(
                padding: image != null
                    ? const EdgeInsets.fromLTRB(10, 7, 10, 8)
                    : EdgeInsets.zero,
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: _AiColors.textPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// AI MESSAGE
// ============================================================

class AiMessageBubble extends StatelessWidget {
  final String message;

  const AiMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AiAvatar(),

        const SizedBox(width: 10),

        Flexible(
          child: Container(
            constraints: BoxConstraints(maxWidth: width * 0.76),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: _AiColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 18,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: _AiMessageText(text: message),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// ERROR MESSAGE
// ============================================================

class AiErrorBubble extends StatelessWidget {
  final String message;

  const AiErrorBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AiAvatar(),

        const SizedBox(width: 10),

        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF5F5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
              border: Border.all(color: const Color(0xFFFFDDDD)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 18,
                  color: Color(0xFFE25454),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.45,
                      color: Color(0xFFB34242),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// AI AVATAR
// ============================================================

class AiAvatar extends StatelessWidget {
  const AiAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: _AiColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/ai_chat/robot-avatar.png',
          width: 31,
          height: 31,
          errorBuilder: (_, __, ___) {
            return const Icon(
              Icons.smart_toy_rounded,
              size: 22,
              color: _AiColors.primary,
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// AI TEXT
// ============================================================

class _AiMessageText extends StatelessWidget {
  final String text;

  const _AiMessageText({required this.text});

  @override
  Widget build(BuildContext context) {
    final lines = text.split('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final trimmed = line.trim();

        if (trimmed.isEmpty) {
          return const SizedBox(height: 7);
        }

        final isBullet =
            trimmed.startsWith('✓') ||
            trimmed.startsWith('•') ||
            trimmed.startsWith('- ');

        if (isBullet) {
          String value = trimmed;

          value = value
              .replaceFirst('✓', '')
              .replaceFirst('•', '')
              .replaceFirst(RegExp(r'^-\s*'), '')
              .trim();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 19,
                  height: 19,
                  margin: const EdgeInsets.only(top: 1),
                  decoration: const BoxDecoration(
                    color: _AiColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 13,
                    color: _AiColors.primary,
                  ),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: _AiColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            line,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: _AiColors.textPrimary,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ============================================================
// TYPING
// ============================================================

class AiTypingBubble extends StatelessWidget {
  const AiTypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [AiAvatar(), SizedBox(width: 10), _TypingContainer()],
    );
  }
}

class _TypingContainer extends StatefulWidget {
  const _TypingContainer();

  @override
  State<_TypingContainer> createState() => _TypingContainerState();
}

class _TypingContainerState extends State<_TypingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animation;

  @override
  void initState() {
    super.initState();

    _animation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
        border: Border.all(color: _AiColors.border),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final value = _animation.value;

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (index) {
              final position = ((value * 3) - index).abs();

              final opacity = (1 - position.clamp(0.25, 0.7)).clamp(0.35, 0.85);

              return Container(
                width: 6,
                height: 6,
                margin: EdgeInsets.only(right: index == 2 ? 0 : 5),
                decoration: BoxDecoration(
                  color: _AiColors.primary.withValues(alpha: opacity),
                  shape: BoxShape.circle,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

// ============================================================
// SELECTED IMAGE
// ============================================================

class SelectedImagePreview extends StatelessWidget {
  final File image;
  final VoidCallback onRemove;

  const SelectedImagePreview({
    super.key,
    required this.image,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _AiColors.background,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _AiColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.file(
                  image,
                  width: 74,
                  height: 74,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              right: -7,
              top: -7,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _AiColors.textPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INPUT BAR
// ============================================================

class AiChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  final VoidCallback onSend;
  final VoidCallback onVoiceTap;
  final VoidCallback onImageTap;

  final bool isListening;
  final bool isSending;

  final double bottomPadding;

  const AiChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onVoiceTap,
    required this.onImageTap,
    required this.isListening,
    required this.isSending,
    required this.bottomPadding,
  });

  @override
  State<AiChatInputBar> createState() => _AiChatInputBarState();
}

class _AiChatInputBarState extends State<AiChatInputBar> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_refresh);
  }

  @override
  void didUpdateWidget(covariant AiChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_refresh);
      widget.controller.addListener(_refresh);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);

    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final canSend =
        widget.controller.text.trim().isNotEmpty && !widget.isSending;

    return Container(
      padding: EdgeInsets.fromLTRB(18, 10, 18, widget.bottomPadding + 12),
      decoration: const BoxDecoration(
        color: _AiColors.background,
        border: Border(top: BorderSide(color: Color(0xFFF1F3F1))),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _AiColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 24,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Image
            InputIconButton(
              icon: Icons.add_photo_alternate_outlined,
              onTap: widget.isSending ? null : widget.onImageTap,
            ),

            const SizedBox(width: 4),

            // Text
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: widget.focusNode,
                minLines: 1,
                maxLines: 5,
                enabled: !widget.isSending,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: _AiColors.primary,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: _AiColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 10,
                  ),
                  hintText: 'Message YiPet AI...',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: _AiColors.textMuted,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 5),

            // Voice
            if (!canSend)
              InputIconButton(
                icon: widget.isListening
                    ? Icons.stop_rounded
                    : Icons.mic_none_rounded,
                active: widget.isListening,
                onTap: widget.isSending ? null : widget.onVoiceTap,
              ),

            if (!canSend) const SizedBox(width: 4),

            // Send
            Material(
              color: canSend ? _AiColors.primary : _AiColors.primaryDisabled,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: canSend ? widget.onSend : null,
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 43,
                  height: 43,
                  child: widget.isSending
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.arrow_upward_rounded,
                          size: 21,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INPUT ICON
// ============================================================

class InputIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool active;

  const InputIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? _AiColors.primarySoft : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: 22,
            color: onTap == null
                ? _AiColors.textMuted
                : active
                ? _AiColors.primary
                : _AiColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// MODELS
// ============================================================

enum AiChatMessageType { user, ai, error }

class AiChatMessage {
  final AiChatMessageType type;
  final String text;
  final File? image;

  const AiChatMessage({required this.type, required this.text, this.image});
}

// ============================================================
// COLORS
// ============================================================

class _AiColors {
  static const Color primary = Color(0xFF16B85A);

  static const Color primarySoft = Color(0xFFEAF8EF);

  static const Color primaryDisabled = Color(0xFFA7DDBB);

  static const Color background = Color(0xFFF8FAF8);

  static const Color userBubble = Color(0xFFE9F8EE);

  static const Color border = Color(0xFFE8ECE9);

  static const Color textPrimary = Color(0xFF171A1D);

  static const Color textSecondary = Color(0xFF667085);

  static const Color textMuted = Color(0xFFA0A7B0);
}
