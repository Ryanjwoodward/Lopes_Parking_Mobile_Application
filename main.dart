///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-16-2023 (created)
///-----------------------------------------------------
///NOTE APPLICATION MUST BE RUN with: flutter run --no-sound-null-safety
/// -----------------------------------------------------

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lopes_parking/screens/signin-page.dart';
import 'package:lopes_parking/screens/signup-page.dart';
import 'package:lopes_parking/screens/home-page.dart';
import 'package:lopes_parking/screens/parking-page.dart';
import 'package:lopes_parking/screens/forgotpassword-page.dart';
import 'package:lopes_parking/screens/account-page.dart';
import 'package:lopes_parking/screens/checkin-page.dart';
import 'package:lopes_parking/screens/update-account-page.dart';
import 'package:lopes_parking/services/authentication-service.dart';
import 'package:provider/provider.dart';

//----------------------------------------------------------
// Main Method
//----------------------------------------------------------
/**
 * This asynchronous method performs three steps.
 * (1) Is to bind the Flutter (SDK) instance of the project to the Widgets of the project (i.e main.MyApp)
 * (2) Waits for the Firebase App (our Firebase app is called 'be-lopes-parking') to return a Future<String> 'success' value
 * (3) Runs the main file (main.dart) classes application (i.e. MyApp Class)
 */
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

//----------------------------------------------------------
// Primary (Main) App class
//----------------------------------------------------------
/**
 *  This class serves as the entry point into the Lopes Parking application.
 *
 *  (1) Creates a key (defines the Widgets state location on the 'WidgetTree') for the Widget
 *  (2) Creates a build context, to reference the state/page by
 *  (3) Creates a connection to the AuthenticationService class (and FirebaseAuth)
 *  (4) Defines all the routes of the application the initial being the Authentication pages (login/sign-up)
 */
class MyApp extends StatelessWidget{

  const MyApp({Key? key}) : super(key : key);

  @override
  Widget build(BuildContext context){
    return MultiProvider(

      providers: [
        Provider<AuthenticationService>(
          create: (_)=> AuthenticationService(FirebaseAuth.instance),
        ),

        StreamProvider(create: (context)=> context.read<AuthenticationService>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
        title: 'Lopes Parking Application',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primaryColor: Color(0xFF512DA8),
        ),
        initialRoute: '/auth',
        routes: {
          '/auth': (context)=> AuthenticationWrapper(),
          '/signin': (context)=> SignInPage(),
          '/signup' : (context)=> SignUpPage(),
          '/home' : (context)=> HomePage(),
          '/resetPassword' : (context)=> ForgotPasswordPage(),
          '/parkingInfo' : (context)=> ParkingPage(),
          '/account' : (context)=> AccountPage(),
          '/checkin' : (context)=> CheckInPage(),
          '/updateaccount' : (context)=> UpdateAccountPage()
        },
      ),


    );
  }
}

//----------------------------------------------------------
//Authentication Wrapper Class
//----------------------------------------------------------
/**
 * This class is what provides the AuthenticationService class with state that can be interacted with
 * by all other widgets in the application. It creates a class-wide context for the current User (firebase)
 */
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    final firebaseUser = context.watch<User?>();

    if(firebaseUser != null){
      return HomePage();
    }
    return SignInPage();
  }
}