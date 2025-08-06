import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:relie_nquiry/constants/app_constants.dart';

class EnquiryService {
  static Future<String?> addEnquiry({
    required String name,
    required String mobile,
    required String description,
    required String address,
    required String email,
    required String collage,
    required String formType,
    required String selectedEnquiryType,
    required DateTime followUpDate,
    required String followUpTime,

    String? internshipPursuingCourse,String? internshipCourseName,
    String? internshipPursuingYear,
    String? internshipDuration,

    String? trainingQualification,
    String? trainingCompletedYear,
    String? trainingCourseName,

    String? jobQualification,String? jobName,
    String? jobFresherDomain,
    String? jobFresherSkill,

    String? jobExperiencedYear,
    String? jobExperiencedMessage,

    // String? serviceTitle,
    String? otherTitle,
    String? productName,
    String? productPrice,
    String? productModel,
    String? eventName,
    DateTime? eventDate,
  }) async {
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return "User not logged in";

      // Step 1: Get employee_id from users collection
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('subscription')
          .doc(AppConstants.companyName)
          .collection("users")
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        return "User document not found";
      }

      final data = userDoc.data() as Map<String, dynamic>;

      final String employeeId =
          (data['employee_id'] ?? '').toString().trim().isNotEmpty
          ? data['employee_id']
          : "Super Admin";
      // if (employeeId == null || employeeId.isEmpty) {
      //   return "employee_id not found";
      // }

      final enquiryCollection = FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("enquiry");

      final docRef = await enquiryCollection.add({
        "form_type": formType,
        "user_uid": uid,

        /// Bool indicators
        "isInternship": selectedEnquiryType == 'Internship',
        "isTraining": selectedEnquiryType == 'Training',
        "isJobFresher": selectedEnquiryType == 'Job/Career' && jobExperiencedYear == null,
        "isJobExperienced": selectedEnquiryType == 'Job/Career' && jobExperiencedYear != null,

        "internshipPursuingCourse": internshipPursuingCourse,"internshipCourseName": internshipCourseName,
        "internshipPursuingYear": internshipPursuingYear,
        "internshipDuration": internshipDuration,

        "trainingQualification": trainingQualification,
        "trainingCompletedYear": trainingCompletedYear,
        "trainingCourseName": trainingCourseName,

        "jobQualification": jobQualification,"jobName": jobName,

        "jobFresherDomain": jobFresherDomain,
        "jobFresherSkill": jobFresherSkill,

        "jobExperiencedYear": jobExperiencedYear,
        "jobExperiencedMessage": jobExperiencedMessage,

        //"service_title": serviceTitle,
        "others_title": otherTitle,
        "event_name": eventName,
        "event_date": eventDate,
        "product_model": productModel,
        "product_name": productName,
        "product_price": productPrice,

        "name": name,
        "mobile": mobile,
        "email": email,
        "collage": collage,
        "address": address,
        "status": "Open",
        "employee_id": employeeId,
        "docId": "",
        "created_at": Timestamp.now(),
        "company": AppConstants.companyName,
        "quotation": "",
        "follow_up_date": followUpDate,
        "follow_up_time": followUpTime,
        "followup_description": description,
        "followup_history": [
          {
            "date": followUpDate,
            "time": followUpTime,
            "status": "Open",
            "description": description,
            "user_uid": uid,
          },
        ],
      });

      await docRef.update({"docId": docRef.id});

