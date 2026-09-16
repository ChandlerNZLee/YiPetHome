// lib/page/shop/category-products.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/shop-service.dart';
import '../../core/network/api-exception.dart';

import '../../view-models/product.dart';
import '../../view-models/cart.dart';

import 'product.dart';

class CategoryProductsPage extends ConsumerStatefulWidget {
  final String? category;

  const CategoryProductsPage({super.key, this.category = 'Dog Food'});

  @override
  ConsumerState<CategoryProductsPage> createState() =>
      _CategoryProductsPageState();
}

class _CategoryProductsPageState extends ConsumerState<CategoryProductsPage> {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF5C6782);
  static const Color border = Color(0xFFE6EAE6);
  static const Color background = Color(0xFFFCFDFB);

  late String _selectedCategory;

  String _sortType = 'Popular';

  final TextEditingController _searchController = TextEditingController();

  final List<CategoryData> _categories = const [
    CategoryData(id: 0, title: 'Pet Food', icon: Icons.pets_outlined),
    CategoryData(id: 1, title: 'Snacks', icon: Icons.cookie_outlined),
    CategoryData(
      id: 2,
      title: 'Toy & Bowl',
      icon: Icons.sports_baseball_outlined,
    ),
    CategoryData(id: 3, title: 'Clothes & Nook', icon: Icons.home_outlined),
    CategoryData(id: 4, title: 'Daily Necessities', icon: Icons.watch_outlined),
    CategoryData(
      id: 5,
      title: 'Health & Medicine',
      icon: Icons.medical_services_outlined,
    ),
  ];

  List<ProductData> _allProducts = [];
  List<ProductData> _products = [];

  Future<void> _getProductList() async {
    try {
      final res = await ShopService.instance.getProductList();
      final list = res.products
          .map((item) => ProductData.fromModel(item))
          .toList();

      setState(() {
        _allProducts = list;
        _selectedCategory = _categories.first.title;
        _products = _allProducts.where((item) => item.type == 0).toList();
      });

      if (widget.category != null && widget.category!.isNotEmpty) {
        final index = _categories.indexWhere(
          (item) => item.title == widget.category,
        );

        if (index != -1) {
          setState(() {
            _selectedCategory = _categories[index].title;
            _products = _allProducts
                .where((item) => item.type == _categories[index].id)
                .toList();
          });
        }
      }
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

    _getProductList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _toggleFavorite(ProductData product) {
    setState(() {
      product.isFavorite = !product.isFavorite;
    });
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

  void _changeCategory(int index) {
    setState(() {
      _selectedCategory = _categories[index].title;
      _products = _allProducts
          .where((item) => item.type == _categories[index].id)
          .toList();
    });
  }

  void _goToProduct(ProductData product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductPage(product: product)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildSearchArea(),
            const SizedBox(height: 18),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategorySidebar(),
                  Expanded(child: _buildProductArea()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _goBack,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 24,
                      color: Color(0xFF111820),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _selectedCategory,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'High-quality nutrition for your furry friend',
                  style: TextStyle(fontSize: 12, color: textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: TextField(
                controller: _searchController,
                cursorColor: primary,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search in $_selectedCategory',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9299A8),
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 24,
                    color: Color(0xFF667087),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primary, width: 1.3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySidebar() {
    return Container(
      width: 108,
      decoration: const BoxDecoration(
        color: Color(0xFFFBFCFA),
        border: Border(right: BorderSide(color: Color(0xFFF0F1F0))),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 4, bottom: 24),
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];

          return CategorySidebarItem(
            data: category,
            selected: category.title == _selectedCategory,
            onTap: () {
              _changeCategory(category.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductArea() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Text(
                '24 Products',
                style: TextStyle(fontSize: 12, color: textSecondary),
              ),
              const Spacer(),
              _buildSortButton(),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            itemCount: _products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.43,
            ),
            itemBuilder: (context, index) {
              final product = _products[index];

              return ProductCard(
                data: product,
                onFavoriteTap: () {
                  _toggleFavorite(product);
                },
                onAddTap: () {
                  _addToCart(product);
                },
                onTap: () {
                  _goToProduct(product);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<String>(
      initialValue: _sortType,
      onSelected: (value) {
        setState(() {
          _sortType = value;
        });
      },
      offset: const Offset(0, 42),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (_) {
        return const [
          PopupMenuItem(value: 'Popular', child: Text('Popular')),
          PopupMenuItem(value: 'Newest', child: Text('Newest')),
          PopupMenuItem(
            value: 'Price Low to High',
            child: Text('Price Low to High'),
          ),
          PopupMenuItem(
            value: 'Price High to Low',
            child: Text('Price High to Low'),
          ),
        ];
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sort by: ',
            style: TextStyle(fontSize: 12, color: textSecondary),
          ),
          Text(
            _sortType,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: textSecondary,
          ),
        ],
      ),
    );
  }
}

class CategorySidebarItem extends StatelessWidget {
  const CategorySidebarItem({
    super.key,
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final CategoryData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF0F8EE) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                data.icon,
                size: 24,
                color: selected
                    ? const Color(0xFF15952A)
                    : const Color(0xFF596177),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data.title,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.25,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? const Color(0xFF15952A)
                        : const Color(0xFF31394D),
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

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.data,
    required this.onFavoriteTap,
    required this.onAddTap,
    required this.onTap,
  });

  final ProductData data;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddTap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6EAE6)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x05000000),
                blurRadius: 12,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 10,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          data.imagePath,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }

                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (_, __, ___) {
                            return Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F9F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                size: 44,
                                color: Color(0xFFB0B7B0),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onFavoriteTap,
                        child: Container(
                          width: 36,
                          height: 36,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            data.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 24,
                            color: data.isFavorite
                                ? const Color(0xFFE94362)
                                : const Color(0xFF626B7E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172038),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.stock.size,
                        style: const TextStyle(
                          fontSize: 8,
                          color: Color(0xFF5C6782),
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            '\$${data.stock.price}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF15952A),
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: onAddTap,
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Color(0xFF15952A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 16,
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

class ProductRating extends StatelessWidget {
  const ProductRating({super.key, required this.rating, required this.reviews});

  final double rating;
  final int reviews;

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor();

    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < fullStars ? Icons.star_rounded : Icons.star_border_rounded,
            size: 12,
            color: const Color(0xFFFFB000),
          );
        }),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            '($reviews)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 8, color: Color(0xFF5C6782)),
          ),
        ),
      ],
    );
  }
}
