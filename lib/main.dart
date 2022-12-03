import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginwithfirebase/success.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login with firebase",
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

//initalize firebase
  Future<FirebaseApp> _initalizeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initalizeFirebase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return LoginPage();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  // Login function
  static Future<User?> LoginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseException catch (e) {
      if (e.code == "User-not-found") {
        print("No user found");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passController = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My App Title',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "Login to Your App",
            style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  autocorrect: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter email",
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: Colors.black,
                    ),
                    labelText: "Must valid input",
                    labelStyle: TextStyle(color: Colors.black),
                    //    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _passController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter pass",
                    prefixIcon: Icon(
                      Icons.security,
                      size: 20,
                      color: Colors.black,
                    ),
                    labelText: "Pass must be strong",
                    labelStyle: TextStyle(color: Colors.black),
                    //  border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Don't remember your pass ?",
                  style: TextStyle(
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () async {
                User? user = await LoginUsingEmailPassword(
                    email: _emailController.text,
                    password: _passController.text,
                    context: context);
                if(user!=null)
                  {
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (context) => Success()));
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Success()));
                  }

              },
              fillColor: Colors.blue,
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