      // Step 4: Optional notification
      sendNotification(data: data, formType: formType);
      return null;
    } catch (e) {
      return "Error adding enquiry: ${e.toString()}";
    }
  }

  static Future<void> sendNotificationStatus({
    required Map<String, dynamic> data,
    required String formType,
    required String status, // contains at least: name, role, uid
  }) async {
    try {
      final String currentRole = data['role'];
      final String currentName = data['name'];
      final String currentUid = data['uid'];
      final String currentEmpId = data['employee_id'];

      // 🔁 1. Skip notification creation if Super Admin created the enquiry
      if (currentRole == 'Super Admin') {
        print("Super Admin created enquiry – no notification needed.");
        return;
      }

      // 🔁 2. Get all Admins and Super Admins
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection('users')
          .where('role', whereIn: ['Super Admin', 'Admin'])
          .get();

      // 🔁 3. Filter out the sender (so they don't get notified)
      List<String> uidList = userSnapshot.docs
          .where((doc) => doc.id != currentUid)
          .map((doc) => doc.id)
          .toList();

      // 🔁 4. Compose message
      String message =
          "${formType} Enquiry Status updated by $currentName ($currentEmpId) - Status: ${status}";

      // 🔁 5. Store notification in Firestore
      await FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("AppNotification")
          .doc()
          .set({
            "msg": message,
            "page": "Enquiry",
            "timestamp": Timestamp.now(),
            "title": "Enquiry",
            "topic": uidList,
            "user_uid": "",
            "enquiryId": "",
            "deletedList": [],
            "seenList": [],
          });

      print("Notification sent to Admins/Super Admins.");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  static Future<void> sendNotificationFolloup({
    required Map<String, dynamic> data,
    required String formType, // contains at least: name, role, uid
  }) async {
    try {
      final String currentRole = data['role'];
      final String currentName = data['name'];
      final String currentUid = data['uid'];
      final String currentEmpId = data['employee_id'];

      // 🔁 1. Skip notification creation if Super Admin created the enquiry
      if (currentRole == 'Super Admin') {
        print("Super Admin created enquiry – no notification needed.");
        return;
      }

      // 🔁 2. Get all Admins and Super Admins
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection('users')
          .where('role', whereIn: ['Super Admin', 'Admin'])
          .get();

      // 🔁 3. Filter out the sender (so they don't get notified)
      List<String> uidList = userSnapshot.docs
          .where((doc) => doc.id != currentUid)
          .map((doc) => doc.id)
          .toList();

      // 🔁 4. Compose message
      String message = "Follow-up updated by $currentName ($currentEmpId)";

      // 🔁 5. Store notification in Firestore
      await FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("AppNotification")
          .doc()
          .set({
            "msg": message,
            "page": "Enquiry",
            "timestamp": Timestamp.now(),
            "title": "Enquiry",
            "topic": uidList,
            "user_uid": "",
            "enquiryId": "",
            "deletedList": [],
            "seenList": [],
          });

      print("Notification sent to Admins/Super Admins.");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  static Future<void> sendNotification({
    required Map<String, dynamic> data,
    required String formType, // contains at least: name, role, uid
  }) async {
    try {
      final String currentRole = data['role'];
      final String currentName = data['name'];
      final String currentUid = data['uid'];
      final String currentEmpId = data['employee_id'];

      // 🔁 1. Skip notification creation if Super Admin created the enquiry
      if (currentRole == 'Super Admin') {
        print("Super Admin created enquiry – no notification needed.");
        return;
      }

      // 🔁 2. Get all Admins and Super Admins
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection('users')
          .where('role', whereIn: ['Super Admin', 'Admin'])
          .get();

      // 🔁 3. Filter out the sender (so they don't get notified)
      List<String> uidList = userSnapshot.docs
          .where((doc) => doc.id != currentUid)
          .map((doc) => doc.id)
          .toList();

      // 🔁 4. Compose message
      String message =
          "New ${formType} enquiry added by $currentName ($currentEmpId)";

      // 🔁 5. Store notification in Firestore
      await FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("AppNotification")
          .doc()
          .set({
            "msg": message,
            "page": "Enquiry",
            "timestamp": Timestamp.now(),
            "title": "Enquiry",
            "topic": uidList,
            "user_uid": "",
            "enquiryId": "",
            "deletedList": [],
            "seenList": [],
          });

      print("Notification sent to Admins/Super Admins.");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> collectEnquiry() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception("User not logged in");
      }

      // 📄 Step 2: Query 'enquiry' collection where 'employee id' == employeeId
      final snapshot = await FirebaseFirestore.instance
          .collection("subscription")
          .doc(AppConstants.companyName)
          .collection("enquiry")
          .where("user_uid", isEqualTo: uid)
          .get();

      // 🔁 Step 3: Format and return results
      final enquiries = snapshot.docs.map((doc) {
        final data = doc.data();

        return data;
      }).toList();

      return enquiries;
    } catch (e) {
      print("❌ Error fetching enquiries: $e");
      return [];
    }
  }
}
