import 'package:facebook/auth/components/custom_text_form_field.dart';
import 'package:facebook/auth/register/register_screen.dart';
import 'package:facebook/firebase_utils.dart';
import 'package:facebook/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dialog_utils.dart';
import '../../home/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController(text: 'saadasmaa204@gmail.com');

  var passwordController = TextEditingController(text: '123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/main_background.png',
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  CustomTextFormField(
                    label: 'Email Address',
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
                    label: 'Password',
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        login();
                      },
                      child: Text(
                        'Login',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Don't have an account?",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        ///navigate to register
                        Navigator.of(context)
                            .pushNamed(RegisterScreen.routeName);
                      },
                      child: Text(
                        'SignUp',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                      ),
                    ),
                  ]),
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
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(user);

        ///todo : hide loading
        DialogUtils.hideLoading(context);

        ///todo : show messege
        DialogUtils.showMessage(context, 'Login Successfully',
            title: 'Success', posActionName: 'OK', posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ///todo : hide loading
          DialogUtils.hideLoading(context);

          ///todo : show messege
          DialogUtils.showMessage(context, 'No user found for that email.',
              title: 'Error', posActionName: 'OK');
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          ///todo : hide loading
          DialogUtils.hideLoading(context);

          ///todo : show messege
          DialogUtils.showMessage(
              context, 'Wrong password provided for that user.',
              title: 'Error', posActionName: 'OK');
          print('Wrong password provided for that user.');
        }
      } catch (e) {
        ///todo : hide loading
        DialogUtils.hideLoading(context);

        ///todo : show messege
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
