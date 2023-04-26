import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lopes_parking/screens/parking-page.dart';
import 'package:lopes_parking/services/authentication-service.dart';
import 'package:provider/provider.dart';
import 'package:scan/scan.dart';

import '../services/authentication-service.dart';

///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-27-2023
///-----------------------------------------------------

/**
 * CheckInPage Widget Defintion. Where the State of this page is instantiated
 */
class CheckInPage extends StatefulWidget{

  /// Key defines the pages location in the 'wdiget-tree'
  const CheckInPage({Key? key}) : super(key: key);

  @override
  _CheckInPageState createState()=> _CheckInPageState();
}

/**
 * This State class defines the state and attributes of the CheckInPage Class
 */
class _CheckInPageState extends State<CheckInPage>{

  /* -----------------
    FIELDS
  ----------------- */
  late User user; ///This fields reprensents a FirebaseAuth USer

  /**
   * These fields are controllers for our forms for when user's enter data into
   * the application. This will store and mutate the data or pass it on to a method
   */
  TextEditingController parkingSpaceController = TextEditingController();
  ScanController controller = ScanController();

  var _scanResult = ''; /// This is used for the BarcodeScanner class it hold the result
                        /// of the scan so it can be implemented elsewhere

  final _formKey = GlobalKey(); /// This form key maintains the information (variables)
                                /// and other elements specific to this class for access

  /**
   * This method creates the state of the CheckInPage Class and instantiated all
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
      body: Column(///Main Body of the application page
        children: [

          SizedBox(height: 10),/// Added to provided padding between widgets

          //-----------------------------------------------------------
          // Back-Arrow
          //-----------------------------------------------------------
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

          Column(
            children: [
              Center(/// This widget is used to define and style an image asset
                child: user!=null ?
                Image.asset('assets/lp-logo-horiz.png', height: 150, width: 280,): Container(),
              ),

              SizedBox(height: 10), /// Added to provided padding between widgets
            ],
          ),

          ///Stream Builders are used to interact with streams from the Databases
          ///Specifically the Firestore databases
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


              /// *** BEGIN CHECK-IN PAEGE ***

              /**
               * This portion of the page !- ONLY -! shows up if the User is not
               * checked into a garage
               */
              if(data['parked_status'].toString() == "false"){
                return
                  Column(
                    children: [

                      Text("Check Into a Parking Garage", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF512DA8)),),
                      SizedBox(height: 10),


                      Padding(padding: EdgeInsets.only(
                          top: 16, left: 16, right: 16
                      ),
                          child: Expanded(
                              child: TextFormField(
                                cursorColor: Colors.black,
                                autofocus: false,
                                obscureText: false,
                                ///Define the form to input the parking space #
                                style: TextStyle(color: Colors.deepPurple),
                                decoration: InputDecoration(
                                    labelText: 'Enter The Parking Space Number',
                                    labelStyle: TextStyle(
                                      fontSize: 15, color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple,
                                            width: 1.0
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.deepPurple, width: 1.0)
                                    ),
                                    errorStyle: TextStyle(
                                        color: Colors.red, fontSize: 15
                                    )
                                ),
                                controller: parkingSpaceController,
                                validator: (value){
                                  if(value == null || value.isEmpty){
                                    return 'Please Enter The Parking Space Number';
                                  }
                                  return null;
                                },
                              )
                          )
                      ),

                      SizedBox(height: 16,), /// Added to provided padding between widgets
                      Container(
                          width: 300,
                          height: 40,
                          /// Define the submit button of the Check-in page
                          child: ElevatedButton(
                              child: Text('Check In'),
                              onPressed: ()async{
                                ///This function (onPressed) will be called upon pressing of the submission button
                                ///or by scanning a QR code
                                final result = await context.read<AuthenticationService>().checkInToParkingGarage(

                                  //Update Parking Space Method
                                  parkingSpaceNumber: parkingSpaceController.text.trim()
                                );
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result!), duration:
                                Duration(milliseconds: 1200),));

