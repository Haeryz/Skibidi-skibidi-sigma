import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/authentication/controllers/authentication_controller.dart';
import 'package:skibidiskibidisigma/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put() to instantiate the controller
    final ProfileController profileController = Get.find<ProfileController>();
    final AuthenticationController authController =
        Get.find<AuthenticationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                Obx(() => CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          profileController.profileImage.value != null
                              ? FileImage(profileController.profileImage.value!)
                              : profileController.profileImageUrl.value != null
                                  ? NetworkImage(profileController
                                      .profileImageUrl
                                      .value!) // Use NetworkImage for URL
                                  : const AssetImage(
                                          'assets/icon/pfp_placeholder.png')
                                      as ImageProvider,
                    )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Call the pickImage method from the controller
                      profileController.pickImage();
                    },
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 35),
            const Text(
                textAlign: TextAlign.left,
                'Nama',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                    hintText: 'M. Aura Sigma',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0)),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              textAlign: TextAlign.left,
              'Kota domisili saat ini',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                    hintText: 'Malang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0)),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              textAlign: TextAlign.left,
              'Situs web',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Tambahkan link web',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              textAlign: TextAlign.left,
              'Tentang anda',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: TextField(
                obscureText: false,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    hintText: 'Dingin tetapi tidak kejam',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 20.0)),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.HOME);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15.0,
                          horizontal: 20.0,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: const Text(
                      'Simpan',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ))),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  authController
                      .logout(); // call the logout function from the controller
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Logout', style: TextStyle(color: Colors.white)),
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
