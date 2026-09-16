// lib/page/my/addresses.dart
import 'package:flutter/material.dart';

import '../../services/user-service.dart';
import '../../core/network/api-exception.dart';

import '../../component/address/address.dart';

import '../../models/user/address-model.dart';

import '../../view-models/address.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  static const Color textPrimary = Color(0xFF17191D);
  static const Color textSecondary = Color(0xFF52617D);
  static const Color background = Color(0xFFFCFDFB);

  List<AddressData> _addresses = [];

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _setDefault(int id) {
    setState(() {
      for (int i = 0; i < _addresses.length; i++) {
        final item = _addresses[i];

        _addresses[i] = item.copyWith(isDefault: item.id == id ? 1 : 0);
      }
    });
  }

  Future<void> _deleteAddress(AddressData address) async {
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

  Future<void> _addAddress() async {
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

  Future<void> _editAddress(AddressData address) async {
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

    _updateAddressData(address);
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
        _addresses = list;
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
    final horizontalPadding = width * 0.035;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                0,
              ),
              child: AddressesHeader(onBackTap: _goBack, onAddTap: _addAddress),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  MediaQuery.paddingOf(context).bottom + 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'My Addresses',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Manage your delivery and billing addresses',
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(_addresses.length, (index) {
                      final item = _addresses[index];

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == _addresses.length - 1 ? 0 : 12,
                        ),
                        child: AddressCard(
                          data: item,
                          onEdit: () => _editAddress(item),
                          onDelete: () => _deleteAddress(item),
                          onSetDefault: () {
                            _setDefault(item.id);
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    const AddressSecurityCard(),
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

class AddressesHeader extends StatelessWidget {
  final VoidCallback onBackTap;
  final VoidCallback onAddTap;

  const AddressesHeader({
    super.key,
    required this.onBackTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Addresses',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172038),
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
                    color: Color(0xFF111820),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onAddTap,
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 24,
                        color: Color(0xFF16A52F),
                      ),
                      SizedBox(width: 2),
                      Text(
                        'Add New',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A52F),
                        ),
                      ),
                    ],
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

class AddressCard extends StatelessWidget {
  final AddressData data;

  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({
    super.key,
    required this.data,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = data.isDefault;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDefault == 1 ? const Color(0xFFF8FCF7) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDefault == 1
              ? const Color(0xFFBFE3BD)
              : const Color(0xFFE6EAE6),
          width: isDefault == 1 ? 1.4 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDefault == 1) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F7E7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Default',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF16A52F),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                child: Icon(
                  Icons.location_on_rounded,
                  size: 36,
                  color: isDefault == 1
                      ? const Color(0xFF16A52F)
                      : const Color(0xFFA9ADB6),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.postcode,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF172038),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.contact,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF52617D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.mobile,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF52617D),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              _AddressAction(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onTap: onEdit,
              ),
              const SizedBox(width: 12),
              _AddressAction(
                icon: Icons.delete_outline_rounded,
                label: 'Delete',
                onTap: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: Color(0xFFE8ECE8)),
                const SizedBox(height: 12),
                Text(
                  data.details,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF52617D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.details,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: Color(0xFF52617D),
                  ),
                ),
                const SizedBox(height: 16),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isDefault == 1 ? null : onSetDefault,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 16,
                            height: 16,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isDefault == 1
                                  ? const Color(0xFF16A52F)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDefault == 1
                                    ? const Color(0xFF16A52F)
                                    : const Color(0xFFB9C0CA),
                                width: 1.4,
                              ),
                            ),
                            child: isDefault == 1
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isDefault == 1
                                ? 'Default shipping address'
                                : 'Set as default shipping address',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isDefault == 1
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isDefault == 1
                                  ? const Color(0xFF16A52F)
                                  : const Color(0xFF8B94A7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AddressAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF16A52F)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF16A52F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressSecurityCard extends StatelessWidget {
  const AddressSecurityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDECDD)),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_outlined, size: 24, color: Color(0xFF16A52F)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your information is secure',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172038),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'We use encryption to keep your address information safe.',
                  style: TextStyle(fontSize: 10, color: Color(0xFF52617D)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
