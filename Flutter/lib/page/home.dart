// lib/page/home.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/user-service.dart';
import '../core/network/api-exception.dart';

import 'home/notifications.dart';
import 'my/appointments/appointment-detail.dart';
import 'ai/ai-chat.dart';

import '../models/user/user-model.dart';
import '../view-models/home.dart';
import '../view-models/pet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? user;

  String get fullName {
    final name = [
      user?.firstName,
      user?.lastName,
    ].whereType<String>().where((name) => name.isNotEmpty).join(' ');

    return name.isEmpty ? 'User' : name;
  }

  int _selectedPetIndex = 0;
  List<PetData> _pets = [];

  PetData get _currentPet => _pets[_selectedPetIndex];

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _openNotifications() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsPage()),
    );
  }

  void _openReminder() {
    _showMessage('Open vaccine reminder');
  }

  void _openAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AppointmentDetailPage()),
    );
  }

  void _openAiAssistant() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AIChatPage()));
  }

  Future<void> _selectPet() async {
    final selectedIndex = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
            itemCount: _pets.length,
            separatorBuilder: (_, __) {
              return const Divider(height: 1);
            },
            itemBuilder: (context, index) {
              final pet = _pets[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFFF1F8EE),
                  child: ClipOval(
                    child: Image.asset(
                      pet.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return const Icon(
                          Icons.pets,
                          color: HomeColors.primary,
                        );
                      },
                    ),
                  ),
                ),
                title: Text(
                  pet.name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('${pet.breed} · ${pet.age}'),
                trailing: index == _selectedPetIndex
                    ? const Icon(Icons.check_circle, color: HomeColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(sheetContext, index);
                },
              );
            },
          ),
        );
      },
    );

    if (selectedIndex == null || !mounted) {
      return;
    }

    final pet = _pets[selectedIndex];
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('pet_id', pet.id);

    setState(() {
      _selectedPetIndex = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    _getUserData();
    _getPetList();
  }

  Future<void> _getUserData() async {
    try {
      final res = await UserService.instance.getUserData();

      setState(() {
        user = res.user;
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

  Future<void> _getPetList() async {
    try {
      final res = await UserService.instance.getPetList();
      final list = res.pets.map((item) => PetData.fromModel(item)).toList();

      if (list.isNotEmpty) {
        final pet = list[0];
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('pet_id', pet.id);
      }

      setState(() {
        _pets = list;
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
      backgroundColor: HomeColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            18,
            horizontalPadding,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                fullName: fullName,
                onNotificationTap: _openNotifications,
              ),
              const SizedBox(height: 8),
              PetHeroCard(pet: _currentPet, onPetTap: _selectPet),
              const SizedBox(height: 16),
              PetStatsRow(pet: _currentPet),
              const SizedBox(height: 16),
              SectionHeader(
                title: 'Today’s Reminders',
                actionText: 'See all',
                onActionTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              ReminderCard(onTap: _openReminder),
              const SizedBox(height: 16),
              const SectionHeader(title: 'Upcoming Appointment'),
              const SizedBox(height: 8),
              AppointmentCard(onTap: _openAppointment),
              const SizedBox(height: 16),
              AiAssistantBanner(onTap: _openAiAssistant),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  final String fullName;
  final VoidCallback onNotificationTap;

  const HomeHeader({
    super.key,
    required this.fullName,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi, $fullName 👋',
                style: TextStyle(
                  fontSize: 24,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                  color: HomeColors.textPrimary,
                ),
              ),
              Text(
                'Good morning!',
                style: TextStyle(fontSize: 16, color: HomeColors.textSecondary),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onNotificationTap,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Center(
                    child: Icon(
                      Icons.notifications_none_rounded,
                      size: 28,
                      color: HomeColors.textPrimary,
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 6,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
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

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: HomeColors.textPrimary,
            ),
          ),
        ),
        if (actionText != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: HomeColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              actionText!,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}

class PetHeroCard extends StatelessWidget {
  final PetData pet;
  final VoidCallback onPetTap;

  const PetHeroCard({super.key, required this.pet, required this.onPetTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return AspectRatio(
      aspectRatio: 955 / 450,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8ED),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5EEE1)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8FCF5), Color(0xFFEAF7E2)],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -10,
              top: 0,
              bottom: 0,
              width: screenWidth * 0.48,
              child: Image.network(
                pet.imagePath,
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.pets,
                      size: 120,
                      color: Color(0xFFB7D9AA),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              right: screenWidth * 0.38,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PetNameSelector(name: pet.name, onTap: onPetTap),
                  Text(
                    '${pet.breed}  ·  ${pet.age}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: HomeColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  HealthScoreCard(
                    score: pet.healthScore,
                    label: pet.healthLabel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetNameSelector extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const PetNameSelector({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: HomeColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24,
                color: HomeColors.textPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HealthScoreCard extends StatelessWidget {
  final int score;
  final String label;

  const HealthScoreCard({super.key, required this.score, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 80,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.7)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Health Score',
                  style: TextStyle(
                    fontSize: 12,
                    color: HomeColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.eco_rounded,
                      size: 20,
                      color: HomeColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 28,
                        height: 1,
                        fontWeight: FontWeight.w800,
                        color: HomeColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          HealthScoreRing(score: score, label: label),
        ],
      ),
    );
  }
}

class HealthScoreRing extends StatelessWidget {
  final int score;
  final String label;

  const HealthScoreRing({super.key, required this.score, required this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: CustomPaint(
        painter: ScoreRingPainter(progress: score / 100),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: HomeColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreRingPainter extends CustomPainter {
  final double progress;

  ScoreRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - 7) / 2;
    final trackPaint = Paint()
      ..color = const Color(0xFFDDEED8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..color = HomeColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      6.28318 * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ScoreRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class PetStatsRow extends StatelessWidget {
  final PetData pet;

  const PetStatsRow({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.calendar_month_outlined,
            value: pet.healthyDays,
            label: 'Healthy',
            labelIcon: Icons.eco_rounded,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            icon: Icons.monitor_weight_outlined,
            value: pet.weight.toStringAsFixed(1),
            label: 'Weight',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatCard(
            icon: Icons.pets_rounded,
            value: pet.activity,
            label: pet.activity == 'Active' ? 'Happy' : 'Relaxed',
            labelIcon: Icons.star_rounded,
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final IconData? labelIcon;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.labelIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HomeColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8EE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: HomeColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: HomeColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (labelIcon != null) ...[
                      Icon(labelIcon, size: 10, color: HomeColors.primary),
                      const SizedBox(width: 2),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: HomeColors.textSecondary,
                        ),
                      ),
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

class ReminderCard extends StatelessWidget {
  final VoidCallback onTap;

  const ReminderCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HomeActionCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF7C6F), Color(0xFFFF3F3F)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.vaccines_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vaccine Reminder',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: HomeColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Rabies vaccine',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Due in 5 days',
                style: TextStyle(fontSize: 10, color: HomeColors.textSecondary),
              ),
              SizedBox(height: 4),
              Text(
                'May 20, 2024',
                style: TextStyle(fontSize: 10, color: HomeColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final VoidCallback onTap;

  const AppointmentCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HomeActionCard(
      onTap: onTap,
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grooming',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: HomeColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'May 16, 2024  •  2:00 PM',
                  style: TextStyle(
                    fontSize: 10,
                    color: HomeColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F8EE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_available_outlined,
              color: HomeColors.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeActionCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const HomeActionCard({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: HomeColors.border),
            boxShadow: const [
              BoxShadow(
                color: Color(0x08000000),
                blurRadius: 13,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class AiAssistantBanner extends StatelessWidget {
  final VoidCallback onTap;

  const AiAssistantBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return AspectRatio(
      aspectRatio: 2.25,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F8ED),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE4EEE0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x07000000),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8FCF5), Color(0xFFE9F6E2)],
                  ),
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: -40,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: 70,
              bottom: -35,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: HomeColors.primary.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              right: -3,
              top: 0,
              bottom: 0,
              width: width * 0.37,
              child: Image.asset(
                'assets/images/home/ai-robot.png',
                fit: BoxFit.contain,
                alignment: Alignment.bottomRight,
                errorBuilder: (_, __, ___) {
                  return const Center(
                    child: Icon(
                      Icons.smart_toy_rounded,
                      size: 105,
                      color: Color(0xFF78BD6A),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 20,
              top: 19,
              bottom: 18,
              width: width * 0.47,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Ask AI Assistant',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: HomeColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: HomeColors.primary,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'How can I help you\nand your pet today?',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: HomeColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 16,
                      ),
                      label: const Text(
                        'Ask Now',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: HomeColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AutoFitText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;
  final TextAlign textAlign;

  const AutoFitText(
    this.text, {
    super.key,
    required this.style,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: textAlign == TextAlign.center
          ? Alignment.center
          : Alignment.centerLeft,
      child: Text(text, maxLines: maxLines, textAlign: textAlign, style: style),
    );
  }
}
