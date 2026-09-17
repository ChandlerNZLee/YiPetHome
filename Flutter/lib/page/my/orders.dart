// lib/page/my/orders.dart
import 'package:flutter/material.dart';

import '../../services/shop-service.dart';
import '../../core/network/api-exception.dart';

import '../shop/cart.dart';

import '../../view-models/orders.dart';

// paymentStatus
// 0 = Pending
// 1 = Succeeded
// 2 = Failed
// 3 = Canceled
// 4 = Refunded

// orderStatus
// 0 = Pending
// 1 = Processing
// 2 = Completed
// 3 = Cancelled

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  static const Color background = Color(0xFFFCFDFB);
  static const Color textPrimary = Color(0xFF17191D);

  final TextEditingController _searchController = TextEditingController();

  int _selectedStatus = 0;

  final List<String> _statusTabs = const [
    'All Orders',
    'Pending',
    'Processing',
    'Completed',
    'Cancelled',
  ];

  List<ShopOrderData> _orders = [];

  List<ShopOrderData> get _filteredOrders {
    Iterable<ShopOrderData> result = _orders;

    if (_selectedStatus != 0) {
      final selected = _statusTabs[_selectedStatus];

      result = result.where((order) {
        switch (selected) {
          case 'Pending':
            return order.paymentStatus == 0;
          case 'Processing':
            return order.orderStatus == 1;
          case 'Completed':
            return order.orderStatus == 2;
          case 'Cancelled':
            return order.orderStatus == 3;
          default:
            return true;
        }
      });
    }

    final keyword = _searchController.text.trim().toLowerCase();

    if (keyword.isNotEmpty) {
      result = result.where((order) {
        return order.trackingNumber.toLowerCase().contains(keyword);
      });
    }

    return result.toList();
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

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartPage()),
    );
  }

  void _openOrder(ShopOrderData order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Open order ${order.trackingNumber}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _viewDetails(ShopOrderData order) {
    _openOrder(order);
  }

  void _payNow(ShopOrderData order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pay ${order.trackingNumber}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openFilter() {
    showModalBottomSheet<void>(
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
                  'Filter Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                ListTile(
                  title: const Text('Newest first'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  title: const Text('Oldest first'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  title: const Text('Highest amount'),
                  trailing: const Icon(Icons.chevron_right_rounded),
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
  void initState() {
    super.initState();

    _getOrderList();
  }

  Future<void> _getOrderList() async {
    try {
      final res = await ShopService.instance.getShopOrderList();
      final list = res.orders
          .map((item) => ShopOrderData.fromModel(item))
          .toList();

      setState(() {
        _orders = list;
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
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final horizontalPadding = width * 0.04;
    final orders = _filteredOrders;

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
              child: OrdersHeader(onBackTap: _goBack, onCartTap: _openCart),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: OrderStatusTabs(
                items: _statusTabs,
                selectedIndex: _selectedStatus,
                onChanged: (index) {
                  setState(() {
                    _selectedStatus = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Row(
                children: [
                  Expanded(
                    child: OrdersSearchBar(
                      controller: _searchController,
                      onChanged: (_) {
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  OrderFilterButton(onTap: _openFilter),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: orders.isEmpty
                  ? const EmptyOrdersView()
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        0,
                        horizontalPadding,
                        12,
                      ),
                      itemCount: orders.length,
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 12);
                      },
                      itemBuilder: (context, index) {
                        final order = orders[index];

                        return OrderCard(
                          order: order,
                          onTap: () => _openOrder(order),
                          onViewDetails: () => _viewDetails(order),
                          onPayNow: () => _payNow(order),
                        );
                      },
                    ),
            ),
            const OrderProtectionNotice(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class OrdersHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onCartTap;

  const OrdersHeader({
    super.key,
    required this.onBackTap,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                color: OrdersColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                'Orders',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: OrdersColors.textPrimary,
                ),
              ),
              Text(
                'View and track your shop orders',
                style: TextStyle(
                  fontSize: 12,
                  color: OrdersColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onCartTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 24,
                      color: OrdersColors.textPrimary,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
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
        ),
      ],
    );
  }
}

class OrderStatusTabs extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const OrderStatusTabs({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OrdersColors.border),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          final selected = index == selectedIndex;

          return Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onChanged(index),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFF0F8ED)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      items[index],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? OrdersColors.primary
                            : OrdersColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class OrdersSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const OrdersSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: OrdersColors.border),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: OrdersColors.primary,
        style: const TextStyle(fontSize: 12, color: OrdersColors.textPrimary),
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search_rounded,
            size: 24,
            color: OrdersColors.textSecondary,
          ),
          hintText: 'Search orders',
          hintStyle: TextStyle(fontSize: 12, color: Color(0xFF999EA5)),
          contentPadding: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}

class OrderFilterButton extends StatelessWidget {
  final VoidCallback onTap;

  const OrderFilterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFB9DFB5)),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.filter_alt_outlined,
                size: 20,
                color: OrdersColors.primary,
              ),
              SizedBox(width: 4),
              Text(
                'Filter',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: OrdersColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final ShopOrderData order;

  final VoidCallback onTap;
  final VoidCallback onViewDetails;
  final VoidCallback onPayNow;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onViewDetails,
    required this.onPayNow,
  });

  @override
  Widget build(BuildContext context) {
    final toPay = order.paymentStatus == 0;
    final images = order.products.map((product) => product.image).toList();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: OrdersColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x06000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OrderProductImages(imagePaths: images),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${order.trackingNumber}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: OrdersColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.time,
                          style: const TextStyle(
                            fontSize: 10,
                            color: OrdersColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${order.products.length} '
                          '${order.products.length == 1 ? 'item' : 'items'}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: OrdersColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$${order.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: OrdersColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OrderStatusBadge(
                        status: order.paymentStatus == 0
                            ? 0
                            : order.orderStatus,
                      ),
                      const SizedBox(height: 12),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 24,
                        color: OrdersColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),

              if (toPay) ...[
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: onViewDetails,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: OrdersColors.primary,
                        side: const BorderSide(color: Color(0xFFB9DFB5)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: onPayNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: OrdersColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Pay Now',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class OrderProductImages extends StatelessWidget {
  final List<String> imagePaths;

  const OrderProductImages({super.key, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F2EF)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (imagePaths.isNotEmpty)
            Positioned(
              left: 4,
              child: SizedBox(
                width: imagePaths.length > 1 ? 36 : 76,
                child: Image.network(
                  imagePaths[0],
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
                      size: 36,
                      color: Color(0xFFB9CDB6),
                    );
                  },
                ),
              ),
            ),

          if (imagePaths.length > 1)
            Positioned(
              right: 4,
              child: SizedBox(
                width: 36,
                height: 36,
                child: Image.network(
                  imagePaths[1],
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.pets_outlined,
                      size: 36,
                      color: Color(0xFFB9CDB6),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OrderStatusBadge extends StatelessWidget {
  final int status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final style = _statusStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        style.text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: style.foreground,
        ),
      ),
    );
  }

  OrderStatusStyle _statusStyle(int status) {
    switch (status) {
      case 0:
        return const OrderStatusStyle(
          text: 'Pending',
          foreground: Color(0xFFE59A14),
          background: Color(0xFFFFF5DD),
        );
      case 1:
        return const OrderStatusStyle(
          text: 'Processing',
          foreground: Color(0xFFF18B1B),
          background: Color(0xFFFFF1E2),
        );
      case 2:
        return const OrderStatusStyle(
          text: 'Completed',
          foreground: Color(0xFF22A447),
          background: Color(0xFFEDF8EA),
        );
      case 3:
        return const OrderStatusStyle(
          text: 'Cancelled',
          foreground: Color(0xFF777B84),
          background: Color(0xFFF1F2F3),
        );
      default:
        return const OrderStatusStyle(
          text: 'Pending',
          foreground: Color(0xFFE59A14),
          background: Color(0xFFFFF5DD),
        );
    }
  }
}

class OrderProtectionNotice extends StatelessWidget {
  const OrderProtectionNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user_rounded,
            size: 15,
            color: OrdersColors.primary,
          ),
          SizedBox(width: 7),
          Text(
            'All orders are protected. Shop with confidence!',
            style: TextStyle(fontSize: 10.5, color: OrdersColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class EmptyOrdersView extends StatelessWidget {
  const EmptyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Color(0xFFB8BDB9)),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: OrdersColors.textPrimary,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Your orders will appear here.',
            style: TextStyle(fontSize: 13, color: OrdersColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
