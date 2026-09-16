// lib/page/my/settings/check-for-updates.dart
import 'package:flutter/material.dart';

class CheckForUpdatesPage extends StatefulWidget {
  const CheckForUpdatesPage({super.key});

  @override
  State<CheckForUpdatesPage> createState() => _CheckForUpdatesPageState();
}

class _CheckForUpdatesPageState extends State<CheckForUpdatesPage> {
  static const Color primary = Color(0xFF15952A);
  static const Color textPrimary = Color(0xFF172038);
  static const Color background = Color(0xFFFCFDFB);

  static const String currentVersion = '1.2.3';

  bool _checking = false;

  DateTime _lastChecked = DateTime(2025, 5, 18, 9, 41);

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

  Future<void> _checkForUpdates() async {
    if (_checking) return;

    setState(() {
      _checking = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _checking = false;
      _lastChecked = DateTime.now();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('YiPet is already up to date.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _openReleaseNotes() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Latest Version 1.2.3'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  String _formatLastChecked(DateTime value) {
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

    final hour12 = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';

    return '${months[value.month - 1]} '
        '${value.day}, ${value.year} '
        '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 20.0;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                0,
              ),
              child: CheckForUpdatesHeader(onBackTap: _goBack),
            ),
            const SizedBox(height: 8),
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
                    const UpdateStatusCard(version: currentVersion),
                    const SizedBox(height: 24),
                    const Text(
                      'What\'s New',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    WhatsNewCard(
                      version: currentVersion,
                      onTap: _openReleaseNotes,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _checking ? null : _checkForUpdates,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          disabledBackgroundColor: const Color(0xFF8BC894),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _checking
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.refresh_rounded, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    'Check for Updates',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Last checked: '
                        '${_formatLastChecked(_lastChecked)}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7A8192),
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
}

class CheckForUpdatesHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const CheckForUpdatesHeader({super.key, required this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Center(
            child: Text(
              'Check for Updates',
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

class UpdateStatusCard extends StatelessWidget {
  final String version;

  const UpdateStatusCard({super.key, required this.version});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E8E4)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 160,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF1F8EF),
                  ),
                ),
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF5DC460), Color(0xFF15952A)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A15952A),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 44,
                    color: Colors.white,
                  ),
                ),
                const Positioned(
                  left: 4,
                  top: 16,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 24,
                    color: Color(0xFF15952A),
                  ),
                ),
                const Positioned(
                  right: 0,
                  bottom: 20,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 24,
                    color: Color(0xFF15952A),
                  ),
                ),
                Positioned(
                  left: 8,
                  bottom: 16,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB7DDB7),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'re up to date!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172038),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'You have the latest version of YiPet.',
            style: TextStyle(fontSize: 12, color: Color(0xFF5C6782)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F8EE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD8ECD6)),
            ),
            child: Text(
              'Current Version $version',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF258735),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WhatsNewCard extends StatelessWidget {
  final String version;
  final VoidCallback onTap;

  const WhatsNewCard({super.key, required this.version, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6EAE6)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEDF8EE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      size: 24,
                      color: Color(0xFF15952A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latest Version $version',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF172038),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Released on May 10, 2025',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5C6782),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 24,
                    color: Color(0xFF5C6782),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'We regularly update YiPet to improve performance and\n'
                  'bring you new features.',
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: Color(0xFF5C6782),
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

class AutoUpdatesCard extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AutoUpdatesCard({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAE6)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEDF8EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 29,
              color: Color(0xFF15952A),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Auto Updates',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172038),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Automatically download and install updates.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF5C6782)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          UpdateSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class UpdateSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const UpdateSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 58,
        height: 34,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF15952A) : const Color(0xFFE5E6E8),
          borderRadius: BorderRadius.circular(18),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x16000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
