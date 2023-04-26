import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lopes_parking/screens/parking-page.dart';
import 'package:lopes_parking/services/authentication-service.dart';
import 'package:provider/provider.dart';

///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-27-2023
///-----------------------------------------------------

/**
 * AccountPage Widget Defintion. Where the State of this page is instantiated
 */
class AccountPage extends StatefulWidget{

  /// Key defines the pages location in the 'wdiget-tree'
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState()=> _AccountPageState();
}

/**
 * This State class defines the state and attributes of the AccountPage Class
 */
class _AccountPageState extends State<AccountPage>{

  /*---------------------
    FIELDS
   ---------------------*/
  late User user; /// This field represents a FirebaseAuth User

  /**
   * This method creates the state of the AccountPage Class and instantiated all
   * variables
   */
  @override
  void initState(){
    setState(() {
      /// This instantiates the user to be the active/current Firebase Auth user
      /// thatis logged in to the application
      user = context.read<AuthenticationService>().getUser()!;
    });
    super.initState();
  }

  /**
   * THis method build the (context, or body) of the widget itself
   */
  @override
  Widget build(BuildContext context){

    ///This scaffold defines the area of the entire body of the AccountPage - Page
    return Scaffold(

      backgroundColor: Color(0xFFFAFAFA),

      //------------------------------------------
      // Top Bar Portion of the Mobile Page
      //-------------------------------------------
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

      //------------------------------------------
      // Body Portion of the Page
      //-------------------------------------------
      body: Column(
        children: [

          //-----------------------------------------------------------
          // Back-Arrow
          //-----------------------------------------------------------
          SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child:
            ElevatedButton.icon(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF512DA8),
                size: 40.0,
              ),
              label: const Text(''),
              onPressed: ()=> Navigator.pushNamed(context, '/home'),
              style: ElevatedButton.styleFrom(
                  elevation: 6,
                  primary: Colors.transparent,
                  shadowColor: Colors.transparent
              ),
            ),
          ),

          //----------------------------------------------------------------
          // Page Title
          //-----------------------------------------------------------------
          SizedBox(height: 15),/// Added to provided padding between widgets

          Column(
              children:[

                ///Stream Builders are used to interact with streams from the Databases
                ///Specifically the Firestore databases
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream:  FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid) ///Obtains the user doc that corresponds to the AuthID of the user (FB and FS are linked)
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ///On the page this is where we define the interpolated date from the Firestore Document
                              ///Via the StreamBuilder Widget
                              Text(data['first_name'], style: TextStyle(color: Color(0xFF512DA8), fontSize: 22, fontWeight: FontWeight.w500),),
                              Text(" "),
                              Text(data['last_name'], style: TextStyle(color: Color(0xFF512DA8), fontSize: 22, fontWeight: FontWeight.w500),),
                          ],),

