// lib/page/shop/cart.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'select-address.dart';

import '../../view-models/cart.dart';
import '../../view-models/payment.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  static const Color divider = Color(0xFFECEEEB);
  static const Color background = Color(0xFFFCFDFB);

  bool _editing = false;

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _toggleEdit() {
    setState(() {
      _editing = !_editing;
    });
  }

  void _checkout() {
    final items = ref.read(cartProvider);
    final subtotal = ref.read(cartSubtotalProvider);
    if (items.isEmpty) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SelectAddressPage(amount: subtotal)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final totalQuantity = ref.watch(cartTotalQuantityProvider);

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
              child: CartTopBar(onBackTap: _goBack),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: items.isEmpty
                  ? const EmptyCartView()
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        media.padding.bottom + 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CartTitleRow(
                            itemCount: totalQuantity,
                            editing: _editing,
                            onEditTap: _toggleEdit,
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(items.length, (index) {
                            final item = items[index];

                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == items.length - 1 ? 0 : 22,
                              ),
                              child: CartItemTile(
                                item: items[index],
                                editing: _editing,
                                onIncrease: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .increaseQuantity(item);
                                },
                                onDecrease: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .decreaseQuantity(item);
                                },
                                onDelete: () {
                                  final name = item.product.name;

                                  ref
                                      .read(cartProvider.notifier)
                                      .removeItem(item);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$name removed'),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: 32),
                          const Divider(height: 1, color: divider),
                          const SizedBox(height: 16),
                          CartSummary(subtotal: subtotal),
                          const SizedBox(height: 16),
                          CheckoutButton(
                            enabled: items.isNotEmpty,
                            onTap: _checkout,
                          ),
                          const SizedBox(height: 12),
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

class CartTopBar extends StatelessWidget {
  final VoidCallback onBackTap;

  const CartTopBar({super.key, required this.onBackTap});

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
                width: 44,
                height: 44,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 24,
                  color: CartColors.textPrimary,
                ),
              ),
            ),
          ),
          const Icon(
            Icons.shopping_bag_outlined,
            size: 24,
            color: CartColors.primary,
          ),
        ],
      ),
    );
  }
}

class CartTitleRow extends StatelessWidget {
  final int itemCount;
  final bool editing;
  final VoidCallback onEditTap;

  const CartTitleRow({
    super.key,
    required this.itemCount,
    required this.editing,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CartColors.textPrimary,
            ),
          ),
        ),
        TextButton(
          onPressed: onEditTap,
          style: TextButton.styleFrom(
            foregroundColor: CartColors.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            editing ? 'Done' : 'Edit',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final bool editing;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const CartItemTile({
    super.key,
    required this.item,
    required this.editing,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 166,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 160,
            child: Image.network(
              item.product.imagePath,
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
                  size: 80,
                  color: Color(0xFFB9CDB6),
                );
              },
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: CartColors.textPrimary,
                        ),
                      ),
                    ),
                    if (editing)
                      IconButton(
                        onPressed: onDelete,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFFF4D5E),
                          size: 24,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item.stock.size,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.65,
                    color: CartColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '\$${item.unitPrice}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: CartColors.textPrimary,
                        ),
                      ),
                    ),
                    QuantitySelector(
                      quantity: item.quantity,
                      onDecrease: onDecrease,
                      onIncrease: onIncrease,
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

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7E6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuantityButton(icon: Icons.remove_rounded, onTap: onDecrease),
          Container(
            width: 44,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFFE5E7E6)),
                right: BorderSide(color: Color(0xFFE5E7E6)),
              ),
            ),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CartColors.textPrimary,
              ),
            ),
          ),
          QuantityButton(icon: Icons.add_rounded, onTap: onIncrease),
        ],
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const QuantityButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 24, color: CartColors.textPrimary),
        ),
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  final double subtotal;

  const CartSummary({super.key, required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Subtotal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: CartColors.textSecondary,
            ),
          ),
        ),
        Text(
          '\$${subtotal.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: CartColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class CheckoutButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const CheckoutButton({super.key, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: enabled ? onTap : null,
          child: Ink(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF22C55E), Color(0xFF1DB447)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2522C55E),
                  blurRadius: 14,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Checkout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined, size: 80, color: Color(0xFFB9BEBB)),
          SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CartColors.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add something your pet will love.',
            style: TextStyle(fontSize: 14, color: CartColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
