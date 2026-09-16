// lib/component/address/address.dart
import 'package:flutter/material.dart';

import '../../models/user/address-model.dart';

import '../../view-models/address.dart';

class AddressEditorSheet extends StatefulWidget {
  final AddressData? initialData;

  const AddressEditorSheet({super.key, this.initialData});

  @override
  State<AddressEditorSheet> createState() => _AddressEditorSheetState();
}

class _AddressEditorSheetState extends State<AddressEditorSheet> {
  late final TextEditingController _postcodeController;
  late final TextEditingController _contactController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _provinceController;
  late final TextEditingController _cityController;
  late final TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();

    final data = widget.initialData;
    _postcodeController = TextEditingController(text: data?.postcode ?? '');
    _contactController = TextEditingController(text: data?.contact ?? '');
    _phoneController = TextEditingController(text: data?.mobile ?? '');
    _emailController = TextEditingController(text: data?.email ?? '');
    _provinceController = TextEditingController(text: data?.province ?? '');
    _cityController = TextEditingController(text: data?.city ?? '');
    _detailsController = TextEditingController(text: data?.details ?? '');
  }

  @override
  void dispose() {
    _postcodeController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _provinceController.dispose();
    _cityController.dispose();
    _detailsController.dispose();

    super.dispose();
  }

  void _save() {
    final postcode = _postcodeController.text.trim();
    final contact = _contactController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final province = _provinceController.text.trim();
    final city = _cityController.text.trim();
    final details = _detailsController.text.trim();

    if (postcode.isEmpty ||
        contact.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        province.isEmpty ||
        city.isEmpty ||
        details.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );

      return;
    }

    final address = AddressModel(
      id: widget.initialData == null ? 0 : (widget.initialData?.id ?? 0),
      postcode: postcode,
      contact: contact,
      mobile: phone,
      email: email,
      province: province,
      city: city,
      details: details,
      longitude: widget.initialData == null
          ? ''
          : (widget.initialData?.longitude ?? ''),
      latitude: widget.initialData == null
          ? ''
          : (widget.initialData?.latitude ?? ''),
      isDefault: 0,
    );

    Navigator.pop(context, AddressData.fromModel(address));
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, keyboard + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.initialData == null ? 'Add Address' : 'Edit Address',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            _AddressTextField(
              controller: _postcodeController,
              label: 'Postcode',
              hint: 'Postcode',
            ),
            const SizedBox(height: 12),
            _AddressTextField(
              controller: _contactController,
              label: 'Contact',
              hint: 'Contact',
            ),
            const SizedBox(height: 12),
            _AddressTextField(
              controller: _phoneController,
              label: 'Mobile',
              hint: 'Mobile',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _AddressTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _AddressTextField(
              controller: _provinceController,
              label: 'Province',
              hint: 'Province',
            ),
            const SizedBox(height: 12),
            _AddressTextField(
              controller: _cityController,
              label: 'City',
              hint: 'City',
            ),
            const SizedBox(height: 12),
            _AddressTextField(
              controller: _detailsController,
              label: 'Details',
              hint: 'Details',
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A52F),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: Text(
                  widget.initialData == null ? 'Add Address' : 'Save Changes',
                  style: const TextStyle(
                    fontSize: 16,
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
}

class _AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;

  const _AddressTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      cursorColor: const Color(0xFF16A52F),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFFAFBFA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE1E6E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE1E6E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF16A52F), width: 1.4),
        ),
      ),
    );
  }
}
