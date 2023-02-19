import 'package:flutter/material.dart';
import 'package:paani/service/database_service.dart';

import '../service/auth_service.dart';

class AddProduct extends StatelessWidget {
  AddProduct({Key? key}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
          children: [
            const Center(
                child: Text(
                  "Add product",
                  style: TextStyle(fontSize: 28),
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              top: 20), // add padding to adjust icon
                          child: Icon(Icons.add_box)),
                      border: UnderlineInputBorder(),
                      labelText: 'name'),
                ),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              top: 20), // add padding to adjust icon
                          child: Icon(Icons.person)),
                      border: UnderlineInputBorder(),
                      labelText: 'type'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              top: 20), // add padding to adjust icon
                          child: Icon(Icons.person)),
                      border: UnderlineInputBorder(),
                      labelText: 'description'),
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(
                              top: 20), // add padding to adjust icon
                          child: Icon(Icons.person)),
                      border: UnderlineInputBorder(),
                      labelText: 'price'),
                ),
                ElevatedButton(
                    onPressed: () {
                      DatabaseService(uid: authService.getCurrentUser().uid)
                          .addProduct(nameController.text, typeController.text,
                          descriptionController.text, int.parse(priceController.text));
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Product added"),
                      ));
                    },
                    child: const Text('Add Product')),
              ],
            )
          ],
        ),
      ),
    );
  }
}