                                if(result == "success"){
                                  Navigator.pushNamed(context, '/checkin');
                                }

                              },
                              ///Styling of the submission button
                              style: ElevatedButton.styleFrom(
                                  elevation: 6,
                                  primary: Colors.deepPurple,
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                                      side: BorderSide(color: Colors.black)
                                  )
                              )
                          )
                      ),


                      SizedBox(height: 10),/// Added to provided padding between widgets

                      ///This is where the prompt at the bottom of the page is defined
                      ///for the user to access the QR code scanner
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Have a QR Code?", style: TextStyle(color: Colors.black,),
                          ),

                          Align(
                            alignment: Alignment.center,
                            child:
                            ElevatedButton.icon(
                              icon: const Icon(
                                Icons.qr_code_2,
                                color: Color(0xFF512DA8),
                                size: 40.0,
                              ),
                              label: const Text(''),
                              onPressed: _showBarcodeScanner,
                              style: ElevatedButton.styleFrom(
                                  elevation: 6,
                                  primary: Colors.transparent,
                                  shadowColor: Colors.transparent
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
              }//END OF IF-STATEMENT
              /// END OF THE CHECK-IN PAGE


              /// *** BEGIN CHECK-OUT PAGE ***
              /**
               * THIS PORTION of the page is returned !- ONLY -! IF the User is checked itno
               * a garage
               */
              return/// IF THE USER IS PARKED THIS WILL BE RETURNED
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      /// Displays teh current spot number the user scanned/entered
                        SizedBox(height: 15),
                        Text("You are Parked in: ", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),),
                        Text(" "),
                        Text(data['parked_in'], style: TextStyle(color: Color(0xFF512DA8), fontSize: 22, fontWeight: FontWeight.w500),),
                      ],),

                    SizedBox(height: 15),

                    ///Defines the check-out button
                    Container(
                        width: 300,
                        height: 40,
                        child: ElevatedButton(
                            child: Text('Check Out'),
                            onPressed: ()async{
                              final result = await context.read<AuthenticationService>().checkOutOfParkingGarage();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result!), duration:
                              Duration(milliseconds: 1200),));

                              if(result == "success"){
                                Navigator.pushNamed(context, '/checkin');
                              }

                            },
                            style: ElevatedButton.styleFrom(
                                elevation: 6,
                                primary: Colors.deepPurple,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: Colors.black)
                                )
                            )
                        )
                    )
                  ],
                );
            },
          ),

          SizedBox(height: 20),/// Added to provided padding between widgets

        ]
      ),
    );


  }// build method

  /**
   * This static method is called to display the barcode scanner to allow the user to scan
   * the QR code.
   */
  _showBarcodeScanner() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) { ///Builds a context for the barcode scanner widget to be displayed over top the check-in page
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Scaffold(
                appBar: _buildBarcodeScannerAppBar(),
                body: _buildBarcodeScannerBody(),
              ));
        });
      },
    );
  }

  /**
   * THis method is used to create the Body and define the elements of the Barcode
   * Scanner itself. (i.e. styles and widgets)
   */
  AppBar _buildBarcodeScannerAppBar() {
    return AppBar(
      bottom: PreferredSize(
        child: Container(color: Colors.deepPurple, height: 4.0),
        preferredSize: const Size.fromHeight(4.0),
      ),
      title: const Text('Scan Your Barcode'),
      elevation: 0.0,
      backgroundColor: const Color(0xFF333333),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Center(
            child: Icon(
              Icons.cancel,
              color: Colors.white,
            )),
      ),
      actions: [
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
                onTap: () => controller.toggleTorchMode(),
                child: const Icon(Icons.flashlight_on))),
      ],
    );
  }

  /**
   * THis method instantiates the fields of the barcode scanner and
   * provides the functionality of the scanner which calls the same method as
   * the submit button
   */
  Widget _buildBarcodeScannerBody() {
    return SizedBox(
      height: 400,
      child: ScanView(
        controller: controller,
        scanAreaScale: .7,
        scanLineColor: Colors.deepPurple,
        onCapture: (data) async {
          setState(() {
            _scanResult = data;
            parkingSpaceController.text = data;
          });
          final result = await context.read<AuthenticationService>().checkInToParkingGarage(

            //Update Parking Space Method
              parkingSpaceNumber: parkingSpaceController.text.trim()
          );
        },
      ),
    );
  }



}// _CheckInPageState


