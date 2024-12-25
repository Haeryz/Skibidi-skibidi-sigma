import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/Plan/controllers/plan_controller.dart';
import 'package:skibidiskibidisigma/app/modules/plan/views/locationAutocomplete.dart';
import '../views/appColor.dart';
import '../views/background.dart';

class CreatePlanScreen extends StatelessWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String description;
  final String date;
  final String startLocation;
  final String destination;
  final String arrivalDate;

  CreatePlanScreen({
    required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.description = '',
    this.date = '',
    this.startLocation = '',
    this.destination = '',
    this.arrivalDate = '',
  });

  final PlanController controller = Get.put(PlanController());

  @override
  Widget build(BuildContext context) {
    controller.initForm(
      isEdit: isEdit,
      name: name,
      description: description,
      date: date,
      startLocation: startLocation,
      destination: destination,
      arrivalDate: arrivalDate,
    );

    return Scaffold(
      backgroundColor: AppColor().colorPrimary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildWidgetFormPrimary(),
                    const SizedBox(height: 16.0),
                    _buildWidgetFormSecondary(context),
                    const SizedBox(height: 16.0),
                    Obx(() => controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColor().colorTertiary),
                            ),
                          )
                        : _buildWidgetButtonCreateTask()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetFormPrimary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back, color: Colors.grey[800]),
          ),
          const SizedBox(height: 16.0),
          Text(
            isEdit ? 'Edit\nTask' : 'Create\nNew Task',
            style: TextStyle(color: Colors.grey[800], fontSize: 24.0),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: controller.controllerName,
            decoration: const InputDecoration(labelText: 'Name'),
            style: const TextStyle(fontSize: 18.0),
          ),
          LocationAutocomplete(
            controller: controller.controllerStartLocation,
            suffixIcon: IconButton(
                onPressed: () {
                  controller.setStartLocationFromGPS();
                },
                icon: const Icon(Icons.pin_drop_rounded)),
          ), // Use the autocomplete widget here
          LocationAutocomplete(
            controller: controller.controllerDestination,
            suffixIcon: IconButton(
                onPressed: () {
                  Get.snackbar('test', 'balls');
                },
                icon: const Icon(Icons.pin_drop_rounded)),
          ), // Use the autocomplete widget here
        ],
      ),
    );
  }

  Widget _buildWidgetFormSecondary(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 247, 247, 247),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: controller.controllerDescription,
            decoration: const InputDecoration(
              labelText: 'Description',
              suffixIcon: Icon(Icons.description),
            ),
            style: const TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: controller.controllerDate,
            decoration: const InputDecoration(
              labelText: 'Date',
              suffixIcon: Icon(Icons.today),
            ),
            style: const TextStyle(fontSize: 18.0),
            readOnly: true,
            onTap: () => controller.selectDate(context),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: controller.controllerArrivalDate,
            decoration: const InputDecoration(
              labelText: 'Arrival Date',
              suffixIcon: Icon(Icons.event),
            ),
            style: const TextStyle(fontSize: 18.0),
            readOnly: true,
            onTap: () => controller.selectArrivalDate(context),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetButtonCreateTask() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor().colorTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Text(isEdit ? 'UPDATE TASK' : 'CREATE TASK'),
        onPressed: () async {
          controller.saveTask(isEdit, documentId); 
          Get.back();
        } 
      ),
    );
  }
}
