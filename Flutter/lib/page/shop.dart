// lib/page/shop.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/shop-service.dart';
import '../core/network/api-exception.dart';

import 'shop/search.dart';
import 'shop/cart.dart';
import 'shop/category-products.dart';
import 'shop/product-list.dart';
import 'shop/product.dart';
import 'pet/appointment.dart';

import '../view-models/shop.dart';
import '../view-models/product.dart';
import '../view-models/cart.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  static const Color background = Color(0xFFFCFDFB);

  final TextEditingController _searchController = TextEditingController();

  final List<CategoryData> _categories = const [
    CategoryData(
      id: 0,
      title: 'Pet Food',
      imagePath: 'assets/images/shop/category-food.png',
    ),
    CategoryData(
      id: 1,
      title: 'Snacks',
      imagePath: 'assets/images/shop/category-treats.png',
    ),
    CategoryData(
      id: 2,
      title: 'Toy & Bowl',
      imagePath: 'assets/images/shop/category-toys.png',
    ),
    CategoryData(
      id: 3,
      title: 'Clothes & Nook',
      imagePath: 'assets/images/shop/category-health.png',
    ),
    CategoryData(
      id: -1,
      title: 'Grooming',
      imagePath: 'assets/images/shop/category-grooming.png',
    ),
    CategoryData(
      id: 4,
      title: 'Daily Necessities',
      imagePath: 'assets/images/shop/category-beds.png',
    ),
    CategoryData(
      id: 5,
      title: 'Health & Medicine',
      imagePath: 'assets/images/shop/category-pharmacy.png',
    ),
    CategoryData(
      id: 6,
      title: 'More',
      imagePath: 'assets/images/shop/category-more.png',
    ),
  ];

  int _selectedShopIndex = 0;
  List<ShopData> _shops = [];
  List<ProductData> _recentProducts = [];
  List<ProductData> _recommendProducts = [];

  ShopData get _currentShop => _shops[_selectedShopIndex];

  Future<void> selectShop() async {
    final selectedIndex = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            itemCount: _shops.length,
            separatorBuilder: (_, __) {
              return const Divider(height: 1);
            },
            itemBuilder: (context, index) {
              final shop = _shops[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFF1F8EE),
                  child: ClipOval(
                    child: Image.asset(
                      '',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.pets,
                          color: ShopColors.primary,
                        );
                      },
                    ),
                  ),
                ),
                title: Text(
                  shop.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  shop.address,
                  style: const TextStyle(fontSize: 10),
                ),
                trailing: index == _selectedShopIndex
                    ? const Icon(Icons.check_circle, color: ShopColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(sheetContext, index);
                },
              );
            },
          ),
        );
      },
    );

    if (selectedIndex == null || !mounted) {
      return;
    }

    final shop = _shops[selectedIndex];
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('shop_id', shop.id);

    setState(() {
      _selectedShopIndex = selectedIndex;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToCategoryProducts([String? category]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryProductsPage(category: category),
      ),
    );
  }

  void _goToProductList(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductListPage(title: title)),
    );
  }

  @override
  void initState() {
    super.initState();

    _getShopList();
  }

  Future<void> _getShopList() async {
    try {
      final res = await ShopService.instance.getShopList();
      final list = res.shops.map((item) => ShopData.fromModel(item)).toList();

      final shop = list[0];
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('shop_id', shop.id);

      setState(() {
        _shops = list;
      });

      _getRecentProductList();
      _getRecommendProductList();
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

  Future<void> _getRecentProductList() async {
    try {
      final res = await ShopService.instance.getRecentProductList();
      final list = res.products
          .map((item) => ProductData.fromModel(item))
          .toList();

      setState(() {
        _recentProducts = list;
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

  Future<void> _getRecommendProductList() async {
    try {
      final res = await ShopService.instance.getRecommendProductList(1);
      final list = res.products
          .map((item) => ProductData.fromModel(item))
          .toList();

      setState(() {
        _recommendProducts = list;
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
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.055;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
            28,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShopTopBar(
                shopName: _currentShop.name.split(' - ')[1],
                onShopTap: selectShop,
                controller: _searchController,
                onCartTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage()),
                  );
                },
              ),
              const SizedBox(height: 16),
              ShopPromoBanner(onTap: () => _goToCategoryProducts()),
              const SizedBox(height: 16),
              SectionHeader(
                title: 'Categories',
                actionText: 'See all',
                onActionTap: () => _goToCategoryProducts(),
              ),
              const SizedBox(height: 8),
              ShopCategoryGrid(
                categories: _categories,
                onTap: (item) {
                  if (item.title == "Grooming") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AppointmentPage()),
                    );

                    return;
                  } else {
                    _goToCategoryProducts(item.title);
                  }
                },
              ),
              if (_recentProducts.isNotEmpty) ...[
                const SizedBox(height: 8),
                SectionHeader(
                  title: 'Recently Bought',
                  actionText: 'See all',
                  onActionTap: () => _goToProductList('Recently Bought'),
                ),
                const SizedBox(height: 4),
                ShopProductRow(
                  products: _recentProducts,
                  onTap: (item) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductPage(product: item),
                      ),
                    );
                  },
                ),
              ],

              if (_recommendProducts.isNotEmpty) ...[
                const SizedBox(height: 16),
                SectionHeader(
                  title: 'Recommended for Milo',
                  actionText: 'See all',
                  onActionTap: () => _goToProductList('Recommended for Milo'),
                ),
                const SizedBox(height: 4),
                ShopProductRow(
                  products: _recommendProducts,
                  onTap: (item) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductPage(product: item),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ShopTopBar extends StatelessWidget {
  final String shopName;
  final VoidCallback onShopTap;
  final TextEditingController controller;
  final VoidCallback onCartTap;

  const ShopTopBar({
    super.key,
    required this.shopName,
    required this.onShopTap,
    required this.controller,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onShopTap,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFEFEFEF)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x06000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: ShopColors.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2),
                  Text(
                    shopName,
                    style: TextStyle(
                      color: Color(0xFF404653),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF606670),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEFEFEF)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchPage()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 16,
                        color: Color(0xFF525A63),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Search products...',
                        style: TextStyle(
                          color: Color(0xFF8A9098),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ShopCartButton(onCartTap: onCartTap),
      ],
    );
  }
}

class ShopCartButton extends ConsumerWidget {
  final VoidCallback? onCartTap;

  const ShopCartButton({super.key, this.onCartTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartTotalQuantityProvider);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onCartTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF0F1F0)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Center(
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: ShopColors.primary,
                  size: 24,
                ),
              ),

              if (cartCount > 0)
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF3B30),
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

