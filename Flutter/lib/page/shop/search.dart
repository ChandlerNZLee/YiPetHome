// lib/page/shop/search.dart
import 'package:flutter/material.dart';

import 'search-result.dart';
import '../my/community.dart';

import '../../view-models/search.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const Color divider = Color(0xFFECEEEB);
  static const Color background = Color(0xFFFCFDFB);

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final List<SearchSuggestionData> _popularSearches = const [
    SearchSuggestionData(
      title: 'dog food',
      iconColor: Color(0xFF22C55E),
      backgroundColor: Color(0xFFF0F9EE),
    ),
    SearchSuggestionData(
      title: 'cat litter',
      iconColor: Color(0xFF6B2C91),
      backgroundColor: Color(0xFFF4EEF8),
    ),
    SearchSuggestionData(
      title: 'grooming',
      iconColor: Color(0xFFE47A17),
      backgroundColor: Color(0xFFFFF3E8),
    ),
    SearchSuggestionData(
      title: 'dog toys',
      iconColor: Color(0xFFE44837),
      backgroundColor: Color(0xFFFFEEEE),
    ),
    SearchSuggestionData(
      title: 'pet shampoo',
      iconColor: Color(0xFFE83572),
      backgroundColor: Color(0xFFFFEEF5),
    ),
  ];

  final List<TrendingData> _trending = const [
    TrendingData(title: '#HealthyPet', posts: '12.9K posts'),
    TrendingData(title: '#PetLife', posts: '8.3K posts'),
    TrendingData(title: '#DogLove', posts: '6.7K posts'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  void _goBack() {
    FocusScope.of(context).unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _search(String keyword) {
    final value = keyword.trim();

    if (value.isEmpty) {
      return;
    }

    _searchController.text = value;
    _searchController.selection = TextSelection.collapsed(offset: value.length);

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchResultPage(keyword: value)),
    );
  }

  void _openTrending(String tag) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CommunityPage()));
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
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                14,
                horizontalPadding,
                0,
              ),
              child: SearchHeader(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onBackTap: _goBack,
                onSubmitted: _search,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: divider),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  media.viewInsets.bottom + 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: 'Popular Searches'),
                    const SizedBox(height: 8),
                    PopularSearchList(items: _popularSearches, onTap: _search),
                    const SizedBox(height: 16),
                    const SectionTitle(title: 'Trending'),
                    const SizedBox(height: 8),
                    TrendingList(items: _trending, onTap: _openTrending),
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

class SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onBackTap;
  final ValueChanged<String> onSubmitted;

  const SearchHeader({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onBackTap,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                color: SearchColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(28),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              cursorColor: SearchColors.primary,
              style: const TextStyle(
                fontSize: 12,
                color: SearchColors.textPrimary,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 24,
                  color: SearchColors.primary,
                ),
                hintText: 'Search...',
                hintStyle: TextStyle(fontSize: 12, color: Color(0xFF8C9198)),
                contentPadding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: SearchColors.textPrimary,
      ),
    );
  }
}

class PopularSearchList extends StatelessWidget {
  final List<SearchSuggestionData> items;
  final ValueChanged<String> onTap;

  const PopularSearchList({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Column(
          children: [
            PopularSearchTile(data: item, onTap: () => onTap(item.title)),
            if (index != items.length - 1)
              const Divider(height: 1, indent: 0, color: SearchColors.divider),
          ],
        );
      }),
    );
  }
}

class PopularSearchTile extends StatelessWidget {
  final SearchSuggestionData data;
  final VoidCallback onTap;

  const PopularSearchTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: data.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_rounded,
                  size: 24,
                  color: data.iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: SearchColors.textPrimary,
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

class TrendingList extends StatelessWidget {
  final List<TrendingData> items;
  final ValueChanged<String> onTap;

  const TrendingList({super.key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final item = items[index];

        return Column(
          children: [
            TrendingTile(data: item, onTap: () => onTap(item.title)),
            if (index != items.length - 1)
              const Divider(height: 1, indent: 0, color: SearchColors.divider),
          ],
        );
      }),
    );
  }
}

class TrendingTile extends StatelessWidget {
  final TrendingData data;
  final VoidCallback onTap;

  const TrendingTile({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F9EE),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '#',
                    style: TextStyle(
                      color: SearchColors.primary,
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  data.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: SearchColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                data.posts,
                style: const TextStyle(
                  fontSize: 16,
                  color: SearchColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
