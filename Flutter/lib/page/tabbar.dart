// lib/page/tabbar.dart
import 'package:flutter/material.dart';

import 'home.dart';
import 'shop.dart';
import 'pet.dart';
import 'ai.dart';
import 'my.dart';

class TabBarPage extends StatefulWidget {
  const TabBarPage({super.key});

  @override
  State<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends State<TabBarPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    ShopPage(),
    PetPage(),
    AIPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFCFA),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: YiPetTabBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class YiPetTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const YiPetTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const Color activeColor = Color(0xFF22C55E);
  static const Color inactiveColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: 72,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFF1F3F5), width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 24,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: YiPetTabItem(
                  index: 0,
                  currentIndex: currentIndex,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: YiPetTabItem(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Icons.shopping_bag_outlined,
                  activeIcon: Icons.shopping_bag,
                  label: 'Shop',
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: YiPetTabItem(
                  index: 2,
                  currentIndex: currentIndex,
                  icon: Icons.pets_outlined,
                  activeIcon: Icons.pets,
                  label: 'Pet',
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: YiPetTabItem(
                  index: 3,
                  currentIndex: currentIndex,
                  icon: Icons.smart_toy_outlined,
                  activeIcon: Icons.smart_toy,
                  label: 'AI',
                  onTap: onTap,
                ),
              ),
              Expanded(
                child: YiPetTabItem(
                  index: 4,
                  currentIndex: currentIndex,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'My',
                  onTap: onTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class YiPetTabItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final ValueChanged<int> onTap;

  const YiPetTabItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.onTap,
  });

  static const Color activeColor = Color(0xFF22C55E);
  static const Color inactiveColor = Color(0xFF9CA3AF);

  @override
  Widget build(BuildContext context) {
    final bool selected = currentIndex == index;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(index),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                selected ? activeIcon : icon,
                size: 24,
                color: selected ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  height: 1,
                  color: selected ? activeColor : inactiveColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
