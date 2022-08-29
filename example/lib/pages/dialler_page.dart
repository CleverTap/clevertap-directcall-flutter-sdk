import 'package:clevertap_directcall_flutter_example/pages/registration_page.dart';
import 'package:flutter/material.dart';

class DiallerPage extends StatefulWidget {
  static const routeName = '/dialler';

  final String loggedInCuid;

  const DiallerPage({Key? key, required this.loggedInCuid}) : super(key: key);

  @override
  State<DiallerPage> createState() => _DiallerPageState();
}

class _DiallerPageState extends State<DiallerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Screen'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              'Welcome: ${widget.loggedInCuid}',
              // textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Receiver CUID',
              ),
            ),
            const SizedBox(height: 30),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Context of the call',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              child: const Text('Initiate VOIP Call'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RegistrationPage.routeName);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
