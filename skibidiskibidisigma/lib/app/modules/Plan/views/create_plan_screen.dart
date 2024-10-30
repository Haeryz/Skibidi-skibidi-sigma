import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/plan_controller.dart';
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
            decoration: InputDecoration(labelText: 'Name'),
            style: TextStyle(fontSize: 18.0),
          ),
          TextField(
            controller: controller.controllerStartLocation,
            decoration: InputDecoration(labelText: 'Start Location'),
            style: TextStyle(fontSize: 18.0),
          ),
          TextField(
            controller: controller.controllerDestination,
            decoration: InputDecoration(labelText: 'Destination'),
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormSecondary(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
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
            style: TextStyle(fontSize: 18.0),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: controller.controllerDate,
            decoration: const InputDecoration(
              labelText: 'Date',
              suffixIcon: Icon(Icons.today),
            ),
            style: TextStyle(fontSize: 18.0),
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
            style: TextStyle(fontSize: 18.0),
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
        onPressed: () => controller.saveTask(isEdit, documentId),
      ),
    );
  }
}
