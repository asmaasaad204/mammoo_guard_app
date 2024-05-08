import 'package:facebook/auth/components/custom_text_form_field.dart';
import 'package:facebook/auth/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../dialog_utils.dart';
import '../../firebase_utils.dart';
import '../../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(300),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 20,
          flexibleSpace: Container(
            child: Stack(
              children: [
                Image.asset(
                  "assets/images/photo_logiin9.jpg",
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 120, right: 120, left: 20),
                  child: Image.asset(
                    "assets/images/photo_logoGuuard2.jpg",
                    width: 200,
                    height: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    label: 'Email ',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter Email Address';
                      }
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text);
                      if (!emailValid) {
                        return 'Please enter a valid Email';
                      }
                      return null;
                    },
                  ),
                  CustomTextFormField(
                    label: "Password",
                    keyboardType: TextInputType.number,
                    controller: passwordController,
                    obscureText: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter Password';
                      }
                      if (text.length < 6) {
                        return 'Password should be at least 6 chars.';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      elevation: 5.0,
                      color: Color(0xffF8CAE4),
                      padding: const EdgeInsets.symmetric(
                          vertical: 17, horizontal: 165),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      onPressed: () {
                        login();
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create New Account?',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 22),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              ///navigate to register
                              Navigator.of(context)
                                  .pushNamed(RegisterScreen.routeName);
                            },
                            child: Text('Sign Up',
                                style: TextStyle(
                                    color: Color(0xffe13495),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void login() async {
    if (formKey.currentState?.validate() == true) {
      ///login
      DialogUtils.showLoading(context, 'Loading...');
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        var user = await FirebaseUtils.readUserFromFireStore(
            credential.user?.uid ?? '');
        if (user == null) {
          return;
        }

        ///mammoGaurd : hide loading
        DialogUtils.hideLoading(context);

        ///mammoGaurd : show messege
        DialogUtils.showMessage(context, 'Login Successfully',
            title: 'Success', posActionName: 'OK', posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ///mammoGaurd : hide loading
          DialogUtils.hideLoading(context);

          ///mammoGaurd : show messege
          DialogUtils.showMessage(context, 'No user found for that email.',
              title: 'Error', posActionName: 'OK');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          ///mammoGaurd : hide loading
          DialogUtils.hideLoading(context);

          ///mammoGaurd : show messege
          DialogUtils.showMessage(
              context, 'Wrong password provided for that user.',
              title: 'Error', posActionName: 'OK');
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        ///mammoGaurd : hide loading
        DialogUtils.hideLoading(context);

        ///mammoGaurd : show messege
        DialogUtils.showMessage(
          context,
          e.toString(),
          title: 'Error',
          posActionName: 'OK',
        );
        print(e.toString());
      }
    }
  }
}
