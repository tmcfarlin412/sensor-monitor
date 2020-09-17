import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'cache.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isDynamicLinkListenerAdded = false;
  bool flagIsDynamicLinkListenerAdded = false;
  bool isUserLoggedIn = false;
  bool flagIsUserLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initDynamicLinks();
    initFirebaseAuth();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigateIfReady() async {
    if (flagIsUserLoggedIn && flagIsDynamicLinkListenerAdded) {
      final PendingDynamicLinkData data =
      await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {

        // If deep link, navigate
        flagIsDynamicLinkListenerAdded = true;
        Navigator.pushNamed(context, deepLink.path,
            arguments: deepLink.queryParameters);

      } else {

        // Otherwise, push correct page
        if (isUserLoggedIn) {
          Navigator.pushNamed(context, "/view_sensor_piezo");
        } else {
          Navigator.pushNamed(context, "/view_sensor_piezo");
        }

      }
    }
  }

  void initDynamicLinks() async {
    if (!isDynamicLinkListenerAdded) {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
            final Uri deepLink = dynamicLink?.link;
            if (deepLink != null) {
              Navigator.pushNamed(context, deepLink.path,
                  arguments: deepLink.queryParameters);
            }
          }, onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      });

      isDynamicLinkListenerAdded = true;
      flagIsDynamicLinkListenerAdded = true;
    }
    navigateIfReady();
  }

  void initFirebaseAuth() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    Cache.currentUser = FirebaseAuth.instance.currentUser;

    if (Cache.currentUser == null) {
      isUserLoggedIn = false;
    } else {
      isUserLoggedIn = true;
      DocumentReference userInfoRef = FirebaseFirestore.instance.collection(
          'profiles').doc(Cache.currentUser.uid);
      if (userInfoRef != null) {
        Cache.currentUserProfile = await userInfoRef.get();
      }
    }

    flagIsUserLoggedIn = true;
    navigateIfReady();
  }
}
