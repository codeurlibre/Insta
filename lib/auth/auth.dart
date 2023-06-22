import 'package:flutter/material.dart';
import 'package:instagram_clone_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import 'login_or_register.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
// * User is logged in
          if (snapshot.hasData) {
            return const ResponsiveLayout(
                webScreenLayout: WebScreen(),
                mobileScreenLayout: MobileScreen());
          }

// * User is NOT logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
/*return user != null?const ResponsiveLayout(
        webScreenLayout: WebScreen(),
        mobileScreenLayout: MobileScreen()):const LoginOrRegister();
  }*/
