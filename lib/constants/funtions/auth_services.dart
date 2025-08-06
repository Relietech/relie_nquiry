import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> updateUserPassword({
    required String email,
    required String newPassword,
    required String company,
  }) async {
    const String functionUrl =
        'https://updateuserpasswordandfirestore-wijr4of6ca-uc.a.run.app/updateUserPasswordAndFirestore';

    try {
      final response = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
          'company': company,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['error'] ?? 'Failed to update password');
      }
    } catch (e) {
      throw Exception('API error: $e');
    }
  }

  Future<Map<String, dynamic>?> createUserViaApi(
    String email,
    String password,
  ) async {
    final url = Uri.parse(
      "https://createuseraccount-wijr4of6ca-uc.a.run.app/createUserAccount",
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ User created: $data");
        return data; // 🔁 Return UID & Email
      } else {
        final error = jsonDecode(response.body);
        print("❌ Error: ${error['error']}");
        return null;
      }
    } catch (e) {
      print("⚠️ Exception: $e");
      return null;
    }
  }

  Future<String?> employee({
    required String name,
    required String role,

    required String password,
    required String designation,
    required String mobile,
    required String employeeId,
    required String address,
    String? imageFile,
  }) async {
    try {
      // // Step 1: Register Firebase Auth User
      // UserCredential userCredential = await _auth
      //     .createUserWithEmailAndPassword(
      //       email: "${employeeId}@${AppConstants.companyName}.com",
      //       password: password,
      //     );

      final userData = await createUserViaApi(
        "${employeeId}@${AppConstants.companyName}.com",
        password,
      );

      //
      // if (userData != null) {
      //   final String uid = userData['uid'];
      //   final String email = userData['email'];
      //
      //   // ✅ Now you can store it in Firestore or local DB
      //   print("📌 UID: $uid");
      //   print("📌 Email: $email");
      //
      //   // Example Firestore store
      //   // FirebaseFirestore.instance.collection('employees').doc(uid).set({
      //   //   'email': email,
      //   //   'createdAt': FieldValue.serverTimestamp(),
      //   // });
      // } else {
      //   print("🚫 User creation failed.");
      // }

      final uid = userData!['uid'];
      final email = userData['email'];

      // Step 3: Save full employee data in Firestore
      await _firestore
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("users")
          .doc(uid)
          .set({
            "uid": uid,
            "name": name,
            "email": email,
            "userName": employeeId,
            "password": password,
            "designation": designation,
            "mobile": mobile,
            "employee_id": employeeId,
            "address": address,
            "image_path": imageFile != null ? imageFile : "",
            "role": role,
            "status": "Active",
            "company": AppConstants.companyName,
            "created_at": Timestamp.now(),
            "created_by": _auth.currentUser!.uid,
            "enquiry_type": [],
          });

      return null;
    } on FirebaseAuthException catch (e) {
      return "Auth Error: ${e.message}";
    } catch (e) {
      return "Unexpected Error: ${e.toString()}";
    }
  }

  Future<String?> registerUser({
    required String name,
    required String email,
    required String password,

    // required File imageFile,
  }) async {
    try {
      // Step 1: Register Firebase Auth User
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // Step 3: Save full user data in Firestore
      await _firestore
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("users")
          .doc(uid)
          .set({
            "uid": uid,
            "name": name,
            "email": email,
            "userName": email,
            "password": password,
            "designation": "",
            "mobile": "",
            "employee_id": "",
            "address": "",
            "image_path": "",
            "role": "Super Admin",
            "status": "Active",
            "company": AppConstants.companyName,
            "created_at": Timestamp.now(),
            "created_by": "Super Admin",
            "enquiry_type": [],
          });

      return null;
    } on FirebaseAuthException catch (e) {
      return "Auth Error: ${e.message}";
    } catch (e) {
      return "Unexpected Error: ${e.toString()}";
    }
  }

  Future<String?> addEnquiry({
    required String name,
    required String mobile,
    required String description,
    required String address,
    required String formType,
    required bool needQuotation,
    DateTime? followUpDate,
    String? serviceType,
    String? product,
    String? model,
    String? eventName,
    DateTime? eventDate,
  }) async {
    try {
      final String companyName = AppConstants.companyName;

      // Prepare the enquiry data
      final Map<String, dynamic> data = {
        'name': name,
        'mobile': mobile,
        'description': description,
        'address': address,
        'form_type': formType,
        'status': 'Open',
        'need_quotation': needQuotation,
        'created_at': Timestamp.now(),
        'follow_up_date': followUpDate != null
            ? Timestamp.fromDate(followUpDate)
            : null,
        'service_type': serviceType,
        'product': product,
        'model': model,
        'event_name': eventName,
        'event_date': eventDate != null ? Timestamp.fromDate(eventDate) : null,
      };

      // Save to Firestore under /subscription/{company}/enquiry
      final docRef = await FirebaseFirestore.instance
          .collection("subscription")
          .doc(companyName)
          .collection("enquiry")
          .add(data);

      // Add the document ID inside the document
      await docRef.update({'docId': docRef.id});

      return null; // success
    } catch (e) {
      return "Enquiry Submission Error: ${e.toString()}";
    }
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Fetch user from Firestore using 'userName'
      final userQuery = await _firestore
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection('users')
          .where("status", isEqualTo: "Active")
          .where('userName', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        return 'No user found with this username.';
      }

      final userData = userQuery.docs.first.data();
      final role = userData['role'];

      print("role:$role");

      // Step 2: Determine correct email for login
      final String loginEmail =
          // (role == "Super Admin")
          //     ? email
          //     :
          "${email.trim().toLowerCase()}@${AppConstants.companyName.toLowerCase()}.com";

      // Step 3: Attempt Firebase Auth login
      await _auth.signInWithEmailAndPassword(
        email: loginEmail,
        password: password,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseMessaging.instance.subscribeToTopic(user.uid);
        print("📩 Subscribed to topic: ${user.uid}");
      }

      // Step 4: Store role in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', role);

      return null; // Login successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No account exists with this email.';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password.';
      } else {
        return 'Authentication failed: ${e.message}';
      }
    } catch (e) {
      return 'Unexpected error: ${e.toString()}';
    }
  }
}
