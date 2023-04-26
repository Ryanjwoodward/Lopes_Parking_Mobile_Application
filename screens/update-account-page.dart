
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/authentication-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * UpdateAccountPage Widget Defintion. Where the State of this page is instantiated
 */
class UpdateAccountPage extends StatefulWidget {
  /// Key defines the pages location in the 'wdiget-tree'
  const UpdateAccountPage({Key? key}) : super(key: key);

  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();
}

/**
 * This State class defines the state and attributes of the CheckInPage Class
 */
class _UpdateAccountPageState extends State<UpdateAccountPage>{

  /**
   * These fields are controllers for our forms for when user's enter data into
   * the application. This will store and mutate the data or pass it on to a method
   */
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController permitNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey();/// This form key maintains the information (variables)
                            ///    and other elements specific to this class for access
  late User user;///This fields reprensents a FirebaseAuth USer

  /**
   * These fields are used to connect to the Firestore Collections
   */
  final userCollection = FirebaseFirestore.instance.collection('users');
  final permitCollection = FirebaseFirestore.instance.collection('permits');

  @override initState(){
    setState(() {
      /// This instantiates the user to be the active/current Firebase Auth user
      /// thatis logged in to the application
      user = context.read<AuthenticationService>().getUser()!;
    });
  }

  /**
   * THis method build the (context, or body) of the widget itself
   */
  @override
  Widget build(BuildContext context){
    ///This scaffold defines the area of the entire body of the AccountPage - Page

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

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
      body: SafeArea(child:
      Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: [

                  SizedBox(height: 15),

                  Align(
                    alignment: Alignment.topRight,
                    child:
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFF512DA8),
                        size: 40.0,
                      ),
                      label: const Text(''),
                      onPressed: ()=> Navigator.pushNamed(context, '/account'),
                      style: ElevatedButton.styleFrom(
                          elevation: 6,
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                    ),
                  ),

                  SizedBox(height: 35),

                  Image.asset('assets/lp-logo-words.png',scale: 3.5,),

                  SizedBox(height: 10),

                  Text('Edit Your Vehicle Information', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black)),

                  SizedBox(
                    //Use of SizedBox
                      height: 10
                  ),

                  /**
                   * These forms are waht the users input their information into (license plate & permit #)
                   */
                  /**----- CHILD TWO: License Plate # -----*/
                  Padding(padding: EdgeInsets.only(
                      top: 16, left: 16, right: 16
                  ),
                      child: Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            autofocus: false,
                            obscureText: false,
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                labelText: 'Enter Your License Plate',
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
                            controller: licensePlateController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please Enter Your License Plate';
                              }
                              return null;
                            },
                          )
                      )
                  ),


                  /**----- CHILD THREE: Permit ID Number -----*/
                  Padding(padding: EdgeInsets.only(
                      top: 16, left: 16, right: 16
                  ),
                      child: Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            autofocus: false,
                            obscureText: false,
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                labelText: 'Enter Your Permit ID Number',
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
                            controller: permitNumberController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please Enter Your Permit ID Number';
                              }
                              return null;
                            },
                          )
                      )
                  ),

                  /**
                   * This is the submit button for changes to the account. There is error checking
                   * from the API class side of things. For instance the fields cannot be empty or NULL
                   */

                  SizedBox(height: 16,),
                  Container(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                          child: Text('Update Account'),
                          onPressed: ()async{
                            final result = await context.read<AuthenticationService>().validatePermit(

                              licensePlate: licensePlateController.text.trim(),
                              permitIdNumber: permitNumberController.text.trim(),

                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result!), duration:
                            Duration(milliseconds: 1200),));

                            if(result == "success"){
                              Navigator.pushNamed(context, '/account');
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
                  ),

                  SizedBox(height: 24,),
                ],
              )
          )
      )
      ),
    );
  }

}