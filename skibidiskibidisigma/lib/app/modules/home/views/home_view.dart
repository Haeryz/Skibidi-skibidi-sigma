import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';
import 'package:skibidiskibidisigma/app/modules/Profile/controllers/profile_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key}); // Remove const

  @override
   Widget build(BuildContext context) {
      // Initialize profile controller
      final ProfileController profileController = Get.put(ProfileController());

      // State to track if description is expanded
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
                      backgroundImage: profileController.profileImage.value != null
                          ? FileImage(profileController.profileImage.value!)
                          : const AssetImage('assets/icon/sigma.png'),
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

                            Get.toNamed(Routes.WIKIPEDIA); //ganti PLAN ke page yang di inginkan

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

                            Get.toNamed(Routes.WIKIPEDIA); //ganti PLAN ke page yang di inginkan

                            Get.toNamed(Routes.PLAN); //ganti PLAN ke page yang di inginkan

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
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) {
              Get.toNamed(Routes.HOME);
            } else if (index == 1) {
              Get.toNamed(Routes.SEARCH);
            } else if (index == 2) {
              Get.toNamed(Routes.PLAN);
            } else {
              print('Feature not available yet');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Rencana',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review),
              label: 'Ulasan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
        ),
      );
    }
  }

  Widget _recommendationCard({required String imagePath, required String title}) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              imagePath,
              height: 100,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
