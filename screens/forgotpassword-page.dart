import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../services/authentication-service.dart';

///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-16-2023
///-----------------------------------------------------

/**
 * ForgotPasswordPage Widget Defintion. Where the State of this page is instantiated
 */
class ForgotPasswordPage extends StatefulWidget{
  /// Key defines the pages location in the 'wdiget-tree'
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

/**
 * This State class defines the state and attributes of the ForgotPasswordPage Class
 */
class _ForgotPasswordState extends State<ForgotPasswordPage> {

  /// This instantiates the user to be the active/current Firebase Auth user
  /// thatis logged in to the application
  TextEditingController emailController = TextEditingController();


  final _formKey = GlobalKey();/// This form key maintains the information (variables)
                              /// and other elements specific to this class for access

  /**
   * THis method build the (context, or body) of the widget itself
   */
  @override
  Widget build(BuildContext context){

    ///This scaffold defines the area of the entire body of the AccountPage - Page
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),

      //------------------------------------------
      // Top Bar Portion of the Mobile Page
      //-------------------------------------------
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF512DA8),
        title: Text('Grand Canyon University', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white )),
      ),

      //------------------------------------------
      // Body Portion of the Page
      //-------------------------------------------
      body: SafeArea(child:///Main Body of the application page
      Center(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset('assets/lp-logo-words.png',scale: 3,),

                  SizedBox(height: 10),

                  Text('Password Recovery', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black)),

                  SizedBox(
                    //Use of SizedBox
                      height: 10
                  ),
                  //----- CHILD ONE: Email Form -----
                  Padding(padding: EdgeInsets.all(16),
                      child: Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            autofocus: false,
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                labelText: 'Please Enter Email',
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
                            controller: emailController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please Enter Your Email';
                              }
                              return null;
                            },
                          )
                      )
                  ),



                  SizedBox(height: 16,),/// Added to provided padding between widgets
                  Container(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                          child: Text('Reset Password'),
                          onPressed: ()async{
                            final result = await context.read<AuthenticationService>().forgotPassword(
                              email: emailController.text.trim(),
                            );
                            if(result == "Password Reset Email Sent"){
                              Navigator.popUntil(context, ModalRoute.withName("/auth"));
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
                  SizedBox(height: 24,),/// Added to provided padding between widgets
                  InkWell(
                      onTap: ()=> Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already Have An Account?",style: TextStyle(color: Colors.black),),
                          Text("Sign In", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),)
                        ],
                      )
                  ),
                ],
              )
          )
      )
      ),
    );  }
}

