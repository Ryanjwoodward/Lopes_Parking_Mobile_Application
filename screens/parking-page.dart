import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authentication-service.dart';

///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-27-2023
///-----------------------------------------------------

/**
 * ParkingPage Widget Defintion. Where the State of this page is instantiated
 */
class ParkingPage extends StatefulWidget {
  /// Key defines the pages location in the 'wdiget-tree'
  const ParkingPage({Key? key}) : super(key: key);

  @override
  _ParkingPageState createState() => _ParkingPageState();
}

/**
 * This State class defines the state and attributes of the Parkingpage Class
 */
class _ParkingPageState extends State<ParkingPage>{

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
        /**
         * This widget is the primary portion of the page.
         * Including Buttons, streams builders and other widgets
         */
      body: SingleChildScrollView(
        child: Column(
          children: [

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

            SizedBox(height: 15),

            /**
             * Note: Each of the Stream Builders below correspond to a Parking Garage at GCU Campus
             * Each or denoted with comments but all implement the same structured tables
             */

            /**FIRST STREAM BUILDER
            //------------------------------------------------------------------------------------------------------------------------------------------- HALO GARAGE
                */
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:  FirebaseFirestore
                  .instance
                  .collection('garages')
                  .doc('halo_garage')
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

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF512DA8),
                          border: Border.all(
                            color: Color(0xFF512DA8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(292),
                          },
                          children: [
                            TableRow(
                                children:[
                                  TableCell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 50),
                                        alignment: Alignment.center,
                                        height: 35,
                                        color: Colors.transparent,
                                        child:
                                            Row(
                                            children: [
                                              Text(data['name'],
                                                style: TextStyle(
                                                  fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                                ),
                                              ),
                                              Text(" "),
                                              Text("Parking Garage",
                                                style: TextStyle(
                                                  fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                        ),
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 5),

                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFF512DA8),
                              width: 2
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        child:
                            Table(
                                columnWidths: const <int, TableColumnWidth>{
                                  0: FixedColumnWidth(170),
                                  1: FixedColumnWidth(120)
                                },
                                children:[
                                          TableRow(
                                            children: [
                                              TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                  child:
                                                  Container(
                                                    alignment: Alignment.centerRight,
                                                    height: 35,
                                                    color: Colors.transparent,
                                                    child:
                                                    Text(
                                                      "Building Number: ",
                                                      style: TextStyle(
                                                          fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                                      ),
                                                    ),
                                                  )
                                              ),

                                              TableCell(
                                                  child:
                                                  Container(
                                                    alignment: Alignment.centerLeft,
                                                    height: 35,
                                                    color: Colors.transparent,
                                                    child:
                                                    Text(
                                                      data['building_id'],
                                                      style: TextStyle(
                                                          fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                                      ),
                                                    ),
                                                  )
                                              ),

                                            ]
                                          ),

                                  TableRow(
                                      children: [
                                        TableCell(
                                            verticalAlignment: TableCellVerticalAlignment.middle,
                                            child:
                                            Container(
                                              alignment: Alignment.centerRight,
                                              height: 35,
                                              color: Colors.transparent,
                                              child:
                                              Text(
                                                "Required Permit: ",
                                                style: TextStyle(
                                                    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                                ),
                                              ),
                                            )
                                        ),
                                        //--- Information Cell ---
                                        TableCell(
                                            child:
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              height: 55,
                                              color: Colors.transparent,
                                              child:
                                              Text(
                                                data['accepted_permits'],
                                                style: TextStyle(
                                                    fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                                ),
                                              ),
                                            )
                                        ),
                                      ]
                                  ),

                                  TableRow(
                                      children: [
                                        TableCell(
                                            verticalAlignment: TableCellVerticalAlignment.middle,
                                            child:
                                            Container(
                                              alignment: Alignment.centerRight,
                                              height: 35,
                                              color: Colors.transparent,
                                              child:
                                              Text(
                                                "Total Capacity: ",
                                                style: TextStyle(
                                                    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                                ),
                                              ),
                                            )
                                        ),
                                        //--- Information Cell ---
                                        TableCell(
                                            child:
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              height: 55,
                                              color: Colors.transparent,
                                              child:
                                              Text(
                                                data['disp_capacity'],
                                                style: TextStyle(
                                                    fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                                ),
                                              ),
                                            )
                                        ),
                                      ]
                                  ),

                                  TableRow(
                                      children: [
                                        TableCell(
                                            verticalAlignment: TableCellVerticalAlignment.middle,
                                            child:
                                            Container(
                                              alignment: Alignment.centerRight,
                                              height: 35,
                                              color: Colors.transparent,
                                              child:
                                              Text(
                                                "Available Parking: ",
                                                style: TextStyle(
                                                    fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                                ),
                                              ),
                                            )
                                        ),
                                        //--- Information Cell ---
                                        TableCell(
                                            child:
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              height: 55,
                                              color: Colors.transparent,
                                              child:
                                              Text(
                                                data['disp_occupied'],
                                                style: TextStyle(
                                                    fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                                ),
                                              ),
                                            )
                                        ),
                                      ]
                                  ),

                                ]
                            ),
                      ),
                    ],
                  );
              },
            ),

            //-----------------------------------------------------SECOND STREAM BUILDER---------------------------------------------------GROVE GARAGE
            SizedBox(height: 20),


            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:  FirebaseFirestore
                  .instance
                  .collection('garages')
                  .doc('grove_garage')
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

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF512DA8),
                          border: Border.all(
                            color: Color(0xFF512DA8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(292),
                          },
                          children: [
                            TableRow(
                                children:[
                                  TableCell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 50),
                                        alignment: Alignment.center,
                                        height: 35,
                                        color: Colors.transparent,
                                        child:
                                        Row(
                                          children: [
                                            Text(data['name'],
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                            Text(" "),
                                            Text("Parking Garage",
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 5),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF512DA8),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(170),
                              1: FixedColumnWidth(120)
                            },
                            children:[
                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Building Number: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),

                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['building_id'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),

                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Required Permit: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 60,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['accepted_permits'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Total Capacity: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_capacity'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Available Parking: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_occupied'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                            ]
                        ),
                      ),
                    ],
                  );
              },
            ),

            //------------------------------------------------------------THIRD STREAM BUILDER------------------------------------------------------------29th AVE GARAGE

            SizedBox(height: 20),

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:  FirebaseFirestore
                  .instance
                  .collection('garages')
                  .doc('29th_ave_garage')
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

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF512DA8),
                          border: Border.all(
                            color: Color(0xFF512DA8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(292),
                          },
                          children: [
                            TableRow(
                                children:[
                                  TableCell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 50),
                                        alignment: Alignment.center,
                                        height: 35,
                                        color: Colors.transparent,
                                        child:
                                        Row(
                                          children: [
                                            Text(data['name'],
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                            Text(" "),
                                            Text("Parking Garage",
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 5),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF512DA8),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(170),
                              1: FixedColumnWidth(120)
                            },
                            children:[
                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Building Number: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),

                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['building_id'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),

                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Required Permit: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['accepted_permits'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Total Capacity: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_capacity'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Available Parking: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_occupied'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                            ]
                        ),
                      ),
                    ],
                  );
              },
            ),

            //------------------------------------------------------------ STREAM BUILDER------------------------------------------------------------33rd AVE GARAGE

            SizedBox(height: 20),

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:  FirebaseFirestore
                  .instance
                  .collection('garages')
                  .doc('33rd_ave_garage')
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

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF512DA8),
                          border: Border.all(
                            color: Color(0xFF512DA8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(292),
                          },
                          children: [
                            TableRow(
                                children:[
                                  TableCell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 50),
                                        alignment: Alignment.center,
                                        height: 35,
                                        color: Colors.transparent,
                                        child:
                                        Row(
                                          children: [
                                            Text(data['name'],
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                            Text(" "),
                                            Text("Parking Garage",
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 5),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF512DA8),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(170),
                              1: FixedColumnWidth(120)
                            },
                            children:[
                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Building Number: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),

                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['building_id'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),

                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Required Permit: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['accepted_permits'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Total Capacity: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_capacity'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Available Parking: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_occupied'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                            ]
                        ),
                      ),
                    ],
                  );
              },
            ),

            //------------------------------------------------------------FOURTH STREAM BUILDER------------------------------------------------------------31st AVE GARAGE

            SizedBox(height: 20),

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:  FirebaseFirestore
                  .instance
                  .collection('garages')
                  .doc('31st_ave_garage')
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

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF512DA8),
                          border: Border.all(
                            color: Color(0xFF512DA8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(292),
                          },
                          children: [
                            TableRow(
                                children:[
                                  TableCell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 50),
                                        alignment: Alignment.center,
                                        height: 35,
                                        color: Colors.transparent,
                                        child:
                                        Row(
                                          children: [
                                            Text(data['name'],
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                            Text(" "),
                                            Text("Parking Garage",
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 5),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF512DA8),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(170),
                              1: FixedColumnWidth(120)
                            },
                            children:[
                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Building Number: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),

                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['building_id'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),

                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Required Permit: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 60,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['accepted_permits'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Total Capacity: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_capacity'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Available Parking: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_occupied'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                            ]
                        ),
                      ),
                    ],
                  );
              },
            ),

            //------------------------------------------------------------FOURTH STREAM BUILDER------------------------------------------------------------29th and Missouri GARAGE

            SizedBox(height: 20),

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:  FirebaseFirestore
                  .instance
                  .collection('garages')
                  .doc('29th & Missouri')
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

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF512DA8),
                          border: Border.all(
                            color: Color(0xFF512DA8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(292),
                          },
                          children: [
                            TableRow(
                                children:[
                                  TableCell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 50),
                                        alignment: Alignment.center,
                                        height: 35,
                                        color: Colors.transparent,
                                        child:
                                        Row(
                                          children: [
                                            Text(data['name'],
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                            Text(" "),
                                            Text("Garage",
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 5),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF512DA8),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(170),
                              1: FixedColumnWidth(120)
                            },
                            children:[
                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Building Number: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),

                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['building_id'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),

                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Required Permit: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['accepted_permits'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Total Capacity: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_capacity'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Available Parking: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_occupied'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                            ]
                        ),
                      ),
                    ],
                  );
              },
            ),

            //------------------------------------------------------------FOURTH STREAM BUILDER------------------------------------------------------------RIVERS GARAGE

            SizedBox(height: 20),

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:  FirebaseFirestore
                  .instance
                  .collection('garages')
                  .doc('rivers_garage')
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

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF512DA8),
                          border: Border.all(
                            color: Color(0xFF512DA8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(292),
                          },
                          children: [
                            TableRow(
                                children:[
                                  TableCell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 50),
                                        alignment: Alignment.center,
                                        height: 35,
                                        color: Colors.transparent,
                                        child:
                                        Row(
                                          children: [
                                            Text(data['name'],
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                            Text(" "),
                                            Text("Parking Garage",
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 5),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF512DA8),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(170),
                              1: FixedColumnWidth(120)
                            },
                            children:[
                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Building Number: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),

                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['building_id'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),

                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Required Permit: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['accepted_permits'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Total Capacity: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_capacity'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Available Parking: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_occupied'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                            ]
                        ),
                      ),
                    ],
                  );
              },
            ),

            //------------------------------------------------------------FOURTH STREAM BUILDER------------------------------------------------------------27th AVE GARAGE

            SizedBox(height: 20),

            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream:  FirebaseFirestore
                  .instance
                  .collection('garages')
                  .doc('27th_ave')
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

                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF512DA8),
                          border: Border.all(
                            color: Color(0xFF512DA8),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                          columnWidths: const <int, TableColumnWidth>{
                            0: FixedColumnWidth(292),
                          },
                          children: [
                            TableRow(
                                children:[
                                  TableCell(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 50),
                                        alignment: Alignment.center,
                                        height: 35,
                                        color: Colors.transparent,
                                        child:
                                        Row(
                                          children: [
                                            Text(data['name'],
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                            Text(" "),
                                            Text("Parking Garage",
                                              style: TextStyle(
                                                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                  )
                                ]
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 5),

                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF512DA8),
                              width: 2
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child:
                        Table(
                            columnWidths: const <int, TableColumnWidth>{
                              0: FixedColumnWidth(170),
                              1: FixedColumnWidth(120)
                            },
                            children:[
                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Building Number: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),

                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['building_id'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),

                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Required Permit: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 60,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['accepted_permits'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Total Capacity: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_capacity'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                              TableRow(
                                  children: [
                                    TableCell(
                                        verticalAlignment: TableCellVerticalAlignment.middle,
                                        child:
                                        Container(
                                          alignment: Alignment.centerRight,
                                          height: 35,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            "Available Parking: ",
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey.shade700
                                            ),
                                          ),
                                        )
                                    ),
                                    //--- Information Cell ---
                                    TableCell(
                                        child:
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: 55,
                                          color: Colors.transparent,
                                          child:
                                          Text(
                                            data['disp_occupied'],
                                            style: TextStyle(
                                                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black
                                            ),
                                          ),
                                        )
                                    ),
                                  ]
                              ),

                            ]
                        ),
                      ),
                    ],
                  );
              },
            ),




          ],
        ),
      )
    );
    //-----------------------------------------------------
    //END Scaffold
    //-----------------------------------------------------

  }// build Method
}// _ParkingPageState class