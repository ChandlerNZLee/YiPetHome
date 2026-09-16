// lib/page/ai/ai-chat.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/ai-service.dart';
import '../../core/network/api-exception.dart';

class AIChatPage extends StatefulWidget {
  final String? initialMessage;

  const AIChatPage({super.key, this.initialMessage});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> {
  static const Color background = Color(0xFFFCFDFB);

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  final List<AiChatMessage> _messages = [];

  final List<AiRecommendedProduct> _products = const [
    AiRecommendedProduct(
      name: 'Royal Canin',
      subtitle: 'Sensitive',
      price: 39.09,
      imagePath: 'assets/images/ai_chat/royal-canin.png',
    ),
    AiRecommendedProduct(
      name: 'Hill’s Science',
      subtitle: 'Diet Id',
      price: 42.99,
      imagePath: 'assets/images/ai_chat/hills-science.png',
    ),
    AiRecommendedProduct(
      name: 'Wellness',
      subtitle: 'Sensitive',
      price: 45.50,
      imagePath: 'assets/images/ai_chat/wellness.png',
    ),
  ];

  @override
  void initState() {
    super.initState();

    final initial = widget.initialMessage?.trim();

    if (initial != null && initial.isNotEmpty) {
      _messages.add(AiChatMessage(type: AiChatMessageType.user, text: initial));

      _messages.add(
        const AiChatMessage(
          type: AiChatMessageType.ai,
          text:
              'For dogs with a sensitive stomach, I recommend:\n\n'
              '✓  Boiled chicken and rice\n'
              '✓  Pumpkin puree\n'
              '✓  Probiotics\n'
              '✓  Avoid dairy and greasy food',
          showProducts: true,
        ),
      );
    } else {
      _messages.add(
        const AiChatMessage(
          type: AiChatMessageType.user,
          text: 'What can I feed my dog\nfor sensitive stomach?',
        ),
      );

      _messages.add(
        const AiChatMessage(
          type: AiChatMessageType.ai,
          text:
              'For dogs with a sensitive\n'
              'stomach, I recommend:\n\n'
              '✓  Boiled chicken and rice\n'
              '✓  Pumpkin puree\n'
              '✓  Probiotics\n'
              '✓  Avoid dairy and greasy food',
          showProducts: true,
        ),
      );
    }
  }

  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,

      imageQuality: 90,
    );

    if (image == null) {
      return;
    }

    setState(() {
      selectedImage = File(image.path);
    });
  }

  void removeImage() {
    setState(() {
      selectedImage = null;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _goBack() {
    FocusScope.of(context).unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  Future<void> _sendMessage() async {
    final value = _controller.text.trim();

    if (value.isEmpty && selectedImage == null) return;

    final File? image = selectedImage;

    if (image != null) {
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
      });
    } else {
      setState(() {
        _messages.add(AiChatMessage(type: AiChatMessageType.user, text: value));
      });
    }

    _controller.clear();
    FocusScope.of(context).unfocus();

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    try {
      final res = image != null
          ? await AIService.instance.sendVisionMessage(value, image)
          : await AIService.instance.sendMessage(value);

      setState(() {
        _messages.add(
          AiChatMessage(type: AiChatMessageType.ai, text: res.message),
        );
      });

      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
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

  void _openProduct(AiRecommendedProduct product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(product.name),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPadding = media.size.width * 0.055;

    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                0,
              ),
              child: AiChatHeader(onBackTap: _goBack),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  14,
                  horizontalPadding,
                  24,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: message.type == AiChatMessageType.user
                        ? UserMessageBubble(
                            message: message.text,
                            image: message.image,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AiMessageBubble(message: message.text),

                              if (message.showProducts) ...[
                                const SizedBox(height: 18),

                                AiProductRecommendationSection(
                                  products: _products,
                                  onProductTap: _openProduct,
                                ),
                              ],
                            ],
                          ),
                  );
                },
              ),
            ),
            if (selectedImage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selectedImage!,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: -8,
                        right: -8,
                        child: GestureDetector(
                          onTap: removeImage,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            AiChatInputBar(
              controller: _controller,
              focusNode: _focusNode,
              onSend: _sendMessage,
              onVoiceTap: _startVoice,
              onImageTap: pickImage,
            ),
          ],
        ),
      ),
    );
  }
}

class AiChatHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const AiChatHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBackTap,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 24,
                  color: _AiChatColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Ask AI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: _AiChatColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

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
        constraints: BoxConstraints(maxWidth: width * 0.65),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9EA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(image!, width: 220, fit: BoxFit.cover),
              ),

            if (image != null && message.isNotEmpty) const SizedBox(height: 10),

            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w400,
                    color: _AiChatColors.textPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AiMessageBubble extends StatelessWidget {
  final String message;

  const AiMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(
          offset: const Offset(0, -10),
          child: Container(
            width: 36,
            height: 36,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE8EEE7)),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/ai_chat/robot-avatar.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.smart_toy_rounded,
                    size: 24,
                    color: _AiChatColors.primary,
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.65),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F2EF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: _AiMessageText(text: message),
        ),
      ],
    );
  }
}

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

        if (trimmed.startsWith('✓')) {
          final value = trimmed.replaceFirst('✓', '').trim();

          return Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Color(0xFFFFA90A),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: _AiChatColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (trimmed.isEmpty) {
          return const SizedBox(height: 4);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            line,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: _AiChatColors.textPrimary,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AiProductRecommendationSection extends StatelessWidget {
  final List<AiRecommendedProduct> products;
  final ValueChanged<AiRecommendedProduct> onProductTap;

  const AiProductRecommendationSection({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 0, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF0F2EF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Text(
              'Here are some suitable\nproducts:',
              style: TextStyle(
                fontSize: 16,
                height: 1.4,
                color: _AiChatColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(right: 16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return AiRecommendedProductCard(
                  product: products[index],
                  onTap: () => onProductTap(products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AiRecommendedProductCard extends StatelessWidget {
  final AiRecommendedProduct product;
  final VoidCallback onTap;

  const AiRecommendedProductCard({
    super.key,
    required this.product,
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
          width: 190,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F1F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(
                    product.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) {
                      return const Icon(
                        Icons.shopping_bag_outlined,
                        size: 78,
                        color: _AiChatColors.primary,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _AiChatColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _AiChatColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _AiChatColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AiChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onVoiceTap;
  final VoidCallback onImageTap;

  const AiChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onVoiceTap,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(22, 10, 22, bottom + 12),
      decoration: const BoxDecoration(color: Color(0xFFFCFDFB)),
      child: Container(
        height: 56,
        padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFF0F1F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 28,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                cursorColor: _AiChatColors.primary,
                style: const TextStyle(
                  fontSize: 14,
                  color: _AiChatColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ask follow up question...',
                  hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA0A4AA)),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onImageTap,
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: _AiChatColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Material(
              color: _AiChatColors.primary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onVoiceTap,
                child: const SizedBox(
                  width: 36,
                  height: 36,
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
      ),
    );
  }
}

enum AiChatMessageType { user, ai }

class AiChatMessage {
  final AiChatMessageType type;
  final String text;
  final File? image;
  final bool showProducts;

  const AiChatMessage({
    required this.type,
    required this.text,
    this.image,
    this.showProducts = false,
  });
}

class AiRecommendedProduct {
  final String name;
  final String subtitle;
  final double price;
  final String imagePath;

  const AiRecommendedProduct({
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imagePath,
  });
}

class _AiChatColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
}
