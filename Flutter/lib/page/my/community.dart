// lib/page/my/community.dart
import 'package:flutter/material.dart';

import '../../view-models/community.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  static const Color border = Color(0xFFECEFEC);
  static const Color background = Color(0xFFFCFDFB);

  int _selectedTab = 0;

  final List<CommunityPostData> _followingPosts = [
    CommunityPostData(
      id: 1,
      userName: 'Sarah & Max',
      time: '2 hours ago',
      avatarPath: 'assets/images/community/sarah-avatar.png',
      content: 'Weekend hiking with Max!\nHe loves the nature! 🌲🐶',
      imagePaths: const [
        'assets/images/community/max-hiking-1.png',
        'assets/images/community/max-hiking-2.png',
      ],
      likes: 120,
      comments: 34,
      liked: false,
    ),
    CommunityPostData(
      id: 2,
      userName: 'David & Luna',
      time: '5 hours ago',
      avatarPath: 'assets/images/community/david-avatar.png',
      content: 'Happy dog, happy life!',
      imagePaths: const [
        'assets/images/community/luna-1.png',
        'assets/images/community/luna-2.png',
      ],
      likes: 88,
      comments: 16,
      liked: false,
    ),
  ];

  final List<CommunityPostData> _discoverPosts = [
    CommunityPostData(
      id: 3,
      userName: 'Emily & Coco',
      time: '1 hour ago',
      avatarPath: 'assets/images/community/emily-avatar.png',
      content: 'Coco found a new favorite toy today! 🧸',
      imagePaths: const [
        'assets/images/community/coco-1.png',
        'assets/images/community/coco-2.png',
      ],
      likes: 205,
      comments: 52,
      liked: false,
    ),
    CommunityPostData(
      id: 4,
      userName: 'James & Buddy',
      time: '3 hours ago',
      avatarPath: 'assets/images/community/james-avatar.png',
      content: 'A perfect afternoon walk with Buddy.',
      imagePaths: const [
        'assets/images/community/buddy-1.png',
        'assets/images/community/buddy-2.png',
      ],
      likes: 142,
      comments: 27,
      liked: false,
    ),
  ];

  List<CommunityPostData> get _posts {
    return _selectedTab == 0 ? _followingPosts : _discoverPosts;
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _toggleLike(int index) {
    setState(() {
      final post = _posts[index];

      post.liked = !post.liked;

      if (post.liked) {
        post.likes++;
      } else if (post.likes > 0) {
        post.likes--;
      }
    });
  }

  void _openComments(CommunityPostData post) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comments: ${post.userName}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openMore(CommunityPostData post) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.bookmark_border_rounded),
                  title: const Text('Save post'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Report'),
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.055;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                0,
              ),
              child: CommunityHeader(onBackTap: _goBack),
            ),
            const SizedBox(height: 8),
            CommunityTabBar(
              selectedIndex: _selectedTab,
              onChanged: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),
            const Divider(height: 1, color: border),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 30),
                itemCount: _posts.length,
                separatorBuilder: (_, __) {
                  return const Divider(height: 1, color: border);
                },
                itemBuilder: (context, index) {
                  final post = _posts[index];

                  return CommunityPost(
                    data: post,
                    onLikeTap: () => _toggleLike(index),
                    onCommentTap: () => _openComments(post),
                    onMoreTap: () => _openMore(post),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const CommunityHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Community',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: CommunityColors.textPrimary,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
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
                    color: CommunityColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CommunityTabBar({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          Expanded(
            child: CommunityTabItem(
              label: 'Following',
              selected: selectedIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: CommunityTabItem(
              label: 'Discover',
              selected: selectedIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityTabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const CommunityTabItem({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 36,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? CommunityColors.textPrimary
                      : CommunityColors.textSecondary,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: selected ? 32 : 0,
                height: 4,
                decoration: BoxDecoration(
                  color: CommunityColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityPost extends StatelessWidget {
  final CommunityPostData data;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onMoreTap;

  const CommunityPost({
    super.key,
    required this.data,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.055;

    return Padding(
      padding: EdgeInsets.fromLTRB(horizontalPadding, 16, horizontalPadding, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommunityPostHeader(data: data, onMoreTap: onMoreTap),
          const SizedBox(height: 16),
          Text(
            data.content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w400,
              color: CommunityColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          CommunityPostImages(imagePaths: data.imagePaths),
          const SizedBox(height: 16),
          CommunityPostActions(
            liked: data.liked,
            likes: data.likes,
            comments: data.comments,
            onLikeTap: onLikeTap,
            onCommentTap: onCommentTap,
          ),
        ],
      ),
    );
  }
}

class CommunityPostHeader extends StatelessWidget {
  final CommunityPostData data;
  final VoidCallback onMoreTap;

  const CommunityPostHeader({
    super.key,
    required this.data,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            data.avatarPath,
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                width: 56,
                height: 56,
                color: const Color(0xFFF0F8ED),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: CommunityColors.primary,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.userName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: CommunityColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.time,
                style: const TextStyle(
                  fontSize: 12,
                  color: CommunityColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onMoreTap,
          icon: const Icon(
            Icons.more_vert_rounded,
            size: 24,
            color: CommunityColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class CommunityPostImages extends StatelessWidget {
  final List<String> imagePaths;

  const CommunityPostImages({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    if (imagePaths.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 1.45,
          child: Image.asset(
            imagePaths.first,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Container(
                color: const Color(0xFFF1F4F1),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_outlined,
                  size: 48,
                  color: CommunityColors.textSecondary,
                ),
              );
            },
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: CommunityPostImage(path: imagePaths[0])),
        const SizedBox(width: 12),
        Expanded(child: CommunityPostImage(path: imagePaths[1])),
      ],
    );
  }
}

class CommunityPostImage extends StatelessWidget {
  final String path;

  const CommunityPostImage({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 0.95,
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: const Color(0xFFF1F4F1),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_outlined,
                size: 48,
                color: CommunityColors.textSecondary,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CommunityPostActions extends StatelessWidget {
  final bool liked;
  final int likes;
  final int comments;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;

  const CommunityPostActions({
    super.key,
    required this.liked,
    required this.likes,
    required this.comments,
    required this.onLikeTap,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onLikeTap,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Icon(
                    liked
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 24,
                    color: liked
                        ? const Color(0xFFFF4D67)
                        : CommunityColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$likes',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CommunityColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 28),
        Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onCommentTap,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 24,
                    color: CommunityColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$comments',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CommunityColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
