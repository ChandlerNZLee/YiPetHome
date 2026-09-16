// lib/page/my/favorites.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shop/product.dart';

import '../../view-models/favorites.dart';
import '../../view-models/product.dart';
import '../../view-models/cart.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE6EAE6);
  static const Color background = Color(0xFFFCFDFB);

  FavoriteCategory _selectedCategory = FavoriteCategory.all;
  FavoriteSort _selectedSort = FavoriteSort.newest;
  FavoriteViewMode _viewMode = FavoriteViewMode.grid;

  bool _editMode = false;

  final Set<int> _selectedIds = {};

  final List<ProductData> _products = [
    ProductData(
      id: 1,
      category: 0,
      type: 0,
      name: 'Royal Canin Golden Retriever Adult',
      description: 'Dry Dog Food',
      imagePath: 'assets/images/products/royal_canin_golden.png',
      stock: ProductStockData(
        id: 1,
        size: '3kg',
        price: 49.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
    ProductData(
      id: 2,
      category: 0,
      type: 0,
      name: 'Ziwi Peak Beef Recipe',
      description: 'Dry Dog Food',
      imagePath: 'assets/images/products/ziwi_peak_beef.png',
      stock: ProductStockData(
        id: 1,
        size: '1kg',
        price: 59.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
    ProductData(
      id: 3,
      category: 0,
      type: 1,
      name: 'Zesty Paws 8-in-1 Bites',
      description: 'Multivitamin Treats',
      imagePath: 'assets/images/products/zesty_paws.png',
      stock: ProductStockData(
        id: 1,
        size: '90ct',
        price: 22.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
    ProductData(
      id: 4,
      category: 0,
      type: 2,
      name: 'KONG Cozie Dog Toy',
      description: 'Plush Toy',
      imagePath: 'assets/images/products/kong_cozie.png',
      stock: ProductStockData(
        id: 1,
        size: 'Medium',
        price: 12.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
    ProductData(
      id: 5,
      category: 0,
      type: 5,
      name: 'Vet\'s Best Dental Water Additive',
      description: 'Dental Care',
      imagePath: 'assets/images/products/vets_best_dental.png',
      stock: ProductStockData(
        id: 1,
        size: '473ml',
        price: 19.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
    ProductData(
      id: 6,
      category: 0,
      type: 5,
      name: 'NexGard Spectra Chew for Dogs',
      description: 'Flea & Tick',
      imagePath: 'assets/images/products/nexgard.png',
      stock: ProductStockData(
        id: 1,
        size: '3 Tablets',
        price: 34.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
    ProductData(
      id: 7,
      category: 0,
      type: 4,
      name: 'TropiClean Berry &\nCoconut Shampoo',
      description: 'Grooming',
      imagePath: 'assets/images/products/tropiclean.png',
      stock: ProductStockData(
        id: 1,
        size: '592ml',
        price: 18.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
    ProductData(
      id: 8,
      category: 0,
      type: 2,
      name: 'Bedsure Orthopedic\nDog Bed',
      description: 'Pet Bed',
      imagePath: 'assets/images/products/bedsure_bed.png',
      stock: ProductStockData(
        id: 1,
        size: 'Medium',
        price: 42.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
    ProductData(
      id: 9,
      category: 0,
      type: 1,
      name: 'Greenies Original\nDental Treats',
      description: 'Dental Treats',
      imagePath: 'assets/images/products/greenies.png',
      stock: ProductStockData(
        id: 1,
        size: 'Regular',
        price: 27.99,
        discount: 1.0,
        stock: 1000,
      ),
    ),
  ];

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _toggleEditMode() {
    setState(() {
      _editMode = !_editMode;

      if (!_editMode) {
        _selectedIds.clear();
      }
    });
  }

  void _goToProduct(ProductData product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductPage(product: product)),
    );
  }

  void _toggleSelection(ProductData product) {
    setState(() {
      if (_selectedIds.contains(product.id)) {
        _selectedIds.remove(product.id);
      } else {
        _selectedIds.add(product.id);
      }
    });
  }

  void _removeFavorite(ProductData product) {
    setState(() {
      _products.removeWhere((item) => item.id == product.id);

      _selectedIds.remove(product.id);
    });
  }

  void _deleteSelected() {
    if (_selectedIds.isEmpty) return;

    setState(() {
      _products.removeWhere((item) => _selectedIds.contains(item.id));

      _selectedIds.clear();
      _editMode = false;
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

  List<ProductData> get _filteredProducts {
    List<ProductData> result;

    if (_selectedCategory == FavoriteCategory.all) {
      result = List.of(_products);
    } else {
      result = _products
          .where((item) => item.category == _selectedCategory)
          .toList();
    }

    switch (_selectedSort) {
      case FavoriteSort.newest:
        result.sort((a, b) => b.id.compareTo(a.id));
        break;
      case FavoriteSort.oldest:
        result.sort((a, b) => a.id.compareTo(b.id));
        break;
      case FavoriteSort.priceLow:
        result.sort((a, b) => a.stock.price.compareTo(b.stock.price));
        break;
      case FavoriteSort.priceHigh:
        result.sort((a, b) => b.stock.price.compareTo(a.stock.price));
        break;
    }

    return result;
  }

  int _categoryCount(FavoriteCategory category) {
    if (category == FavoriteCategory.all) {
      return _products.length;
    }

    return _products.where((item) => item.category == category).length;
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
            _buildCategoryFilters(),
            const SizedBox(height: 12),
            _buildToolbar(),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : _viewMode == FavoriteViewMode.grid
                  ? _buildGrid()
                  : _buildList(),
            ),

            if (_editMode) _buildEditBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: SizedBox(
        height: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: _goBack,
                borderRadius: BorderRadius.circular(24),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24,
                    color: textPrimary,
                  ),
                ),
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your saved items',
                  style: TextStyle(fontSize: 10, color: textSecondary),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _toggleEditMode,
                style: TextButton.styleFrom(foregroundColor: primary),
                child: Text(
                  _editMode ? 'Done' : 'Edit',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: FavoriteCategory.values.map((category) {
          final selected = _selectedCategory == category;
          final count = _categoryCount(category);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFF0F8EE)
                      : const Color(0xFFF7F8FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFFBFDDBF)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  '${category.label} ($count)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? primary : textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          PopupMenuButton<FavoriteSort>(
            initialValue: _selectedSort,
            onSelected: (value) {
              setState(() {
                _selectedSort = value;
              });
            },
            offset: const Offset(0, 46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            itemBuilder: (_) {
              return FavoriteSort.values
                  .map(
                    (sort) =>
                        PopupMenuItem(value: sort, child: Text(sort.label)),
                  )
                  .toList();
            },
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedSort.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: textSecondary,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          _ViewModeButton(
            icon: Icons.grid_view_rounded,
            selected: _viewMode == FavoriteViewMode.grid,
            onTap: () {
              setState(() {
                _viewMode = FavoriteViewMode.grid;
              });
            },
          ),
          const SizedBox(width: 10),
          _ViewModeButton(
            icon: Icons.view_list_rounded,
            selected: _viewMode == FavoriteViewMode.list,
            onTap: () {
              setState(() {
                _viewMode = FavoriteViewMode.list;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        12,
        0,
        12,
        MediaQuery.paddingOf(context).bottom + 26,
      ),
      itemCount: _filteredProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.49,
      ),
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];

        return FavoriteGridCard(
          data: product,
          editMode: _editMode,
          selected: _selectedIds.contains(product.id),
          onTap: () {
            if (_editMode) {
              _toggleSelection(product);
            } else {
              _goToProduct(product);
            }
          },
          onFavoriteTap: () {
            _removeFavorite(product);
          },
          onCartTap: () {
            _addToCart(product);
          },
        );
      },
    );
  }

  Widget _buildList() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        12,
        0,
        12,
        MediaQuery.paddingOf(context).bottom + 26,
      ),
      itemCount: _filteredProducts.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];

        return FavoriteListCard(
          data: product,
          editMode: _editMode,
          selected: _selectedIds.contains(product.id),
          onTap: () {
            if (_editMode) {
              _toggleSelection(product);
            }
          },
          onFavoriteTap: () {
            _removeFavorite(product);
          },
          onCartTap: () {
            _addToCart(product);
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 48,
            color: Color(0xFFADB4C0),
          ),
          SizedBox(height: 12),
          Text(
            'No favorites yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Save products you love and they will appear here.',
            style: TextStyle(fontSize: 10, color: textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEditBottomBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: border)),
        ),
        child: Row(
          children: [
            Text(
              '${_selectedIds.length} selected',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _selectedIds.isEmpty ? null : _deleteSelected,
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text('Remove'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF04444),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE5E6E8),
                disabledForegroundColor: const Color(0xFF9CA3AF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteGridCard extends StatelessWidget {
  final ProductData data;

  final bool editMode;
  final bool selected;

  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCartTap;

  const FavoriteGridCard({
    super.key,
    required this.data,
    required this.editMode,
    required this.selected,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onCartTap,
  });

  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE6EAE6);

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
            border: Border.all(
              color: selected ? primary : border,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 11,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                        child: Image.asset(
                          data.imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              alignment: Alignment.center,
                              color: const Color(0xFFF7F9F6),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                size: 36,
                                color: Color(0xFFB0B7B0),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: editMode
                          ? _SelectionCircle(selected: selected)
                          : GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onFavoriteTap,
                              child: const _FavoriteButton(),
                            ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              data.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 8,
                                color: textSecondary,
                              ),
                            ),
                          ),
                          const Text(
                            ' • ',
                            style: TextStyle(fontSize: 8, color: textSecondary),
                          ),
                          Text(
                            data.stock.size,
                            style: const TextStyle(
                              fontSize: 8,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '\$${data.stock.price}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: primary,
                              ),
                            ),
                          ),

                          if (!editMode)
                            GestureDetector(
                              onTap: onCartTap,
                              child: Container(
                                width: 28,
                                height: 28,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 16,
                                  color: Colors.white,
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

class FavoriteListCard extends StatelessWidget {
  final ProductData data;

  final bool editMode;
  final bool selected;

  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCartTap;

  const FavoriteListCard({
    super.key,
    required this.data,
    required this.editMode,
    required this.selected,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 138,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF15952A)
                  : const Color(0xFFE6EAE6),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 108,
                child: Image.asset(
                  data.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.inventory_2_outlined,
                      size: 44,
                      color: Color(0xFFADB4C0),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${data.type} • ${data.stock.size}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF667087),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${data.stock.price}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF15952A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  editMode
                      ? _SelectionCircle(selected: selected)
                      : GestureDetector(
                          onTap: onFavoriteTap,
                          child: const _FavoriteButton(),
                        ),

                  if (!editMode)
                    GestureDetector(
                      onTap: onCartTap,
                      child: Container(
                        width: 24,
                        height: 24,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0xFF15952A),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shopping_cart_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x10000000), blurRadius: 5)],
      ),
      child: const Icon(
        Icons.favorite_rounded,
        size: 16,
        color: Color(0xFFF41F32),
      ),
    );
  }
}

class _SelectionCircle extends StatelessWidget {
  final bool selected;

  const _SelectionCircle({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF15952A) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFF15952A) : const Color(0xFFD5DAE0),
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
          : null,
    );
  }
}

class _ViewModeButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ViewModeButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0F8EE) : const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: const Color(0xFFC9E2C9)) : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected ? const Color(0xFF15952A) : const Color(0xFF667087),
        ),
      ),
    );
  }
}

class FavoriteRating extends StatelessWidget {
  final double rating;
  final int reviews;

  const FavoriteRating({
    super.key,
    required this.rating,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          final remain = rating - index;

          final IconData icon;

          if (remain >= 1) {
            icon = Icons.star_rounded;
          } else if (remain >= 0.5) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_border_rounded;
          }

          return Icon(icon, size: 13, color: const Color(0xFFFFB000));
        }),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            '($reviews)',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 9.5, color: Color(0xFF667087)),
          ),
        ),
      ],
    );
  }
}
