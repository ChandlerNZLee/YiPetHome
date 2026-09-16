// lib/page/pet/add-pet.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../../view-models/pet.dart';

class AddPetPage extends StatefulWidget {
  const AddPetPage({super.key, this.onSaved});

  final ValueChanged<AddPetFormData>? onSaved;

  @override
  State<AddPetPage> createState() => _AddPetPageState();
}

class _AddPetPageState extends State<AddPetPage> {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE4E8EC);
  static const Color background = Color(0xFFFCFDFB);

  final ImagePicker _imagePicker = ImagePicker();

  File? _petImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  PetType _selectedPetType = PetType.dog;
  PetGender _selectedGender = PetGender.male;

  String? _selectedBreed;
  DateTime? _selectedDate;

  bool _saving = false;

  final Map<PetType, List<String>> _breeds = const {
    PetType.dog: [
      'Golden Retriever',
      'Toy Poodle',
      'Labrador Retriever',
      'German Shepherd',
      'French Bulldog',
      'Border Collie',
    ],
    PetType.cat: [
      'British Shorthair',
      'Ragdoll',
      'Maine Coon',
      'Siamese',
      'Persian',
    ],
    PetType.others: [
      'Holland Lop',
      'Mini Lop',
      'Netherland Dwarf',
      'Lionhead',
      'Rex',
    ],
  };

  @override
  void initState() {
    super.initState();

    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _selectPetType(PetType type) {
    setState(() {
      _selectedPetType = type;
      _selectedBreed = null;
    });
  }

  void _selectGender(PetGender gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(now.year - 1, now.month, now.day),
      firstDate: DateTime(1990),
      lastDate: now,
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedDate = result;
    });
  }

  Future<void> _selectBreed() async {
    final breeds = _breeds[_selectedPetType] ?? [];

    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DCE2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Select Breed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                ...breeds.map(
                  (breed) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      breed,
                      style: const TextStyle(fontSize: 15, color: textPrimary),
                    ),
                    trailing: _selectedBreed == breed
                        ? const Icon(Icons.check_rounded, color: primary)
                        : null,
                    onTap: () {
                      Navigator.of(sheetContext).pop(breed);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedBreed = result;
    });
  }

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8DCE2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Add Pet Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: primary,
                  ),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(sheetContext, ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: primary,
                  ),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(sheetContext, ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null || !mounted) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (image == null || !mounted) return;

      final file = File(image.path);
      final extension = image.path.split('.').last.toLowerCase();
      const allowedExtensions = ['jpg', 'jpeg', 'png'];

      if (!allowedExtensions.contains(extension)) {
        _showError('Only JPG, JPEG and PNG images are supported.');

        return;
      }

      final fileSize = await file.length();
      const maxSize = 5 * 1024 * 1024;

      if (fileSize > maxSize) {
        if (!mounted) return;

        _showError('Image size must be less than 5MB.');

        return;
      }

      if (!mounted) return;

      setState(() {
        _petImage = file;
      });
    } catch (e) {
      if (!mounted) return;

      _showError('Unable to select image. Please try again.');
    }
  }

  Future<void> _savePet() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter your pet name.');
      return;
    }

    if (_selectedBreed == null) {
      _showError('Please select a breed.');
      return;
    }

    if (_selectedDate == null) {
      _showError('Please select date of birth.');
      return;
    }

    double? weight;

    if (_weightController.text.trim().isNotEmpty) {
      weight = double.tryParse(_weightController.text.trim());

      if (weight == null || weight <= 0) {
        _showError('Please enter a valid weight.');
        return;
      }
    }

    setState(() {
      _saving = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final data = AddPetFormData(
      name: name,
      type: _selectedPetType,
      breed: _selectedBreed!,
      dateOfBirth: _selectedDate!,
      gender: _selectedGender,
      weight: weight,
      notes: _notesController.text.trim(),
      image: _petImage,
    );

    widget.onSaved?.call(data);

    setState(() {
      _saving = false;
    });

    Navigator.of(context).pop(data);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
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
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  22,
                  0,
                  22,
                  MediaQuery.paddingOf(context).bottom + 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Add your pet's information",
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPhotoSection(),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Pet Name'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Enter pet name',
                      icon: Icons.pets_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Pet Type'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _PetTypeButton(
                            type: PetType.dog,
                            selected: _selectedPetType == PetType.dog,
                            onTap: () => _selectPetType(PetType.dog),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PetTypeButton(
                            type: PetType.cat,
                            selected: _selectedPetType == PetType.cat,
                            onTap: () => _selectPetType(PetType.cat),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _PetTypeButton(
                            type: PetType.others,
                            selected: _selectedPetType == PetType.others,
                            onTap: () => _selectPetType(PetType.others),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Breed'),
                    const SizedBox(height: 8),
                    _SelectField(
                      icon: Icons.pets_outlined,
                      text: _selectedBreed ?? 'Select breed',
                      selected: _selectedBreed != null,
                      onTap: _selectBreed,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Date of Birth'),
                    const SizedBox(height: 8),
                    _SelectField(
                      icon: Icons.calendar_month_outlined,
                      text: _selectedDate == null
                          ? 'Select date'
                          : _formatDate(_selectedDate!),
                      selected: _selectedDate != null,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Gender'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _GenderButton(
                            gender: PetGender.male,
                            selected: _selectedGender == PetGender.male,
                            onTap: () => _selectGender(PetGender.male),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _GenderButton(
                            gender: PetGender.female,
                            selected: _selectedGender == PetGender.female,
                            onTap: () => _selectGender(PetGender.female),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Weight (Optional)'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _weightController,
                      hint: 'Enter weight',
                      icon: Icons.monitor_weight_outlined,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      suffix: 'kg',
                    ),
                    const SizedBox(height: 16),
                    _buildSectionLabel('Notes (Optional)'),
                    const SizedBox(height: 8),
                    _buildNotesField(),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _savePet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF84C68F),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Save Pet',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 56,
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
            const Text(
              'Add Pet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _addPhoto,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF2FAF0),
                image: _petImage != null
                    ? DecorationImage(
                        image: FileImage(_petImage!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _petImage == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 24,
                          color: primary,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Add Photo',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _petImage == null ? 'JPG, PNG up to 5MB' : 'Tap photo to change',
            style: TextStyle(fontSize: 10, color: Color(0xFF7B8395)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? suffix,
  }) {
    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: primary,
        style: const TextStyle(fontSize: 12, color: textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 16, color: const Color(0xFF959CAC)),
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9CA3B1)),
          suffixIcon: suffix == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      suffix,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF70788B),
                      ),
                    ),
                  ),
                ),
          filled: true,
          fillColor: Colors.white,
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
            borderSide: const BorderSide(color: primary, width: 1.2),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Stack(
        children: [
          TextField(
            controller: _notesController,
            maxLength: 200,
            maxLines: null,
            expands: true,
            cursorColor: primary,
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              prefixIcon: Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 65),
                child: Icon(
                  Icons.notes_rounded,
                  size: 16,
                  color: Color(0xFF959CAC),
                ),
              ),
              hintText: 'Add any notes about your pet',
              hintStyle: TextStyle(fontSize: 12, color: Color(0xFF9CA3B1)),
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.fromLTRB(0, 12, 48, 12),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Text(
              '${_notesController.text.length}/200',
              style: const TextStyle(fontSize: 10, color: Color(0xFF7E879B)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final bool selected;
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
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE4E8EC)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF959CAC)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    color: selected
                        ? const Color(0xFF172038)
                        : const Color(0xFF9CA3B1),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: Color(0xFF667087),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetTypeButton extends StatelessWidget {
  const _PetTypeButton({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final PetType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F9EF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF58B767)
                  : const Color(0xFFE4E8EC),
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type.icon,
                size: 32,
                color: selected
                    ? const Color(0xFF15952A)
                    : const Color(0xFF596178),
              ),
              const SizedBox(height: 8),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xFF15952A)
                      : const Color(0xFF293248),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.gender,
    required this.selected,
    required this.onTap,
  });

  final PetGender gender;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F9EF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFF58B767)
                  : const Color(0xFFE4E8EC),
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                gender == PetGender.male
                    ? Icons.male_rounded
                    : Icons.female_rounded,
                size: 24,
                color: selected
                    ? const Color(0xFF15952A)
                    : const Color(0xFF596178),
              ),
              const SizedBox(width: 6),
              Text(
                gender.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xFF15952A)
                      : const Color(0xFF293248),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
