// lib/page/shop/search-result.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/shop-service.dart';
import '../../core/network/api-exception.dart';

import 'cart.dart';
import 'product.dart';

import '../../view-models/product.dart';
import '../../view-models/search-result.dart';
import '../../view-models/cart.dart';

class SearchResultPage extends ConsumerStatefulWidget {
  final String keyword;

  const SearchResultPage({super.key, required this.keyword});

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage> {
  static const Color background = Color(0xFFFCFDFB);

  late final TextEditingController _searchController;

  int _selectedCategory = 0;

  final List<String> _categories = const [
    'All',
    'Pet Food',
    'Snacks',
    'Toy & Bowl',
    'Clothes & Nook',
    'Daily Necessities',
    'Health & Medicine',
  ];

  List<ProductData> _allProducts = const [];
  List<ProductData> _products = const [];

  Future<void> _getProductList(String keyword) async {
    try {
      final res = await ShopService.instance.getSearchProductList(keyword);
      final list = res.products
          .map((item) => ProductData.fromModel(item))
          .toList();

      setState(() {
        _allProducts = list;
        _selectedCategory = 0;
        _products = _allProducts;
      });
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

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController(text: widget.keyword);
    _getProductList(widget.keyword);
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void _goBack() {
    FocusScope.of(context).unfocus();

    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _searchAgain(String value) {
    final keyword = value.trim();

    if (keyword.isEmpty) return;

    FocusScope.of(context).unfocus();

    _getProductList(keyword);
  }

  void _openCart() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
  }

  void _openSort() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sort by',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                _SortTile(
                  title: 'Recommended',
                  onTap: () => Navigator.pop(context),
                ),
                _SortTile(
                  title: 'Price: Low to High',
                  onTap: () => Navigator.pop(context),
                ),
                _SortTile(
                  title: 'Price: High to Low',
                  onTap: () => Navigator.pop(context),
                ),
                _SortTile(
                  title: 'Highest Rating',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleFavorite(ProductData product) {
    _showMessage('Favorite: ${product.name}');
  }

  void _addToCart(ProductData product) {
    ref
        .read(cartProvider.notifier)
        .addToCart(product: product, stock: product.stock);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openProduct(ProductData product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductPage(product: product)),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.047;

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
                12,
                horizontalPadding,
                0,
              ),
              child: SearchResultTopBar(
                controller: _searchController,
                onBackTap: _goBack,
                onCartTap: _openCart,
                onSubmitted: _searchAgain,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchResultHeader(
                            keyword: widget.keyword,
                            resultCount: _products.length,
                            onSortTap: _openSort,
                          ),
                          const SizedBox(height: 16),
                          SearchCategoryBar(
                            categories: _categories,
                            selectedIndex: _selectedCategory,
                            onChanged: (index) {
                              setState(() {
                                _selectedCategory = index;
                                _products = index == 0
                                    ? _allProducts
                                    : _allProducts
                                          .where(
                                            (item) =>
                                                item.category == index - 1,
                                          )
                                          .toList();
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      28,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = _products[index];

                        return SearchProductCard(
                          product: product,
                          onTap: () => _openProduct(product),
                          onFavoriteTap: () => _toggleFavorite(product),
                          onAddCartTap: () => _addToCart(product),
                        );
                      }, childCount: _products.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.62,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultTopBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onBackTap;
  final VoidCallback onCartTap;
  final ValueChanged<String> onSubmitted;

  const SearchResultTopBar({
    super.key,
    required this.controller,
    required this.onBackTap,
    required this.onCartTap,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundButton(
          icon: Icons.arrow_back_ios_new_rounded,
          iconColor: SearchResultColors.primary,
          onTap: onBackTap,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFF0F1F0)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,
              cursorColor: SearchResultColors.primary,
              style: const TextStyle(
                fontSize: 12,
                color: SearchResultColors.textPrimary,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: SearchResultColors.textPrimary,
                  size: 24,
                ),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: controller.clear,
                        icon: const Icon(
                          Icons.cancel_rounded,
                          size: 20,
                          color: Color(0xFFB2B5B9),
                        ),
                      ),
                contentPadding: const EdgeInsets.symmetric(vertical: 17),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _CartButton(onTap: onCartTap),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _RoundButton({
    required this.icon,
    required this.iconColor,
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
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F1F0)),
          ),
          child: Icon(icon, size: 24, color: iconColor),
        ),
      ),
    );
  }
}

class _CartButton extends ConsumerWidget {
  final VoidCallback onTap;

  const _CartButton({required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartTotalQuantityProvider);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F1F0)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Center(
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: SearchResultColors.primary,
                  size: 24,
                ),
              ),

              if (cartCount > 0)
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF269B43),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartCount > 99 ? '99+' : '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
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

class SearchResultHeader extends StatelessWidget {
  final String keyword;
  final int resultCount;
  final VoidCallback onSortTap;

  const SearchResultHeader({
    super.key,
    required this.keyword,
    required this.resultCount,
    required this.onSortTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Search Result',
                style: TextStyle(
                  fontSize: 18,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: SearchResultColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '$resultCount results for '),
                    TextSpan(
                      text: '“$keyword”',
                      style: const TextStyle(
                        color: SearchResultColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 14,
                  color: SearchResultColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onSortTap,
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFF0F1F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 18,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.swap_vert_rounded,
                    color: SearchResultColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Sort',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SearchResultColors.textPrimary,
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

class SearchCategoryBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const SearchCategoryBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const icons = [
      Icons.pets_outlined,
      Icons.food_bank_outlined,
      Icons.cookie_outlined,
      Icons.sports_baseball_outlined,
      Icons.home_outlined,
      Icons.watch_outlined,
      Icons.medical_services_outlined,
    ];

    return SizedBox(
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final selected = selectedIndex == index;

          return Material(
            color: selected ? SearchResultColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => onChanged(index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? SearchResultColors.primary
                        : const Color(0xFFF0F1F0),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      icons[index],
                      size: 16,
                      color: selected
                          ? Colors.white
                          : SearchResultColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : SearchResultColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchProductCard extends StatelessWidget {
  final ProductData product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddCartTap;

  const SearchProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddCartTap,
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
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F1F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 55,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(color: const Color(0xFFFAFAF8)),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                        child: Image.asset(
                          product.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.shopping_bag_outlined,
                              size: 60,
                              color: SearchResultColors.primary,
                            );
                          },
                        ),
                      ),
                    ),
                    if (product.stock.discount != 1.0)
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6670),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            '-10%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onFavoriteTap,
                          child: const SizedBox(
                            width: 32,
                            height: 32,
                            child: Icon(
                              Icons.favorite_border_rounded,
                              size: 24,
                              color: Color(0xFF31343A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 45,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: SearchResultColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        product.stock.size,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: SearchResultColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            (product.stock.price * product.stock.discount)
                                .toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: SearchResultColors.primary,
                            ),
                          ),
                          if (product.stock.discount != 1.0) ...[
                            const SizedBox(width: 6),
                            Text(
                              product.stock.price.toStringAsFixed(2),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF979BA0),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Spacer(),
                          Material(
                            color: SearchResultColors.primary,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: onAddCartTap,
                              child: const SizedBox(
                                width: 36,
                                height: 36,
                                child: Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _SortTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SortTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
