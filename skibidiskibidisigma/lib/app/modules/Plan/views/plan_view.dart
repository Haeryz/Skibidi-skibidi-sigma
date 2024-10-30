import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skibidiskibidisigma/app/modules/plan/views/appColor.dart';
import 'package:skibidiskibidisigma/app/modules/plan/views/background.dart';
import 'package:skibidiskibidisigma/app/modules/plan/views/create_plan_screen.dart';
import '../controllers/plan_controller.dart';

class PlanView extends GetView<PlanController> {
  PlanView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final AppColor appColor = AppColor();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.colorPrimary,
      appBar: AppBar(
        title: Text('Trip List'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Color.fromARGB(255, 247, 247, 247),
        ),
        onPressed: () async {
          bool? result = await Get.to(() => CreatePlanScreen(isEdit: false));
          if (result != null && result) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Trip has been created')),
            );
            controller.fetchTasks(); // Update trip list
          }
        },
        backgroundColor: appColor.colorTertiary,
      ),
    );
  }

  Widget _buildWidgetListTodo(
      double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              'Trip List',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('trips')
                  .orderBy('date')
                  .snapshots(), // Change to 'trips'
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    var document = snapshot.data!.docs[index];
                    Map<String, dynamic> trip =
                        document.data() as Map<String, dynamic>;
                    String strDate = trip['date'];
                    return Card(
                      child: ListTile(
                        title: Text(trip['name']),
                        subtitle: Text(
                          trip['description'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: appColor.colorSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${int.parse(strDate.split(' ')[0])}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              strDate.split(' ')[1],
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ];
                          },
                          onSelected: (String value) async {
                            if (value == 'edit') {
                              bool? result =
                                  await Get.to(() => CreatePlanScreen(
                                        isEdit: true,
                                        documentId: document.id,
                                        name: trip['name'],
                                        description: trip['description'],
                                        date: trip['date'],
                                      ));
                              if (result != null && result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Trip has been updated')),
                                );
                                controller.fetchTasks(); // Update trip list
                              }
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(
                                  context, document.id);
                            }
                          },
                          child: Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Trip'),
          content: Text('Are you sure you want to delete this trip?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await firestore
                    .collection('trips')
                    .doc(documentId)
                    .delete(); // Change to 'trips'
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Trip has been deleted')),
                );
                controller.fetchTasks(); // Update trip list
              },
            ),
          ],
        );
      },
    );
  }
}
