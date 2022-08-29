import 'package:clevertap_directcall_flutter/plugin/clevertap_directcall_flutter.dart';
import 'package:clevertap_directcall_flutter_example/pages/dialler_page.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  static const routeName = '/registration';

  const RegistrationPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _clevertapDirectcallFlutterPlugin = ClevertapDirectcallFlutter();
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Call'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'USER-REGISTRATION',
              // textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'assets/clevertap-logo.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                hintText: 'Username or email',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, DiallerPage.routeName,
                    arguments: {"loggedInCuid" : userNameController.text});
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Register and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
