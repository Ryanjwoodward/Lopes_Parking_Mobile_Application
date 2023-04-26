///-----------------------------------------------------
///  Authors     | Ryan Woodward & Johnny Moore
///  Insituttion | Grand Canyon University
///  Instructor  | Prof. Jevon Jackson
///  Date        | 01-16-2023 (created)
///-----------------------------------------------------


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/**
 * This class is used as an API for each of the 'page' classes to interact with
 * Firebase & Firestore Databases.
 */
class AuthenticationService{

  /**-------------------------------------
      CLASS FIELDS
   -------------------------------------*/
  /**
   * This field refers to an instance of the FirebaseAuth Database
   * It is through this field that all of Firebase Authentication services
   * will be accessed
   */
  final FirebaseAuth _firebaseAuth;

  /**
   * This Field serves to instantiate the AuthenticationService Class
   * so static access is granted.
   */
  AuthenticationService(this._firebaseAuth);

  /**
   * This Field serves as an intance of the Firestore Database. It Contains all
   * of the collections (i.e garages, users, etc.)
   */
  FirebaseFirestore db = FirebaseFirestore.instance;

  /**
   * These fields are instances of specific Firestore Collections
   * Through this instance the application can access specific
   * document within that collection (i.e 'users').
   */
  final users_collection = FirebaseFirestore.instance.collection('users');
  final garage_collection = FirebaseFirestore.instance.collection('garages');
  final permitCollection = FirebaseFirestore.instance.collection('permits');

  /**
   * This field allow the application to subscribe to any changes to the Auth
   * User state. (i.e. login, logout, sign-up, etc.)
   */
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();



  /*-------------------------------------------------------
  *     CLASS METHODS
  *------------------------------------------------------*/
  /**
   * This method is used to interact with the Firebase Auth System to login to
   * the intended user's account. It allows the application to interact with
   * the Firebase instance to access it's authentication services
   */
  Future <String?> signIn({required String email, required  String password}) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed In";
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  /**
   * This method is used to interact with both the Firebase & Firestore Database
   * instances. This method allows user's to create account by requiring certain
   * input fields received from the method call.
   */
  Future <String?> signUp({
      required String email,
      required  String password,
      required String phonenumber,
      required String firstName,
      required String lastName}) async{

    String id = "";

    try{
      ///This statement is used to create a Firebase Auth User
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

       String uid = _firebaseAuth.currentUser!.uid;
       List garages = [];

       ///This block is used to create a new Document within the 'users' collection
      /// and create all the necessary fields for the applications users
      db.collection("users").doc(uid).set({
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_number": phonenumber,
        "parked_status": "false",
        "license_plate_number": "n/a",
        "permit_id_number": "n/a",
        "permit_type": "n/a",
        "allowed_garages" : garages,
        "parked_in": "n/a"
      });


      return "Signed Up";
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }


  /**
   * This method is used to interact with the Firebase Auth System to logout of
   * the intended user's account. It allows the application to interact with
   * the Firebase instance to access it's authentication services
   */
  Future<String?> signOut() async{
    try{
      await _firebaseAuth.signOut();
      return "Signed Out";
    } on FirebaseAuthException {
      return null;
    }
  }

  /**
   * This method is used to interact with the Firebase Auth System to retrieve
   * (get) the current user that is logged into Firebase and Lopes Parking
   * on the specific platform.
   */
  User? getUser(){
    try{
      return _firebaseAuth.currentUser;
    } on FirebaseAuthException{
      return null;
    }
  }

  /**
   * This method is used to interact with the Firebase Auth System to send a
   * recover account password to the specific email provided in the call method
   */
  Future<String?> forgotPassword({required String email}) async{
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Password Reset Email Sent";
    } on FirebaseAuthException catch(e){
      return e.message;
    }
  }


  /**
   * This method is used to interact with the Firestore Database, users collection
   * to obtain the firstName attribute of te current user based upon the mutual
   * auth_id  & document Id
   */
  Future<String> getFirestoreUserFirstName()  async {

    String auth_uid = await FirebaseAuth.instance.currentUser!.uid;

    String firstname = "_";
     await db.collection('users').doc(auth_uid).get().then((DocumentSnapshot docSnap){
        firstname = docSnap['first_name'];
      });

    return firstname;
  }

  /**
   * THis method is used to interact with the Firestore Database, garage and users
   * collections to allow the user to check-out of a garage and verify the permit,
   * and update the specific, relevant, attributes of each collection.
   */
  Future<String?> checkOutOfParkingGarage() async {
    String auth_uid = await FirebaseAuth.instance.currentUser!.uid;
    String parkedIn = "", garageBldgNumber = "", garageDocId = "";
    int spotsOccupied = 0;

    await db.collection('users').doc(auth_uid).get().then((DocumentSnapshot docSnap){
      parkedIn = docSnap['parked_in'];
      garageBldgNumber = parkedIn.substring(0, 2);
    });

    switch(garageBldgNumber){
      case "70" : //27th Ave
        garageDocId = "27th_ave";
        break;
      case "59" : // 29th & Missouri
        garageDocId = "29th & Missouri";
        break;
      case "55" : // 29th Ave
        garageDocId = "29th_ave_garage";
        break;
      case "44" : // 31st Ave
        garageDocId = "31st_ave_garage";
        break;
      case "07"  : // 33rd Ave
        garageDocId = "33rd_ave_garage";
        break;
      case "80" : // Grove
        garageDocId = "grove_garage";
        break;
      case "15" : // Halo
        garageDocId = "halo_garage";
        break;
      case "75" : // Rivers
        garageDocId = "rivers_garage";
        break;
      default: // Error Handle
        return "Not A Valid Parking Garage Number";
    }


    // THis block updates the Garages fields
    await db.collection('garages').doc(garageDocId).get().then((
        DocumentSnapshot docSnap) {
      spotsOccupied = docSnap['occupied_spots'];
      spotsOccupied += 1;

      db.collection("garages").doc(garageDocId).update({
        "occupied_spots": spotsOccupied,
        "disp_occupied": (spotsOccupied.toString())
      });
    });

    // This Block Updates the User doc fields
    db.collection("users").doc(auth_uid).update({
      "parked_in": "n/a",
      "parked_status": "false"
    });
  }


