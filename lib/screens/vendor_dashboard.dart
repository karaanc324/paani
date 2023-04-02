import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:paani/modal/puser.dart';
import 'package:paani/screens/login.dart';
import 'package:paani/service/database_service.dart';

import '../service/auth_service.dart';
import 'add_product.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({Key? key}) : super(key: key);

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  int selectedIndex = 0;

  final _screens = [CustomerDash(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[selectedIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct()));
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class CustomerDash extends StatelessWidget {
  CustomerDash({
    Key? key,
  }) : super(key: key);
  final AuthService authService = AuthService();

  get orientation => null;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextFormField(
              decoration: const InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(
                          top: 20), // add padding to adjust icon
                      child: Icon(Icons.search)),
                  border: UnderlineInputBorder(),
                  labelText: 'search product'),
            )),
            // Expanded(child: ElevatedButton(child: Icon(Icons.search), onPressed: () {
            // },))
          ],
        ),
        Container(
          child: Expanded(
            child: FutureBuilder(
              future: authService.getProductsOfVendor(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 3),
                        itemBuilder: (BuildContext context, int index) {
                          // PUser pUser = jsonDecode(snapshot.data[index]);
                          Map<String, dynamic> values = Map<String, dynamic>.from(snapshot.data[index]);
                          return Card(
                            child: InkResponse(
                              child: Text(values['name']),
                            ),
                          );
                        });
                  } else {
                    return const Text("no products added");
                  }
                  // return Text(snapshot.data.toString());
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text("No data");
                }
                return CircularProgressIndicator();
                // return Text("lol");
              },
            ),
          ),
        )
      ],
    );
  }
}

class Settings extends StatelessWidget {
  Settings({
    Key? key,
  }) : super(key: key);
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            authService.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false);
          },
          title: Text('Signout'),
        )
      ],
    );
  }
}
