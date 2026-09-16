// lib/page/shop/select-address.dart
import 'package:flutter/material.dart';

import '../../services/user-service.dart';
import '../../core/network/api-exception.dart';

import '../../component/address/address.dart';

import 'payment.dart';

import '../../models/user/address-model.dart';

import '../../view-models/address.dart';
import '../../view-models/payment.dart';

class SelectAddressPage extends StatefulWidget {
  final double amount;

  const SelectAddressPage({super.key, required this.amount});

  @override
  State<SelectAddressPage> createState() => _SelectAddressPageState();
}

class _SelectAddressPageState extends State<SelectAddressPage> {
  int selectedAddressIndex = 0;
  List<AddressData> addresses = [];

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();

    _getAddressList();
  }

  Future<void> _getAddressList() async {
    try {
      final res = await UserService.instance.getAddressList();
      final list = res.addresses
          .map((item) => AddressData.fromModel(item))
          .toList();

      setState(() {
        addresses = list;
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
    final horizontalPadding = width * 0.055;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectAddressNavigationBar(
                onBackTap: _goBack,
                onAddAddress: _addNewAddress,
              ),
              const SizedBox(height: 12),
              if (addresses.isNotEmpty) ...[
                _buildSectionTitle('Current Address'),
                const SizedBox(height: 8),
                _buildAddressCard(
                  address: addresses[0],
                  index: 0,
                  showDelete: false,
                  highlighted: true,
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Saved Addresses'),
                const SizedBox(height: 8),
                for (int i = 1; i < addresses.length; i++) ...[
                  _buildAddressCard(
                    address: addresses[i],
                    index: i,
                    showDelete: true,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
              _buildAddNewAddressButton(),
              const SizedBox(height: 16),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF07103D),
      ),
    );
  }

  Widget _buildAddressCard({
    required AddressData address,
    required int index,
    required bool showDelete,
    bool highlighted = false,
  }) {
    final bool selected = selectedAddressIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAddressIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFFFAFFFB) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF12B94D) : const Color(0xFFE7E9F0),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRadio(selected),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${address.contact} (${address.postcode})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF07103D),
                          ),
                        ),
                      ),

                      if (address.isDefault == 1)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9F9EC),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Text(
                            'Default',
                            style: TextStyle(
                              color: Color(0xFF16A63B),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.mobile,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.2,
                      color: Color(0xFF596185),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    address.details,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: Color(0xFF596185),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${address.city}, ${address.province}',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.3,
                      color: Color(0xFF596185),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildActionButton(
                        icon: Icons.edit_outlined,
                        text: 'Edit',
                        color: const Color(0xFF00AD3B),
                        onTap: () => _editAddress(index),
                      ),

                      if (showDelete) ...[
                        const SizedBox(width: 20),
                        _buildActionButton(
                          icon: Icons.delete_outline_rounded,
                          text: 'Delete',
                          color: const Color(0xFFFF3737),
                          onTap: () => _deleteAddress(index),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(bool selected) {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: selected ? 2 : 1.5,
          color: selected ? const Color(0xFF00AD3B) : const Color(0xFFD2D6E2),
        ),
      ),
      alignment: Alignment.center,
      child: selected
          ? Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00AD3B),
              ),
            )
          : null,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewAddressButton() {
    return InkWell(
      onTap: _addNewAddress,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE7E9F0)),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              color: Color(0xFF00AD3B),
              size: 24,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                'Add New Address',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF07103D),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF404766),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _useSelectedAddress,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF00AD3B),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Use This Address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Future<void> _addNewAddress() async {
    final address = await showModalBottomSheet<AddressData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return const AddressEditorSheet();
      },
    );

    if (!mounted || address == null) return;

    _createNewAddressData(address);
  }

  Future<void> _createNewAddressData(AddressData address) async {
    try {
      final res = await UserService.instance.addAddress(
        AddressModel.fromData(address),
      );

      if (res.success) {
        _getAddressList();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.message)));
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

  Future<void> _editAddress(int index) async {
    final address = addresses[index];

    final result = await showModalBottomSheet<AddressData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return AddressEditorSheet(initialData: address);
      },
    );

    if (!mounted || result == null) return;

    _updateAddressData(result);
  }

  Future<void> _updateAddressData(AddressData address) async {
    try {
      final res = await UserService.instance.editAddress(
        AddressModel.fromData(address),
      );

      if (res.success) {
        _getAddressList();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.message)));
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

  Future<void> _deleteAddress(int index) async {
    final address = addresses[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Address',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            'Are you sure you want to delete "${address.postcode}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteAddressData(address.id);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;
  }

  Future<void> _deleteAddressData(int addressId) async {
    try {
      final res = await UserService.instance.deleteAddress(addressId);

      if (res.success) {
        _getAddressList();
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.message)));
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

  void _useSelectedAddress() {
    final selectedAddress = addresses[selectedAddressIndex];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          type: PaymentSummaryType.shopping,
          address: selectedAddress,
          amount: widget.amount,
        ),
      ),
    );
  }
}

class SelectAddressNavigationBar extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onAddAddress;

  const SelectAddressNavigationBar({
    super.key,
    required this.onBackTap,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: onBackTap,
              borderRadius: BorderRadius.circular(24),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 24,
                  color: Color(0xFF172038),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172038),
                ),
              ),
              Text(
                'Choose a delivery address',
                style: const TextStyle(fontSize: 12, color: Color(0xFF667087)),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onAddAddress,
              borderRadius: BorderRadius.circular(24),
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(
                  Icons.add_circle_outline,
                  size: 24,
                  color: Color(0xFF00AD3B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
