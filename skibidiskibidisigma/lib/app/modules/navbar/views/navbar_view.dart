import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


import '../controllers/navbar_controller.dart';


class NavbarView extends GetView<NavbarController> {
  NavbarView({super.key});
  final NavbarController navbarController = Get.find<NavbarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GNav(
          gap: 6,
          haptic: true,
          tabBorderRadius: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          color: Colors.grey,
          activeColor: Colors.black,
          iconSize: 22,
          tabBackgroundColor: Colors.red.withOpacity(0.1),
          textStyle: const TextStyle(fontSize: 12),
          selectedIndex: navbarController.selectedIndex.value,
          onTabChange: (index) {
            navbarController.changeTabIndex(index); // Update selected index
          },
          tabs: const [
            GButton(icon: Icons.home_filled, text: 'Home'),
            GButton(icon: Icons.search_outlined, text: 'Cari'),
            GButton(icon: Icons.cases_outlined, text: 'Rencanakan'),
            GButton(icon: Icons.edit, text: 'Ulasan'),
            GButton(icon: Icons.account_circle_outlined, text: 'Akun'),
          ],
        ));
  }
}


