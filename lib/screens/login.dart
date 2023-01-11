import 'package:flutter/material.dart';
import 'package:paani/screens/customer_dashboard.dart';
import 'package:paani/screens/signup.dart';
import 'package:paani/screens/vendor_dashboard.dart';

import '../service/auth_service.dart';
import '../shared/loading.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  final AuthService authService = AuthService();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : Scaffold(
        body: Form(
            child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Login", style: TextStyle(fontSize: 32)),
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
              controller: passwordController,
              decoration: const InputDecoration(
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(
                          top: 20), // add padding to adjust icon
                      child: Icon(Icons.person)),
                  border: UnderlineInputBorder(),
                  labelText: 'password'),
            ),
            ElevatedButton(
                onPressed: () {
                  _onLogin();
                },
                child: const Text('Login')),
            InkWell(
                child: const Text('Dont have an account? Signup'),
                onTap: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()))}),
          ],
        )
      ],
    )));
  }

  login() {
  }

  void _onLogin() {
    setState(() {
      isLoading = true;
    });
      authService
          .login(emailController.text, passwordController.text)
          .then((result) async {
        if (result != null) {
          authService.checkUserRole(result).then((role) {
            if (role == "consumer") {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerDashboard()));
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VendorDashboard()));
            }
          });
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CustomerDashboard()));
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Username or password seems wrong"),
          ));
        }
      });
    }
}
