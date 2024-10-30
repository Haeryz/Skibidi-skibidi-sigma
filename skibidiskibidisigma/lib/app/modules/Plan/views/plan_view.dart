import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/plan_controller.dart';

class PlanView extends GetView<PlanController> {
  const PlanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PlanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