                          ///On the page this is where we define the interpolated date from the Firestore Document
                          ///Via the StreamBuilder Widget
                          Text("Account Information", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),),

                          SizedBox(height: 10),

                          Divider( ///This is the horizontal line on the page
                            color: Color(0xFF512DA8),
                            height: 25,
                            thickness: 2,
                            indent: 25,
                            endIndent: 25,
                          )
                        ],
                      );
                  },
                ),

                SizedBox(height: 20), /// Added to provided padding between widgets

                //-------------------------------
                // TABLE ONE: User's Name
                //-------------------------------

                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream:  FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
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
                     Table(
                       columnWidths: const <int, TableColumnWidth>{
                         0: FixedColumnWidth(50),
                         1: FixedColumnWidth(250)
                       },
                      children: [
                        TableRow(
                            children: [
                              //--- Icon Cell ---
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:
                                  Container(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      height: 35,
                                      color: Colors.transparent,
                                      child:
                                      Icon(
                                        Icons.person_outlined,
                                        color: Color(0xFF512DA8),
                                        size: 35,
                                      )
                                  )
                              ),
                              //--- Information Cell ---
                              TableCell(
                                  child:
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      height: 35,
                                      color: Colors.transparent,
                                      child:
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                             Container(
                                               height: 55,
                                               child:  Text(
                                                 data['first_name'],
                                                 style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.w500),
                                                 textAlign: TextAlign.center,
                                               ),
                                             ),
                                              Text(" "),
                                              Container(
                                                height: 55,
                                                padding: EdgeInsets.only(bottom: 10.0),
                                                child: Text(
                                                  data['last_name'],
                                                  style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.w500),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                            ],
                                          ),
                                  )
                              ),
                            ]
                        ),

                        //-----------------------------------
                        // SECOND ROW: Phone Number
                        //-----------------------------------
                        TableRow(
                            children: [
                              //--- Icon Cell ---
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:
                                  Container(
                                      height: 35,
                                      color: Colors.transparent,
                                      child:
                                      Icon(
                                        Icons.call_outlined,
                                        color: Color(0xFF512DA8),
                                        size: 35,
                                      )
                                  )
                              ),
                              //--- Information Cell ---
                              TableCell(
                                  child:
                                  Container(
                                      alignment: Alignment.center,
                                      height: 55,
                                      color: Colors.transparent,
                                      child:
                                      Text(
                                        data['phone_number'],
                                        style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      )
                                  )
                              ),
                            ]
                        ),

                        //---------------------------------------------
                        // THIRD ROW: Email Address
                        //---------------------------------------------
                        TableRow(

                            children: [
                              //--- Icon Cell ---
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:
                                  Container(
                                      height: 35,
                                      color: Colors.transparent,
                                      child:
                                      Icon(
                                        Icons.mail_outlined,
                                        color: Color(0xFF512DA8),
                                        size: 35,
                                      )
                                  )
                              ),
                              //--- Information Cell ---
                              TableCell(
                                  child:
                                  Container(
                                      alignment: Alignment.center,
                                      height: 55,
                                      color: Colors.transparent,
                                      child:
                                      Text(
                                        data['email'],
                                        style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      )
                                  )
                              ),
                            ]
                        ),

                        //---------------------------------------------------
                        // FOURTH ROW: Parking Permit
                        //---------------------------------------------------
                        TableRow(

                            children: [
                              //--- Icon Cell ---
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:
                                  Container(
                                      height: 55,
                                      color: Colors.transparent,
                                      child:
                                      Icon(
                                        Icons.car_rental,
                                        color: Color(0xFF512DA8),
                                        size: 35,
                                      )
                                  )
                              ),
                              //--- Information Cell ---
                              TableCell(
                                  child:
                                  Container(
                                      alignment: Alignment.center,
                                      height: 55,
                                      color: Colors.transparent,
                                      child:
                                      Text(
                                        data['license_plate_number'],
                                        style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      )
                                  )
                              ),
                            ]
                        ),

                        //---------------------------------------------------
                        // SIXTH ROW: Parking Permit ID #
                        //---------------------------------------------------
                        TableRow(

                            children: [
                              //--- Icon Cell ---
                              TableCell(
                                  verticalAlignment: TableCellVerticalAlignment.middle,
                                  child:
                                  Container(
                                      height: 55,
                                      color: Colors.transparent,
                                      child:
                                      Icon(
                                        Icons.card_membership_rounded,
                                        color: Color(0xFF512DA8),
                                        size: 35,
                                      )
                                  )
                              ),
                              //--- Information Cell ---
                              TableCell(
                                  child:
                                  Container(
                                    padding: EdgeInsets.only(left: 43),
                                      alignment: Alignment.center,
                                      height: 55,
                                      color: Colors.transparent,
                                      child:
                                      Row(
                                        children: [
                                          Text(
                                            data['permit_type'],
                                            style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text("  :  "),
                                          Text(
                                            data['permit_id_number'],
                                            style: TextStyle(color: Colors.grey.shade800, fontSize: 20, fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      )
                                  )
                              ),
                            ]
                        ),

                        ///END OF TABLE, if further rows are needed they can be added here
                      ],
                     );
                  },
                ),


                SizedBox(height: 40),/// Added to provided padding between widgets

                //--------------------------------------------
                // Edit Account Button
                //--------------------------------------------
                Container(
                    width: 300,
                    height: 40,
                    child: ElevatedButton(
                        child: Text('Edit Vehicle Information'),
                        ///OnPressed atribute passes a route (update-account-page) that will be navigated to
                        onPressed: ()=> Navigator.pushNamed(context, '/updateaccount'),
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

                SizedBox(height: 15),/// Added to provided padding between widgets

              ]
          )

        ],
      ),
    );
  }// build method


}// _AccountPageState