class ShopPromoBanner extends StatelessWidget {
  final VoidCallback onTap;

  const ShopPromoBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.25,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9EA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE9F2E4)),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF5FBEF), Color(0xFFE8F6DE)],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: MediaQuery.sizeOf(context).width * 0.36,
              child: Image.asset(
                'assets/images/shop/banner-dog.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                errorBuilder: (_, __, ___) {
                  return const Icon(
                    Icons.pets,
                    size: 120,
                    color: Color(0xFFAAD49F),
                  );
                },
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              bottom: 16,
              width: MediaQuery.sizeOf(context).width * 0.48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '20% OFF',
                    style: TextStyle(
                      color: ShopColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Premium Food',
                    style: TextStyle(
                      color: ShopColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'For a healthier pet',
                    style: TextStyle(
                      color: ShopColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ShopColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Shop Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
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

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: ShopColors.textPrimary,
            ),
          ),
        ),

        if (actionText != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: ShopColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionText!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

class ShopCategoryGrid extends StatelessWidget {
  final List<CategoryData> categories;
  final ValueChanged<CategoryData> onTap;

  const ShopCategoryGrid({
    super.key,
    required this.categories,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 4,
        mainAxisSpacing: 0,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = categories[index];

        return InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onTap(item),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF0F1F0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  item.imagePath ?? '',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.pets,
                      color: ShopColors.primary,
                      size: 24,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  color: ShopColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ShopProductRow extends StatelessWidget {
  final List<ProductData> products;
  final ValueChanged<ProductData> onTap;

  const ShopProductRow({
    super.key,
    required this.products,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(products.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == products.length - 1 ? 0 : 10,
            ),
            child: ShopProductCard(
              product: products[index],
              onTap: () => onTap(products[index]),
            ),
          ),
        );
      }),
    );
  }
}

class ShopProductCard extends StatelessWidget {
  final ProductData product;
  final VoidCallback onTap;

  const ShopProductCard({
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
          height: 180,
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F1F0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  product.imagePath,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.shopping_bag_outlined,
                      color: ShopColors.primary,
                      size: 60,
                    );
                  },
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '\$${product.stock.price}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: ShopColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
