import 'package:flutter/material.dart';

// TODO 1: Import reference to async and shared_preferences
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Profile'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  // TODO 2: Insert TextEditingController
  final _nameTextEditingCtrl = TextEditingController();
  final _emailTextEditingCtrl = TextEditingController();

  Future<void> _loadPreference() async {
    // Create an instance of shared preference
    final prefs = await SharedPreferences.getInstance();
    _nameTextEditingCtrl.text = prefs.getString('name') ?? '';
    _emailTextEditingCtrl.text = prefs.getString('email') ?? '';
  }

  Future<void> _savePreference() async {
    // Create an instance of shared preference
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameTextEditingCtrl.text);
    prefs.setString('email', _emailTextEditingCtrl.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadPreference();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameTextEditingCtrl.dispose();
    _emailTextEditingCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              spacing: 8.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _nameTextEditingCtrl,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hint: Text('Your name here'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
                      return 'Name can only contain letters, spaces, hyphens and apostrophes';
                    }
                    if (value.trim().length < 2) {
                      return 'Name must be at least 2 characters long';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailTextEditingCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hint: Text('Your email here'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    const String emailPattern =
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                    if (!RegExp(emailPattern).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                      _savePreference();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
