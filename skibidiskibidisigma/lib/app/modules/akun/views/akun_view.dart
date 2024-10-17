import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/akun_controller.dart';

import 'package:skibidiskibidisigma/app/modules/authentication/views/authentication_view.dart';

class akunView extends GetView<akunController> {
  const akunView({super.key});
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile UI',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun'),
        backgroundColor: Colors.orange[200],
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 249, 248, 248),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'pfp_placeholder.png'), // Replace with actual image
                ),
                SizedBox(height: 10),
                Text(
                  'Hallo, M. Aura Sigma',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16),
              children: [
                _buildGridItem(Icons.settings, 'Pengaturan'),
                _buildGridItem(Icons.bookmark, 'Disimpan'),
                _buildGridItem(Icons.payment, 'Transaksi'),
                _buildGridItem(Icons.question_answer, 'FAQ'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () {
                // Menampilkan dialog konfirmasi sebelum keluar
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Konfirmasi'),
                      content: Text('Apakah Anda yakin ingin keluar?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Tutup dialog
                          },
                          child: Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Tutup dialog
                            // Navigasi ke halaman AuthenticationView
                            Get.to(() => AuthenticationView());
                          },
                          child: Text('Ya'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Keluar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.black),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        onTap: (index) {
          // Handle tab change
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

  Widget _buildGridItem(IconData icon, String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Handle navigation for each section
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
