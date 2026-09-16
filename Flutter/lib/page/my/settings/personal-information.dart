// lib/page/my/settings/personal-information.dart
import 'package:flutter/material.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  static const Color primary = Color(0xFF16A52F);
  static const Color background = Color(0xFFFCFDFB);

  String _fullName = 'Jasper Lin';
  String _email = 'jasper.lin@yipet.com';
  String _phoneNumber = '+64 21 123 4567';
  DateTime _dateOfBirth = DateTime(1996, 5, 16);

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> _editTextValue({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSave,
    TextInputType? keyboardType,
  }) async {
    final controller = TextEditingController(text: initialValue);

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType,
            autofocus: true,
            cursorColor: primary,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();

                if (value.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext, value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) return;

    onSave(result);
  }

  Future<void> _selectDateOfBirth() async {
    final result = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (!mounted || result == null) return;

    setState(() {
      _dateOfBirth = result;
    });
  }

  void _changePhoto() {
    _showMessage('Change profile photo');
  }

  void _changePassword() {
    _showMessage('Change Password');
  }

  void _editInformation() {
    _showMessage('Edit Information');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width * 0.045;

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
              child: PersonalInformationHeader(onBackTap: _goBack),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  0,
                  horizontalPadding,
                  MediaQuery.paddingOf(context).bottom + 28,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileInformationCard(
                      name: _fullName,
                      email: _email,
                      phoneNumber: _phoneNumber,
                      imagePath: 'assets/images/profile/profile_avatar.png',
                      onCameraTap: _changePhoto,
                    ),
                    const SizedBox(height: 16),
                    const SectionTitle(title: 'Basic Information'),
                    const SizedBox(height: 8),
                    InformationSectionCard(
                      children: [
                        InformationRow(
                          icon: Icons.person_outline_rounded,
                          title: 'Full Name',
                          value: _fullName,
                          onTap: () {
                            _editTextValue(
                              title: 'Full Name',
                              initialValue: _fullName,
                              onSave: (value) {
                                setState(() {
                                  _fullName = value;
                                });
                              },
                            );
                          },
                        ),
                        const SectionDivider(),
                        InformationRow(
                          icon: Icons.mail_outline_rounded,
                          title: 'Email',
                          value: _email,
                          onTap: () {
                            _editTextValue(
                              title: 'Email',
                              initialValue: _email,
                              keyboardType: TextInputType.emailAddress,
                              onSave: (value) {
                                setState(() {
                                  _email = value;
                                });
                              },
                            );
                          },
                        ),
                        const SectionDivider(),
                        InformationRow(
                          icon: Icons.phone_outlined,
                          title: 'Phone Number',
                          value: _phoneNumber,
                          onTap: () {
                            _editTextValue(
                              title: 'Phone Number',
                              initialValue: _phoneNumber,
                              keyboardType: TextInputType.phone,
                              onSave: (value) {
                                setState(() {
                                  _phoneNumber = value;
                                });
                              },
                            );
                          },
                        ),
                        const SectionDivider(),
                        InformationRow(
                          icon: Icons.calendar_month_outlined,
                          title: 'Date of Birth',
                          value: _formatDate(_dateOfBirth),
                          onTap: _selectDateOfBirth,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SectionTitle(title: 'Account Security'),
                    const SizedBox(height: 8),
                    InformationSectionCard(
                      children: [
                        InformationRow(
                          icon: Icons.lock_outline_rounded,
                          title: 'Password',
                          value: '********',
                          onTap: _changePassword,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: _editInformation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E971F),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.edit_rounded, size: 24),
                        label: const Text(
                          'Edit Information',
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
}

class PersonalInformationHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const PersonalInformationHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Personal Information',
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
                onTap: onBackTap,
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
        ],
      ),
    );
  }
}

class ProfileInformationCard extends StatelessWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final String imagePath;

  final VoidCallback onCameraTap;

  const ProfileInformationCard({
    super.key,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.imagePath,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FAF2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD7EBD3)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -55,
            top: -55,
            child: Container(
              width: 145,
              height: 145,
              decoration: const BoxDecoration(
                color: Color(0x0A60C264),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -20,
            bottom: -40,
            child: Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                color: Color(0x0960C264),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: ClipOval(
                          child: Image.asset(
                            imagePath,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                width: 120,
                                height: 120,
                                alignment: Alignment.center,
                                color: const Color(0xFFEAF4E7),
                                child: const Icon(
                                  Icons.person_rounded,
                                  size: 80,
                                  color: Color(0xFF7CAF74),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Material(
                          color: const Color(0xFF12962B),
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: onCameraTap,
                            customBorder: const CircleBorder(),
                            child: const SizedBox(
                              width: 36,
                              height: 36,
                              child: Icon(
                                Icons.camera_alt_rounded,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF172038),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5B6682),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF5B6682),
                        ),
                      ),
                    ],
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

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF172038),
      ),
    );
  }
}

class InformationSectionCard extends StatelessWidget {
  final List<Widget> children;

  const InformationSectionCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7EBE7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class InformationRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const InformationRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Icon(icon, size: 24, color: const Color(0xFF16A52F)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF252D42),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  width: 136,
                  child: Text(
                    value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF68728B),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const SizedBox(
                  width: 24,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: Color(0xFF5B6682),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 80),
      child: Divider(height: 1, color: Color(0xFFE9ECE9)),
    );
  }
}