  /**
   * THis method is used to interact with the Firestore Database, garage and users
   * collections to allow the user to check-in to a garage and verify the permit,
   * and update the specific, relevant, attributes of each collection.
   */
  Future<String?> checkInToParkingGarage({required String parkingSpaceNumber}) async {

    String auth_uid = await FirebaseAuth.instance.currentUser!.uid;
    String garageBldgNumber = parkingSpaceNumber.substring(0, 2);
    String garageDocId = "";
    int spotsOccupied = 0;
    String userPermitType = "";
    var acceptedPermitType = [];

    switch(garageBldgNumber){
      case "70" : //27th Ave
        garageDocId = "27th_ave";
        break;
      case "59" : // 29th & Missouri
        garageDocId = "29th & Missouri";
        break;
      case "55" : // 29th Ave
        garageDocId = "29th_ave_garage";
        break;
      case "44" : // 31st Ave
        garageDocId = "31st_ave_garage";
        break;
      case "7"  : // 33rd Ave
        garageDocId = "33rd_ave_garage";
        break;
      case "80" : // Grove
        garageDocId = "grove_garage";
        break;
      case "15" : // Halo
        garageDocId = "halo_garage";
        break;
      case "75" : // Rivers
        garageDocId = "rivers_garage";
        break;
      default: // Error Handle
        return "Not A Valid Parking Garage Number";
    }

    bool check = false;

    await db.collection('users').doc(auth_uid).get().then((DocumentSnapshot snapshot){
      userPermitType = snapshot['permit_type'];
    });

    await db.collection('garages').doc(garageDocId).get().then((DocumentSnapshot docSnap){
      acceptedPermitType = docSnap['accepted_permit_types'];
    });

    for(int idx = 0; idx < acceptedPermitType.length; idx++){

      if(userPermitType.toString() == acceptedPermitType[idx].toString()){
        check = true;
      }
    }

    if(check){
      // THis block updates the Garages fields
      await db.collection('garages').doc(garageDocId).get().then((
          DocumentSnapshot docSnap) {
        spotsOccupied = docSnap['occupied_spots'];
        spotsOccupied -= 1;

        db.collection("garages").doc(garageDocId).update({
          "occupied_spots": spotsOccupied,
          "disp_occupied": (spotsOccupied.toString())
        });
      });

      // This Block Updates the User doc fields
      db.collection("users").doc(auth_uid).update({
        "parked_in": parkingSpaceNumber,
        "parked_status": "true"
      });

    }else{
      return "Invalid Permit for This Garage";
    }
  }


  /**
   * This method is used to determine the validity of the passed permit ID value and assoaciate a type
   * of permit with the ID. THis then is updated in the user's collection and permits collection
   */
  Future<String?> validatePermit({required String licensePlate, required String permitIdNumber}) async{

    // add try catch - return succfussl string message of  (e)
    String auth_uid = await FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('permits').doc(auth_uid).get();
      String permitIDAbbrev = permitIdNumber.substring(0, 2);
      String permitType;

    if(
    permitIDAbbrev.toUpperCase() == "PX" ||
        permitIDAbbrev.toUpperCase() == "HT" ||
        permitIDAbbrev.toUpperCase() == "QL"
    ){
      permitType = "Student";
    }else if(
    permitIDAbbrev.toUpperCase() == "ZR" ||
        permitIDAbbrev.toUpperCase() == "PF" ||
        permitIDAbbrev.toUpperCase() == "KY"
    ){
      permitType = "Faculty";
    }else{
      permitType = "Guest";
    }


      if(documentSnapshot.exists){

        db.collection('permits').doc(auth_uid).update({
            'permit_id': permitIdNumber,
            'license_plate': licensePlate,
            'permit_type': permitType
        });

        db.collection('users').doc(auth_uid).update({
          'permit_id_number': permitIdNumber,
          'license_plate_number': licensePlate,
          'permit_type': permitType
        });

        return "success";
      }else if(!documentSnapshot.exists){
        db.collection('permits').doc(auth_uid).set({
          'permit_id': permitIdNumber,
          'license_plate': licensePlate,
          'permit_type': permitType
        });

        db.collection('users').doc(auth_uid).update({
          'permit_id_number': permitIdNumber,
          'license_plate_number': licensePlate,
          'permit_type': permitType
        });
        return "success";
      }else{

        return "failed";
      }
  }


  /**
   * This metho is primarily used as a test method to verify a conncetion to the
   * FIrestore instance and to verify the contents of it's collections.
   */
  Future<int> countDocument(String collectionName) async{

    var collectionReference = FirebaseFirestore.instance.collection(collectionName);
    var snapshot = await collectionReference.count().get();
    return snapshot.count;
  }

}// Authentication Service Class


