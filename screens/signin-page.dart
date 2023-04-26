///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-16-2023
///-----------------------------------------------------
///


//--------------------------------------------------------------------------------
//Sign In Page Class
//--------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/authentication-service.dart';
import 'home-page.dart';

class SignInPage extends StatefulWidget{

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

/**--------------------------------------------------------------------------------
//Sign Up Page State Class
//--------------------------------------------------------------------------------*/
class _SignInPageState extends State<SignInPage>{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey();

  /**
   * This portion of the page is the appBar (top of the page)
   */
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF512DA8),
        title: Text('Grand Canyon University', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white )),
      ),
      body: SafeArea(child:
      Center(
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset('assets/lp-logo-vertical.png'),

                  /**----- CHILD ONE: Email Form -----*/
                  /**
                   * This form is where the user will enter their email address
                   * Notice the connection to the email controller
                   */
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
                            /**
                             * here the email cotnroller will validate the credentials for null or incorrect
                             */
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return 'Please Enter Your Email';
                              }
                              return null;
                            },
                          )
                      )
                  ),

                  /**----- CHILD TWO: Password Form -----*/
                  Padding(padding: EdgeInsets.all(16),
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
                                return 'Please Enter Your Email';
                              }
                              return null;
                            },
                          )
                      )
                  ),

                  /**
                   * These widgets below are for the submission button connected to the fields above
                   * and the for navigation to sign-up or forgot-password pages
                   */
                  SizedBox(height: 16,),
                  Container(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                          child: Text('Sign In'),
                          onPressed: ()async{
                            final result = await context.read<AuthenticationService>().signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim()).then((result) =>
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(result!),
                                  duration: Duration(milliseconds: 1200),
                                )),
                            );
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(),),);
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
                  SizedBox(height: 24,), /** Added to provide padding*/
                  /**
                   * This portion (inkwell) is used to allow the user to navigate back to the Sign-up page,
                   * If they do not, yet, have an account
                   */
                  InkWell(
                      onTap: ()=> Navigator.pushNamed(context, '/signup'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't Have An Account ",style: TextStyle(color: Colors.black),),
                          Text("Click Here", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),)
                        ],
                      )
                  ),

                  /**
                   * This portion (inkwell) of the page is used to allow the user to navigate back to
                   * the reset-password page if they forgiot their credentials
                   */
                  SizedBox(height: 20,),
                  InkWell(
                      onTap: ()=> Navigator.pushNamed(context, '/resetPassword'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Forget Password ", style: TextStyle(color: Colors.black),),
                          Text("Click Here", style: TextStyle(
                              color: Colors.deepPurple, fontWeight: FontWeight.bold)
                          )
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