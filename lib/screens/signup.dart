import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paani/service/auth_service.dart';

import '../shared/loading.dart';
import 'customer_dashboard.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;
  String role = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            body: Form(
                child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Signup", style: TextStyle(fontSize: 32)),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                top: 20), // add padding to adjust icon
                            child: Icon(Icons.person)),
                        border: UnderlineInputBorder(),
                        labelText: 'name'),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                top: 20), // add padding to adjust icon
                            child: Icon(Icons.person)),
                        border: UnderlineInputBorder(),
                        labelText: 'email'),
                  ),
                  TextFormField(
                    controller: contactController,
                    decoration: const InputDecoration(
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                top: 20), // add padding to adjust icon
                            child: Icon(Icons.person)),
                        border: UnderlineInputBorder(),
                        labelText: 'contact'),
                  ),
                  const Text(
                    'Role',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                            title: Text("Vendor"),
                            value: "vendor",
                            groupValue: role,
                            onChanged: (value) {
                              setState(() {
                                role = value.toString();
                              });
                            }),
                      ),
                      Expanded(
                        child: RadioListTile(
                            title: Text("Consumer"),
                            value: "consumer",
                            groupValue: role,
                            onChanged: (value) {
                              setState(() {
                                role = value.toString();
                              });
                            }),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                top: 20), // add padding to adjust icon
                            child: Icon(Icons.person)),
                        border: UnderlineInputBorder(),
                        labelText: 'password'),
                  ),
                  TextFormField(
                    controller: confPasswordController,
                    decoration: const InputDecoration(
                        prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                top: 20), // add padding to adjust icon
                            child: Icon(Icons.person)),
                        border: UnderlineInputBorder(),
                        labelText: 'confirm password'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _onSignup();
                      },
                      child: const Text('Signup')),
                  InkWell(
                      child: const Text('Already have an account? Login'),
                      onTap: () => {Navigator.pop(context)}),
                ],
              )
            ],
          )));
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onSignup() {
    setState(() {
      isLoading = true;
    });
    if (passwordController.text == confPasswordController.text) {
      authService
          .signup(nameController.text, emailController.text,
              contactController.text, passwordController.text, role)
          .then((result) async {
        if (result != null) {
          Navigator.pop(context);
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error while registering"),
          ));
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords do not match"),
      ));
    }
  }
}
