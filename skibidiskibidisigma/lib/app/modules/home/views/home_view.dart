import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/navbar/views/navbar_view.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:skibidiskibidisigma/app/modules/Profile/controllers/profile_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final ProfileController profileController = Get.find<ProfileController>();

    // State to track description expansion
    RxBool isExpanded = false.obs;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 193, 167, 1),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Telusuri',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.PROFILE); // Navigate to profile page
              },
              child: Obx(() => CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        profileController.profileImage.value != null
                            ? FileImage(profileController.profileImage.value!)
                            : profileController.profileImageUrl.value != null
                                ? NetworkImage(
                                    profileController.profileImageUrl.value!)
                                : const AssetImage('assets/icon/sigma.png')
                                    as ImageProvider,
                  )),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Anda mungkin menyukai hal ini',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes
                              .WIKIPEDIA); // Change PLAN to the desired page
                        },
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/icon/bromo.png',
                                  height: 100,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '1 Day - Tour Bromo Sunrise',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Obx(() {
                                String description =
                                    'Nikmati keindahan matahari terbit di Gunung Bromo dalam tur sehari yang mempesona.';
                                bool expanded = isExpanded.value;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expanded
                                          ? description // Full description
                                          : '${description.substring(0, 30)}...', // Partial description
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        isExpanded.value = !expanded;
                                      },
                                      child: Text(
                                        expanded ? 'Show Less' : 'Read More',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes
                              .WIKIPEDIA); // Change PLAN to the desired page
                          Get.toNamed(
                              Routes.PLAN); // Change PLAN to the desired page
                        },
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/icon/pantai.png',
                                  height: 100,
                                  width: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '1 Day - Pantai Balekambang',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Obx(() {
                                String description =
                                    'Rasakan deburan ombak dan suasana indah Pantai Balekambang dalam perjalanan sehari.';
                                bool expanded = isExpanded.value;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expanded
                                          ? description // Full description
                                          : '${description.substring(0, 30)}...', // Partial description
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        isExpanded.value = !expanded;
                                      },
                                      child: Text(
                                        expanded ? 'Show Less' : 'Read More',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                                        ElevatedButton(onPressed: () {
                        Get.toNamed(Routes.CONNECTION);
                      }, child: const Text('skibidi'))
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavbarView(), // Add Navbar here
    );
  }
}
