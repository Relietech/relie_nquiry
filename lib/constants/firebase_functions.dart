// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirebaseFunctions {
  /// function for upload file to storage
  static Future<String> uploadFileToStorage({
    required Uint8List file,
    required String path,
    required String metaData,
  }) async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask =
        ref.putData(file, SettableMetadata(contentType: metaData));
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

}
