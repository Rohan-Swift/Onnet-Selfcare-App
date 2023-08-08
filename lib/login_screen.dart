import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'API Classes/api.dart';
import 'box_summary.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode text = FocusNode();
  FocusNode password = FocusNode();
  TextEditingController textField = TextEditingController();
  TextEditingController passField = TextEditingController();
  String uName = '';
  String pass = '';
  int result = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        text.unfocus();
        password.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log in'),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 28.0, right: 28.0, left: 28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/onnetlogo.png',
                      height: 50,
                      color: Colors.deepPurple,
                    ),
                    SizedBox(
                      height: 150,
                      width: 200,
                      child: Image.asset(
                        'assets/images/login.png',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    const SizedBox(
                      width: 300,
                      child: Text(
                        'Enter your login details below to sign in and watch your favorite content !!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: TextField(
                        controller: textField,
                        focusNode: text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                          floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                          labelText: 'Username',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 350,
                      height: 50,
                      child: TextField(
                        obscureText: true,
                        controller: passField,
                        focusNode: password,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: Colors.orange),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                          floatingLabelStyle: TextStyle(color: Colors.deepPurple),
                           labelText: 'Password',
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            AlertDialog alert = AlertDialog(
                              title: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/onnetshield.png',
                                    height: 25,
                                    width: 25,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text('Onnet Systems'),
                                ],
                              ),
                              content: const Text(
                                  'Please contact your administrator'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                              ],
                            );

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.deepPurple,
                        ),
                      ),
                      onPressed: () async {
                        uName = textField.text;
                        pass = passField.text;
                        if (uName.isEmpty || pass.isEmpty) {
                          _showAlertDialog(context);
                        } else {
                          if (kDebugMode) {
                            print(uName);
                            print(pass);
                          }
                        }
                        result = await Login.loginUser(uName, pass);
                        if (result == 1) {
                          if (!mounted) return;
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const BoxSummary()));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Great Success',
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Invalid credentials. Please try again !!',
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('New User?'),
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.deepPurple,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Signup()));
                          },
                          child: const Text('Signup'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Image.asset(
            'assets/images/onnetshield.png',
            height: 25,
            width: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text('Onnet Systems'),
        ],
      ),
      content: const Text('Username or Password cannot be empty'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            text.requestFocus();
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
