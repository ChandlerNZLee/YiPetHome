// lib/page/shop/product.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/shop-service.dart';
import '../../core/network/api-exception.dart';

import '../../view-models/product.dart';
import '../../view-models/cart.dart';

class ProductPage extends ConsumerStatefulWidget {
  final ProductData product;

  const ProductPage({super.key, required this.product});

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  static const Color primary = Color(0xFF22C55E);
  static const Color textPrimary = Color(0xFF17191D);
  static const Color textSecondary = Color(0xFF777B84);
  static const Color border = Color(0xFFECEFEC);
  static const Color background = Color(0xFFFCFDFB);

  ProductData? _product;
  late ProductStockData _stock;

  bool _isFavorite = false;
  double _price = 0.0;
  String _selectedSize = '';
  List<String> _sizes = [];

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  Future<void> _selectSize() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Size',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ..._sizes.map(
                  (size) => ListTile(
                    title: Text(
                      size,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: size == _selectedSize
                        ? const Icon(Icons.check_circle, color: primary)
                        : null,
                    onTap: () {
                      Navigator.pop(sheetContext, size);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null || !mounted) return;

    final index = _sizes.indexWhere((item) => item == selected);

    setState(() {
      _price = _product!.stocks[index].price;
      _stock = _product!.stocks[index];
      _selectedSize = selected;
    });
  }

  void _addToCart() {
    if (_product == null) {
      return;
    }

    ref
        .read(cartProvider.notifier)
        .addToCart(product: _product!, stock: _stock);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_product?.name} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _getProductData() async {
    try {
      final res = await ShopService.instance.getProduct(widget.product.id);
      final data = ProductData.fromModel(res.product);

      setState(() {
        _product = data;
        _price = data.stock.price;
        _stock = data.stock;
        _selectedSize = data.stock.size;
        _sizes = data.stocks.map((item) => item.size).toList();
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

    _getProductData();
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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  12,
                  horizontalPadding,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductTopBar(
                      isFavorite: _isFavorite,
                      onBackTap: _goBack,
                      onFavoriteTap: _toggleFavorite,
                    ),
                    const SizedBox(height: 16),
                    ProductHeroImage(images: _product?.images ?? []),
                    const SizedBox(height: 16),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _product?.stock.size ?? '',
                      style: TextStyle(fontSize: 16, color: textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$$_price',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ProductSizeSelector(
                      value: _selectedSize,
                      onTap: _selectSize,
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: border),
                    const SizedBox(height: 16),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _product?.description ?? '0.00',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.65,
                        color: textPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
            ProductBottomBar(onAddToCart: _addToCart),
          ],
        ),
      ),
    );
  }
}

class ProductTopBar extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onBackTap;
  final VoidCallback onFavoriteTap;

  const ProductTopBar({
    super.key,
    required this.isFavorite,
    required this.onBackTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onBackTap,
              child: const SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 27,
                  color: _ProductColors.textPrimary,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onFavoriteTap,
              child: SizedBox(
                width: 48,
                height: 48,
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  size: 32,
                  color: _ProductColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductHeroImage extends StatefulWidget {
  final List<ProductImageData> images;

  const ProductHeroImage({super.key, required this.images});

  @override
  State<ProductHeroImage> createState() => _ProductHeroImageState();
}

class _ProductHeroImageState extends State<ProductHeroImage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (widget.images.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: width * 0.75,
        child: const Center(
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 150,
            color: Color(0xFFB9CDB6),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: width * 0.75,
          child: PageView.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final image = widget.images[index];

              return Center(
                child: Image.network(
                  image.url,
                  width: width * 0.64,
                  height: width * 0.70,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.shopping_bag_outlined,
                      size: 150,
                      color: Color(0xFFB9CDB6),
                    );
                  },
                ),
              );
            },
          ),
        ),

        if (widget.images.length > 1) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              final selected = index == _currentIndex;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: selected ? 18 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF20C563)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

class ProductSizeSelector extends StatelessWidget {
  final String value;
  final VoidCallback onTap;

  const ProductSizeSelector({
    super.key,
    required this.value,
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
          width: 240,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E7E5)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: _ProductColors.textPrimary,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 24,
                color: Color(0xFF8C9096),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductBottomBar extends StatelessWidget {
  final VoidCallback onAddToCart;

  const ProductBottomBar({super.key, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(22, 12, 22, bottomSafeArea + 12),
      decoration: const BoxDecoration(color: Color(0xFFFCFDFB)),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onAddToCart,
          child: Ink(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF22C55E), Color(0xFF20B84F)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2422C55E),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Add to Cart',
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

class _ProductColors {
  static const primary = Color(0xFF22C55E);
  static const textPrimary = Color(0xFF17191D);
}
