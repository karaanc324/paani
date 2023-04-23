import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import '../service/database_service.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({Key? key}) : super(key: key);
  TextEditingController fullAddressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();

  // final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return  Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) {
            return Dialog(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  top: 20), // add padding to adjust icon
                              child: Icon(Icons.person)),
                          border: UnderlineInputBorder(),
                          labelText: 'Name'),
                    ),
                    TextFormField(
                      controller: contactController,
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  top: 20), // add padding to adjust icon
                              child: Icon(Icons.contact_phone)),
                          border: UnderlineInputBorder(),
                          labelText: 'Contact'),
                    ),
                    TextFormField(
                      controller: fullAddressController,
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  top: 20), // add padding to adjust icon
                              child: Icon(Icons.location_city)),
                          border: UnderlineInputBorder(),
                          labelText: 'Full Address'),
                    ),
                    TextFormField(
                      controller: pincodeController,
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  top: 20), // add padding to adjust icon
                              child: Icon(Icons.pin)),
                          border: UnderlineInputBorder(),
                          labelText: 'Pincode'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          print("----opnpressed");
                          print(authService.clearCart());
                          DatabaseService(uid: authService.getCurrentUser().uid)
                              .addAddress(nameController.text, contactController.text,
                              fullAddressController.text, pincodeController.text);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Address added"),
                          ));
                        },
                        child: const Text('Add Address')),
                  ],
                )
            );
          });
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: authService.getAddresses(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          }
          print(snapshot.connectionState);
            List<dynamic> myArray = snapshot.data['addresses'];

            return ListView.builder(
              itemCount: myArray.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(myArray[index]['name']),
                );
              },
            );
          }

      ),
    );
  }
}
