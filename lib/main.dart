import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EmailForm(),
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({Key? key}) : super(key: key);

  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _districtController = TextEditingController();
  //List<String> _districts = ['district1', 'district2', 'district3'];
  @override
  void dispose() {
    _emailController.dispose();
    _postalCodeController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Form'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your email address:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'example@example.com',
                ),
                validator: (value) {
                  // Check if this field is empty
                  if (value == null || value.isEmpty) {
                    return 'Please write your Email';
                  }

                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return "Invalid Email Format";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter Zip Code:',
                style: TextStyle(fontSize: 18),
              ),
              TextFormField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '1234567',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  if (!RegExp(r'^[1-9]\d{4}$').hasMatch(value)) {
                    return 'Invalid Zip Code Format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Province:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    TextSpan(
                      text: ' chiangmai',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const Text(
                'District',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              /*Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _districts.where((String option) {
                    return option.contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _districtController.text = selection;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  _districtController.text = textEditingController.text;
                  return TextFormField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: 'Select district',
                    ),
                  );
                },
              ), const SizedBox(height: 10),*/
              ElevatedButton(
                onPressed: () async {
                  String message;
                  if (_formKey.currentState!.validate()) {
                    try {
                      await FirebaseFirestore.instance.collection('form').add({
                        'email': _emailController.text,
                        'zip': _postalCodeController.text,
                      });
                      message = 'Feedback sent successfully';
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(message)));
                    } catch (e) {
                      message = 'Error when sending feedback';
                    }
                  }
                },
                child: const Text('Send Email'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
