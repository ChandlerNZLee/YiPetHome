// lib/page/pet/edit-pet.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../view-models/pet.dart';

class EditPetPage extends StatefulWidget {
  final PetData pet;

  const EditPetPage({super.key, required this.pet});

  @override
  State<EditPetPage> createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color textSecondary = Color(0xFF667087);
  static const Color border = Color(0xFFE5E9ED);
  static const Color background = Color(0xFFFCFDFB);
  static const Color danger = Color(0xFFE54848);

  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _weightController;
  late final TextEditingController _microchipController;
  late final TextEditingController _aboutController;
  late final TextEditingController _notesController;

  late PetType _selectedType;
  late PetGender _selectedGender;

  String? _selectedBreed;
  DateTime? _selectedDate;

  String? _selectedSize;
  String? _selectedColor;
  String? _selectedNeutered;
  String? _selectedBloodType;
  String? _selectedInsurance;

  File? _newImage;

  bool _saving = false;

  final Map<PetType, List<String>> _breeds = const {
    PetType.dog: [
      'Golden Retriever',
      'Labrador Retriever',
      'Toy Poodle',
      'German Shepherd',
      'Border Collie',
      'French Bulldog',
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

  final List<String> _sizes = const ['Small', 'Medium', 'Large'];

  final List<String> _colors = const [
    'Golden',
    'Black',
    'White',
    'Brown',
    'Cream',
    'Gray',
    'Mixed',
  ];

  final List<String> _neuteredOptions = const ['Yes', 'No'];

  final List<String> _bloodTypes = const [
    'DEA 1.1 Positive',
    'DEA 1.1 Negative',
    'Unknown',
  ];

  final List<String> _insuranceOptions = const [
    'Trupanion (Active)',
    'Southern Cross',
    'Pet-n-Sur',
    'None',
  ];

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.pet.name);
    _weightController = TextEditingController(
      text: widget.pet.weight.toStringAsFixed(1),
    );
    _microchipController = TextEditingController(text: '985 141 000 123 456');
    _aboutController = TextEditingController(
      text:
          'Milo is a very friendly and active boy. He loves playing fetch in the park and enjoys swimming. He gets along well with other dogs and people.',
    );
    _notesController = TextEditingController(
      text:
          'Milo has a mild allergy to chicken. Please avoid anything with chicken ingredients.',
    );

    _selectedType = widget.pet.breed == 'Dog'
        ? PetType.dog
        : (widget.pet.breed == 'Cat' ? PetType.cat : PetType.others);
    _selectedGender = widget.pet.gender == 'Male'
        ? PetGender.male
        : PetGender.female;

    _selectedBreed = widget.pet.breed;
    _selectedDate = DateTime(2021, 5, 20);

    _selectedSize = 'Large';
    _selectedColor = 'Golden';
    _selectedNeutered = 'Yes';
    _selectedBloodType = 'DEA 1.1 Positive';
    _selectedInsurance = 'Trupanion (Active)';

    _aboutController.addListener(_refresh);
    _notesController.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _aboutController.removeListener(_refresh);
    _notesController.removeListener(_refresh);

    _nameController.dispose();
    _weightController.dispose();
    _microchipController.dispose();
    _aboutController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  void _goBack() {
    Navigator.of(context).pop();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _selectType(PetType type) {
    setState(() {
      _selectedType = type;

      if (!_breeds[type]!.contains(_selectedBreed)) {
        _selectedBreed = null;
      }
    });
  }

  void _selectGender(PetGender gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
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
                const SizedBox(height: 18),
                const Text(
                  'Change Pet Photo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
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
                    Icons.photo_camera_outlined,
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

    if (!mounted || source == null) return;

    try {
      final XFile? result = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (!mounted || result == null) return;

      final file = File(result.path);
      final extension = result.path.split('.').last.toLowerCase();
      const allowedExtensions = ['jpg', 'jpeg', 'png'];

      if (!allowedExtensions.contains(extension)) {
        _showError('Only JPG, JPEG and PNG images are supported.');
        return;
      }

      final fileSize = await file.length();
      const maxSize = 5 * 1024 * 1024;

      if (fileSize > maxSize) {
        _showError('Image size must be less than 5MB.');
        return;
      }

      if (!mounted) return;

      setState(() {
        _newImage = file;
      });
    } catch (e) {
      if (!mounted) return;

      _showError('Unable to select image. Please try again.');
    }
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

  Future<String?> _showOptions(
    String title,
    List<String> options,
    String? selected,
  ) async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item,
                      style: const TextStyle(fontSize: 15, color: textPrimary),
                    ),
                    trailing: selected == item
                        ? const Icon(Icons.check_rounded, color: primary)
                        : null,
                    onTap: () {
                      Navigator.pop(sheetContext, item);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectBreed() async {
    final result = await _showOptions(
      'Select Breed',
      _breeds[_selectedType] ?? [],
      _selectedBreed,
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedBreed = result;
    });
  }

  Future<void> _selectSize() async {
    final result = await _showOptions('Select Size', _sizes, _selectedSize);

    if (!mounted || result == null) return;

    setState(() {
      _selectedSize = result;
    });
  }

  Future<void> _selectColor() async {
    final result = await _showOptions('Select Color', _colors, _selectedColor);

    if (!mounted || result == null) return;

    setState(() {
      _selectedColor = result;
    });
  }

  Future<void> _selectNeutered() async {
    final result = await _showOptions(
      'Spayed / Neutered',
      _neuteredOptions,
      _selectedNeutered,
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedNeutered = result;
    });
  }

  Future<void> _selectBloodType() async {
    final result = await _showOptions(
      'Blood Type',
      _bloodTypes,
      _selectedBloodType,
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedBloodType = result;
    });
  }

  Future<void> _selectInsurance() async {
    final result = await _showOptions(
      'Insurance',
      _insuranceOptions,
      _selectedInsurance,
    );

    if (!mounted || result == null) return;

    setState(() {
      _selectedInsurance = result;
    });
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      _showError('Please enter pet name.');
      return;
    }

    if (_selectedBreed == null) {
      _showError('Please select breed.');
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

    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;

    final saveData = PetEditData(
      id: widget.pet.id.toString(),
      name: name,
      type: _selectedType,
      breed: _selectedBreed ?? '',
      dateOfBirth: _selectedDate ?? DateTime.parse('2021-05-20'),
      gender: _selectedGender,
      weight: weight,
      size: _selectedSize,
      color: _selectedColor,
      neutered: _selectedNeutered,
      microchipId: _microchipController.text.trim(),
      bloodType: _selectedBloodType,
      insurance: _selectedInsurance,
      about: _aboutController.text.trim(),
      notes: _notesController.text.trim(),
      imagePath: '',
      localImage: _newImage,
    );

    setState(() {
      _saving = false;
    });

    Navigator.of(context).pop(EditPetResult.updated(saveData));
  }

  Future<void> _deletePet() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Pet?',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            'Are you sure you want to delete ${widget.pet.name}? '
            'This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete', style: TextStyle(color: danger)),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    Navigator.of(context).pop(EditPetResult.deleted(widget.pet.id.toString()));
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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
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
                  24,
                  0,
                  24,
                  MediaQuery.paddingOf(context).bottom + 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Update your pet's information",
                        style: TextStyle(fontSize: 10, color: textSecondary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTopSection(),
                    const SizedBox(height: 16),
                    const Text(
                      'Basic Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBasicInfo(),
                    const SizedBox(height: 16),
                    _buildTextarea(
                      title:
                          'About ${_nameController.text.isEmpty ? widget.pet.name : _nameController.text}',
                      controller: _aboutController,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 16),
                    _buildTextarea(
                      title: 'Notes',
                      controller: _notesController,
                      maxLength: 200,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _saving ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF8BC894),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
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
                                'Save Changes',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: TextButton.icon(
                        onPressed: _deletePet,
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                        ),
                        label: const Text('Delete Pet'),
                        style: TextButton.styleFrom(
                          foregroundColor: danger,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SizedBox(
        height: 56,
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
                    color: Color(0xFF111820),
                  ),
                ),
              ),
            ),
            const Text(
              'Edit Pet',
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

  Widget _buildTopSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPhoto(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Pet Name', required: true),
              const SizedBox(height: 8),
              _buildTextField(controller: _nameController),
              const SizedBox(height: 8),
              _buildLabel('Pet Type', required: true),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _TypeButton(
                      type: PetType.dog,
                      selected: _selectedType == PetType.dog,
                      onTap: () => _selectType(PetType.dog),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TypeButton(
                      type: PetType.cat,
                      selected: _selectedType == PetType.cat,
                      onTap: () => _selectType(PetType.cat),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _TypeButton(
                      type: PetType.others,
                      selected: _selectedType == PetType.others,
                      onTap: () => _selectType(PetType.others),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoto() {
    return SizedBox(
      width: 120,
      height: 160,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _newImage != null
                  ? Image.file(_newImage!, fit: BoxFit.cover)
                  : Image.network(
                      widget.pet.imagePath,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFFF1F8EF),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.pets_rounded,
                            size: 60,
                            color: primary,
                          ),
                        );
                      },
                    ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 3,
              child: InkWell(
                onTap: _pickImage,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.photo_camera_outlined,
                    size: 18,
                    color: Color(0xFF4E586C),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final width = (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: 12,
          children: [
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Breed',
                icon: Icons.pets_outlined,
                child: _SelectBox(
                  text: _selectedBreed ?? 'Select breed',
                  onTap: _selectBreed,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Date of Birth',
                required: true,
                icon: Icons.calendar_month_outlined,
                child: _SelectBox(
                  text: _selectedDate == null
                      ? 'Select date'
                      : _formatDate(_selectedDate!),
                  trailingIcon: Icons.calendar_today_outlined,
                  onTap: _selectDate,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Gender',
                required: true,
                icon: Icons.male_rounded,
                child: Row(
                  children: [
                    Expanded(
                      child: _GenderButton(
                        gender: PetGender.male,
                        selected: _selectedGender == PetGender.male,
                        onTap: () => _selectGender(PetGender.male),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: _GenderButton(
                        gender: PetGender.female,
                        selected: _selectedGender == PetGender.female,
                        onTap: () => _selectGender(PetGender.female),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Weight',
                icon: Icons.monitor_weight_outlined,
                child: _buildTextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  suffix: 'kg',
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Size',
                icon: Icons.pets_outlined,
                child: _SelectBox(
                  text: _selectedSize ?? 'Select size',
                  onTap: _selectSize,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Color',
                icon: Icons.water_drop_outlined,
                child: _SelectBox(
                  text: _selectedColor ?? 'Select color',
                  onTap: _selectColor,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Spayed / Neutered',
                icon: Icons.content_cut_rounded,
                child: _SelectBox(
                  text: _selectedNeutered ?? 'Select',
                  onTap: _selectNeutered,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Microchip ID',
                icon: Icons.memory_outlined,
                child: _buildTextField(controller: _microchipController),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Blood Type',
                icon: Icons.shield_outlined,
                child: _SelectBox(
                  text: _selectedBloodType ?? 'Select',
                  onTap: _selectBloodType,
                ),
              ),
            ),
            SizedBox(
              width: width,
              child: _FieldBlock(
                label: 'Insurance',
                icon: Icons.shield_outlined,
                child: _SelectBox(
                  text: _selectedInsurance ?? 'Select',
                  onTap: _selectInsurance,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFE34B4B)),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? suffix,
  }) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        cursorColor: primary,
        style: const TextStyle(fontSize: 12, color: textPrimary),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          suffixText: suffix,
          suffixStyle: const TextStyle(fontSize: 12, color: textSecondary),
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
            borderSide: const BorderSide(color: primary, width: 1.2),
          ),
        ),
      ),
    );
  }

  Widget _buildTextarea({
    required String title,
    required TextEditingController controller,
    required int maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.notes_rounded, size: 16, color: textSecondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 112,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border),
          ),
          child: Stack(
            children: [
              TextField(
                controller: controller,
                maxLength: maxLength,
                maxLines: null,
                expands: true,
                cursorColor: primary,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                  contentPadding: EdgeInsets.fromLTRB(8, 4, 8, 28),
                ),
              ),
              Positioned(
                right: 12,
                bottom: 8,
                child: Text(
                  '${controller.text.length}/$maxLength',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF8A92A4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FieldBlock extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget child;
  final bool required;

  const _FieldBlock({
    required this.label,
    required this.icon,
    required this.child,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF69738A)),
            const SizedBox(width: 6),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF5F697E),
                ),
                children: [
                  TextSpan(text: label),
                  if (required)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Color(0xFFE34B4B)),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _SelectBox extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? trailingIcon;

  const _SelectBox({
    required this.text,
    required this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E9ED)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF172038),
                  ),
                ),
              ),
              Icon(
                trailingIcon ?? Icons.keyboard_arrow_down_rounded,
                size: 16,
                color: const Color(0xFF667087),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeButton extends StatelessWidget {
  final PetType type;
  final bool selected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.type,
    required this.selected,
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
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F9EF) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? const Color(0xFF5BB96A)
                  : const Color(0xFFE5E9ED),
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type.icon,
                size: 24,
                color: selected
                    ? const Color(0xFF15952A)
                    : const Color(0xFF596178),
              ),
              const SizedBox(height: 2),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: 12,
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
  final PetGender gender;
  final bool selected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.gender,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF1F9EF) : Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected
                  ? const Color(0xFF5BB96A)
                  : const Color(0xFFE5E9ED),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                gender == PetGender.male
                    ? Icons.male_rounded
                    : Icons.female_rounded,
                size: 16,
                color: selected
                    ? const Color(0xFF15952A)
                    : const Color(0xFF596178),
              ),
              const SizedBox(width: 4),
              Text(
                gender.label,
                style: TextStyle(
                  fontSize: 12,
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
