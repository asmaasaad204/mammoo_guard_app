import 'package:facebook/auth/login/login_screen.dart';
import 'package:facebook/auth/register/register_screen.dart';
import 'package:facebook/my_theme.dart';
import 'package:facebook/screens/begin_screen.dart';
import 'package:facebook/screens/calenders_period.dart';
import 'package:facebook/screens/change_password.dart';
import 'package:facebook/screens/checkup_screen.dart';
import 'package:facebook/screens/contactUs_screen.dart';
import 'package:facebook/screens/diagnosis.dart';
import 'package:facebook/screens/forgetPassword_screen.dart';
import 'package:facebook/screens/help_screen.dart';
import 'package:facebook/screens/hend.dart';
import 'package:facebook/screens/hoda.dart';
import 'package:facebook/screens/managing_stress.dart';
import 'package:facebook/screens/problem_screen.dart';
import 'package:facebook/screens/risk_factors_screen.dart';
import 'package:facebook/screens/self_examination.dart';
import 'package:facebook/screens/settings.dart';
import 'package:facebook/screens/simona.dart';
import 'package:facebook/screens/success_screen.dart';
import 'package:facebook/screens/talking_children.dart';
import 'package:facebook/screens/talking_partner.dart';
import 'package:facebook/screens/talking_relatives.dart';
import 'package:facebook/taps/pages_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        CheckUpScreen.routeName: (context) => CheckUpScreen(),
        SuccessScreen.routeName: (context) => SuccessScreen(),
        CalenderPeriod.routeName: (context) => CalenderPeriod(),
        DiagnosisScreen.routeName: (context) => DiagnosisScreen(),
        PagesScreen.routeName: (context) => PagesScreen(),
        ContactUsScreen.routeName: (context) => ContactUsScreen(),
        GetHelp.routeName: (context) => GetHelp(),
        Settings.routeName: (context) => Settings(),
        ProblemScreen.routeName: (context) => ProblemScreen(),
        ForgetPassword.routeName: (context) => ForgetPassword(),
        RiskFactors.routeName: (context) => RiskFactors(),
        BeginScreen.routeName: (context) => BeginScreen(),
        Hind.routeName: (context) => Hind(),
        Hoda.routeName: (context) => Hoda(),
        Simona.routeName: (context) => Simona(),
        ChangePassword.routeName: (context) => ChangePassword(),
        TalkingPartner.routeName: (context) => TalkingPartner(),
        TalkingChildren.routeName: (context) => TalkingChildren(),
        TalkingRelatives.routeName: (context) => TalkingRelatives(),
        ManagingStress.routeName: (context) => ManagingStress(),
        SelfExamination.routeName: (context) => SelfExamination(),
      },
      theme: MyTheme.lightTheme,
    );
  }
}
