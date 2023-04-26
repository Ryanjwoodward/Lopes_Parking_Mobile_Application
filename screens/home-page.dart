import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lopes_parking/services/authentication-service.dart';
import 'package:provider/provider.dart';

import '../services/authentication-service.dart';

///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-16-2023
///-----------------------------------------------------
///

/*-
GREAT SOURCE FOR STREAM BUILDER:
https://stackoverflow.com/questions/57093907/how-to-get-data-from-firestore-document-fields-in-flutter#:~:text=This%20is%20how%20I%20get%20the%20data%3A%20Firestore.instance.collection,output%3A%20flutter%3A%20Values%20from%20db%3A%20Instance%20of%20%27DocumentSnapshot%27.
/-------------------------------------------------------*/


/**
 * HomePage Widget Defintion. Where the State of this page is instantiated
 */
class HomePage extends StatefulWidget {
  /// Key defines the pages location in the 'wdiget-tree'
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

/**
 * This State class defines the state and attributes of the Homepage Class
 */
class _HomePageState extends State<HomePage>{

  late User user; /// This field represents a FirebaseAuth User
  late String auth_id; ///This field represents the User AuthID

  /**
   * This method creates the state of the AccountPage Class and instantiated all
   * variables
   */
  @override
  void initState(){
    setState((){
      /// This instantiates the user to be the active/current Firebase Auth user
      /// thatis logged in to the application
      user = context.read<AuthenticationService>().getUser()!;
      auth_id = user.uid;
    });
    super.initState();
  }

  /**
   * THis method build the (context, or body) of the widget itself
   */
  @override
  Widget build(BuildContext context){

    ///This scaffold defines the area of the entire body of the HomePage - Page
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),

      /**------------------------------------------
      // Top Bar Portion of the Mobile Page
      //-------------------------------------------*/
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF512DA8),
        title: Text(
          'Grand Canyon University',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),


      /**------------------------------------------
      // Body Portion of the Page
      //-------------------------------------------*/
      body: Column(
        children: [
          SizedBox(height:30),
          Center(
            child: user!=null ?
            Image.asset('assets/lp-logo-horiz.png', height: 150, width: 280,): Container(),
          ),

          ///Stream Builders are used to interact with streams from the Databases
          ///Specifically the Firestore databases
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream:  FirebaseFirestore
                .instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid) // 👈 Your document id change accordingly
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              Map<String, dynamic> data =
              snapshot.data!.data()! as Map<String, dynamic>;
              return
                Column(
                  children: [
                    Text("Welcome, ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                    Text(data['first_name'], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF512DA8)),)

                  ],
                );
            },
          ),
          
          
          
          SizedBox(height: 20,),/// Added to provided padding between widgets

/**-----------------------------------------------------------------------------------------------
//    DATA PAGE BUTTON
-----------------------------------------------------------------------------------------------*/
          Container(
              width: 300,
              height: 40,
              child: ElevatedButton(
                  child: Text('Parking Information'),
                  onPressed: ()=> Navigator.pushNamed(context, '/parkingInfo'),
                  style: ElevatedButton.styleFrom(
                      elevation: 6,
                      primary: Color(0xFF512DA8),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Color(0xFF512DA8))
                      )
                  )
              )
          ),

          SizedBox(height: 10), /// Added to provided padding between widgets

/**-----------------------------------------------------------------------------------------------
//    Check-In/Out PAGE BUTTON
//-----------------------------------------------------------------------------------------------*/
          Container(
              width: 300,
              height: 40,
              child: ElevatedButton(
                  child: Text('Check-In/Check-Out'),
                  onPressed: ()=> Navigator.pushNamed(context, '/checkin'),
                  style: ElevatedButton.styleFrom(
                      elevation: 6,
                      primary: Color(0xFF512DA8),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Color(0xFF512DA8))
                      )
                  )
              )
          ),

          SizedBox(height: 30), /// Added to provided padding between widgets



/**-----------------------------------------------------------------------------------------------
//    ACCOUNT PAGE BUTTON
//-----------------------------------------------------------------------------------------------*/
          Container(
              width: 300,
              height: 40,
              child: ElevatedButton(
                  child: Text('Your Account'),
                  onPressed: ()=> Navigator.pushNamed(context, '/account'),
                  style: ElevatedButton.styleFrom(
                      elevation: 6,
                      primary: Color(0xFF512DA8),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Color(0xFF512DA8))
                      )
                  )
              )
          ),

          SizedBox(height: 10),/// Added to provided padding between widgets

/**-----------------------------------------------------------------------------------------------
//    LOGOUT BUTTON
//-----------------------------------------------------------------------------------------------*/
          Container(
              width: 300,
              height: 40,
              child: ElevatedButton(
                  child: Text('Log Out'),
                  onPressed: ()async {
                    context.read<AuthenticationService>().signOut();
                    Navigator.pushNamed(context, '/signin');
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 6,
                      primary: Color(0xFF616161),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Color(0xFF512DA8))
                      )
                  )
              )
          ),
        ],
      ),
    );
  }
}