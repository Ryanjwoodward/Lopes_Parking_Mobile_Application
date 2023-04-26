///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-16-2023
///-----------------------------------------------------

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../services/authentication-service.dart';
import 'home-page.dart';


/**
 * SignUpPage Widget Defintion. Where the State of this page is instantiated
 */
class SignUpPage extends StatefulWidget {
  /// Key defines the pages location in the 'wdiget-tree'
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}


/**
 * This State class defines the state and attributes of the AccountPage Class
 */
class _SignUpPageState extends State<SignUpPage>{

  /**
   * These fields are controllers for our forms for when user's enter data into
   * the application. This will store and mutate the data or pass it on to a method
   */
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

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
      /**------------------------------------------
      // Body Portion of the Page
      //-------------------------------------------*/
      body: SafeArea(child:
      Center(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset('assets/lp-logo-words.png',scale: 3,),

                  SizedBox(height: 10),

                  Text('Sign Up', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black)),

                  SizedBox(
                    //Use of SizedBox
                      height: 10
                  ),

                //----- CHILD ONE: First Name Form -----
                  Padding(padding: EdgeInsets.only(
                    top: 16, left: 16, right: 16
                  ),
                      child: Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            autofocus: false,
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                labelText: 'Please Enter First Name',
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
                            controller: firstNameController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please Enter Your First Name';
                              }
                              return null;
                            },
                          )
                      )
                  ),


                  /**----- CHILD TWO: LastName Form -----*/
                  Padding(padding: EdgeInsets.only(
                      top: 16, left: 16, right: 16
                  ),
                      child: Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            autofocus: false,
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                labelText: 'Please Enter LastName',
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
                            controller: lastNameController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please Enter Your Last Name';
                              }
                              return null;
                            },
                          )
                      )
                  ),

                  //----- CHILD THREE: Email Form -----
                  Padding(padding: EdgeInsets.only(
                      top: 16, left: 16, right: 16
                  ),
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

                  //----- CHILD THREE: Phonenumber Form -----
                  Padding(padding: EdgeInsets.only(
                      top: 16, left: 16, right: 16
                  ),
                      child: Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            autofocus: false,
                            obscureText: true,
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                labelText: 'Please Enter Your Phone Number',
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
                            controller: phoneNumberController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please Enter Your Phone Number';
                              }
                              return null;
                            },
                          )
                      )
                  ),

                  //----- CHILD FIVE: Password Form -----
                  Padding(padding: EdgeInsets.only(
                      top: 16, left: 16, right: 16
                  ),
                      child: Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            autofocus: false,
                            obscureText: true,
                            style: TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                                labelText: 'Please Enter Password',
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
                            controller: passwordController,
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please Enter Your Password';
                              }
                              return null;
                            },
                          )
                      )
                  ),

                  SizedBox(height: 16,),
                  Container(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                          child: Text('Create Account'),
                          onPressed: ()async{
                            final result = await context.read<AuthenticationService>().signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                phonenumber: phoneNumberController.text.trim(),
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim()
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result!), duration:
                            Duration(milliseconds: 1200),));

                            if(result == "Signed Up"){
                              Navigator.popUntil(context, ModalRoute.withName('/auth'));
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
                  InkWell(
                      onTap: ()=> Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already Have An Account?',style: TextStyle(color: Colors.black),),
                          Text('Sign In', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),)
                        ],
                      )
                  )
                ],
              )
          )
      )
      ),
    );
  }
}



/*





 */
