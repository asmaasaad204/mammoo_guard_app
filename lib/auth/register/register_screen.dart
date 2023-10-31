import 'package:facebook/auth/components/custom_text_form_field.dart';
import 'package:facebook/auth/login/login_screen.dart';
import 'package:facebook/dialog_utils.dart';
import 'package:facebook/firebase_utils.dart';
import 'package:facebook/home/home_screen.dart';
import 'package:facebook/home/providers/auth_provider.dart';
import 'package:facebook/models/my_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register screen';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var nameController = TextEditingController(text: 'Asmaa');

  var emailController = TextEditingController(text: 'saadasmaa204@gmail.com');

  var passwordController = TextEditingController(text: '123456');

  var confirmPasswordController = TextEditingController(text: '123456');

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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  CustomTextFormField(
                    label: 'User Name',
                    controller: nameController,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter User Name';
                      }
                      return null;
                    },
                  ),
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
                  CustomTextFormField(
                    label: 'Confirm Password',
                    keyboardType: TextInputType.number,
                    controller: confirmPasswordController,
                    obscureText: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter Confirm Password';
                      }
                      if (text != passwordController.text) {
                        return "Password doesn't match.";
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
                        register();
                      },
                      child: Text(
                        'Register',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ///navigate to login screen
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Text(
                      'Already have an account',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void register() async {
    if (formKey.currentState?.validate() == true) {
      ///register
      ///todo : show loading
      DialogUtils.showLoading(context, 'Loading...');
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        MyUser myUser = MyUser(
          id: credential.user?.uid ?? '',
          name: nameController.text,
          email: emailController.text,
        );
        await FirebaseUtils.addUserToFireStore(myUser);
        var authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updateUser(myUser);

        ///todo : hide loading
        DialogUtils.hideLoading(context);

        ///todo : show messege
        DialogUtils.showMessage(context, 'Register Successfully',
            title: 'Success', posActionName: 'OK', posAction: () {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        });
        print('register successfully');
        print(credential.user?.uid ?? '');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ///todo : hide loading
          DialogUtils.hideLoading(context);

          ///todo : show messege
          DialogUtils.showMessage(context, 'The password provided is too weak.',
              title: 'Error', posActionName: 'OK');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          ///todo : hide loading
          DialogUtils.hideLoading(context);

          ///todo : show messege
          DialogUtils.showMessage(
              context, 'The account already exists for that email.',
              title: 'Error', posActionName: 'OK');
          print('The account already exists for that email.');
        }
      } catch (e) {
        ///todo : hide loading
        DialogUtils.hideLoading(context);

        ///todo : show messege
        DialogUtils.showMessage(context, e.toString(),
            title: 'Error', posActionName: 'OK');
        print(e);
      }
    }
  }
}
