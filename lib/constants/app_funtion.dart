// ignore_for_file: use_build_context_synchronously, avoid_web_libraries_in_flutter

import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/app_popups.dart';
import 'package:relie_nquiry/constants/firebase_functions.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:image_cropper/image_cropper.dart';

// import 'package:image_picker/image_picker.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// import 'package:share_plus/share_plus.dart';
// // import 'package:smart_dizi_biz/constants/app_button.dart';
// import 'package:smart_dizi_biz/constants/app_colors.dart';
// import 'package:smart_dizi_biz/constants/text_fields.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

// import 'package:open_file/open_file.dart' as open_file;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

// import 'package:image/image.dart' as img; // Import the image package

class AppFunctions {
  static List<double> extractCoordinates(String url) {
    //  RegExp regex = RegExp(r"([-+]?\d*\.?\d+),([-+]?\d*\.?\d+)");
    // RegExp regex = RegExp("!3d(-?\d+(?:\.\d+)?)!4d(-?\d+(?:\.\d+))");
    // RegExp regex = RegExp("r'@(-?\d{1,3}\.\d+),(-?\d{1,3}\.\d+");
    // RegExp regex = RegExp(r'@(-?\d{1,3}\.\d+),(-?\d{1,3}\.\d+)');

    RegExp regex = RegExp(r'@(-?\d{1,3}\.\d+),(-?\d{1,3}\.\d+)');

    Match? match = regex.firstMatch(url);
    if (match != null) {
      double lat = double.parse(match.group(1)!);
      double lng = double.parse(match.group(2)!);
      return [lat, lng];
    } else {
      return [0.0, 0.0]; // Default values if coordinates not found
    }
  }

  static Future<String?> pickImageWithoutCrop({
    required String pathName,
    required BuildContext context,
  }) async {
    String finalFiles = "";

    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (pickedFile != null) {
      AppPopups.circularProgressIndicator(context);
      String pickedImage = await FirebaseFunctions.uploadFileToStorage(
        file: pickedFile.files.single.bytes!,
        path: "${pathName}/${DateTime.now().toString()}.png",
        metaData: "image/png",
      );
      finalFiles = pickedImage;
      Navigator.pop(context);
    }
    return finalFiles;
  }

  /// crop
  static Future<String?> pickImageWithImageCropper({
    required String pathName,
    CropStyle cropStyle = CropStyle.rectangle,
    required BuildContext context,
  }) async {
    String? finalFile;

    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    // print("pickedFile-${pickedFile}");
    // print("pickedFile-${pickedFile!.files.single.path!}");

    if (pickedFile != null) {
      AppPopups.circularProgressIndicator(context);
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        uiSettings: [
          /// Android Crop
          AndroidUiSettings(
            toolbarTitle: 'Image Cropper',
            toolbarColor: AppColors.appColor,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              //CropAspectRatioPresetCustom(),
            ],
          ),

          /// IOS Crop
          IOSUiSettings(title: 'Image Cropper'),

          /// web Crop
          // WebUiSettings(
          //   context: context,
          //   presentStyle: WebPresentStyle.dialog,
          //   dragMode: WebDragMode.crop,
          //   themeData: WebThemeData(),
          //   viewwMode: WebViewMode.mode_0,
          //   cropBoxMovable: true,
          //   cropBoxResizable: true,
          //   movable: true,
          //   rotatable: true,
          //   scalable: true,
          //   zoomable: true,
          //   zoomOnTouch: true,
          //   zoomOnWheel: true,
          //   size: const CropperSize(width: 450, height: 350),
          // ),
          //   WebUiSettings(
          //     context: context,
          //     zoomable: true,cropBoxMovable: true,zoomOnWheel: true,
          //     size: const CropperSize(
          //       width: 450,
          //       height: 350,
          //     ),themeData: WebThemeData(),dragMode: WebDragMode.crop,
          // presentStyle: WebPresentStyle.dialog,initialAspectRatio:
          //   ),
        ],
      );
      print("croppedFile-${croppedFile}");

      if (croppedFile != null) {
        // ConvertcroppedFile to Uint8List
        Uint8List croppedFileData = await croppedFile.readAsBytes();

        // Upload the cropped image and get the download URL
        String? downloadUrl = await FirebaseFunctions.uploadFileToStorage(
          file: croppedFileData,
          path: "$pathName/${DateTime.now().toString()}.png",
          metaData: "image/png",
        );

        if (downloadUrl != "") {
          finalFile = downloadUrl; // Store the download URL in finalFile
        }
      }
      print("finalFile-${finalFile}");

      Navigator.pop(context);
    } else {
      // Handle the case where no file was selected or the result is empty
      print("No file selected or file list is empty.");
    }
    return finalFile;
  }

  /// function for launch url
  static Future<void> urlLauncher(String url) async {
    String launchUrl = url;
    if (await canLaunch(launchUrl)) {
      await launch(launchUrl);
    } else {
      throw "Some error Occurred";
    }
  }

  //
  // static LatLng extractLatLngFromUrl(String url) {
  //   Uri uri = Uri.parse(url);
  //   String query = uri.query;
  //   List<String> queryParts = query.split('&');
  //   double lat = 11.9367647, lng = 79.8267856;
  //
  //   for (String part in queryParts) {
  //     if (part.startsWith('query=')) {
  //       String coordinates = part.substring(6); // Remove 'query='
  //       List<String> coords = coordinates.split(',');
  //       lat = double.parse(coords[0]);
  //       lng = double.parse(coords[1]);
  //       break;
  //     }
  //   }
  //
  //   return LatLng(lat, lng);
  // }
  //
  // static Future shareQRImage({required url}) async {
  //   final image = await QrPainter(
  //     data: url,
  //     version: QrVersions.auto,
  //     gapless: false,
  //     color: Colors.black,
  //     emptyColor: Colors.white,
  //   ).toImageData(200.0); // Generate QR code image data
  //
  //   final filename = 'qr_code.png';
  //   final tempDir =
  //   await getTemporaryDirectory(); // Get temporary directory to store the generated image
  //   final file = await File('${tempDir.path}/$filename')
  //       .create(); // Create a file to store the generated image
  //   var bytes = image!.buffer.asUint8List(); // Get the image bytes
  //   await file.writeAsBytes(bytes); // Write the image bytes to the file
  //   final path = await Share.shareFiles([file.path],
  //       text: 'QR code for ${url}',
  //       subject: 'QR Code',
  //       mimeTypes: [
  //         'image/png'
  //       ]); // Share the generated image using the share_plus package
  //   //print('QR code shared to: $path');
  // }

  /// function for _launchPhone url

  static Future<void> launchPhone(String phoneNumber) async {
    final phoneUrl = 'tel:$phoneNumber';
    if (await canLaunch(phoneUrl)) {
      await launch(phoneUrl);
    } else {
      throw 'Could not launch $phoneUrl';
    }
  }

  //
  // /// function for _launchWhatsapp url
  //
  // static Future<void> launchWhatsapp(
  //     {required String whatsAppNumber, required String message}) async {
  //   final whatsAppUrl = "https://wa.me/$whatsAppNumber?text=$message";
  //   if (await canLaunch(whatsAppUrl)) {
  //     await launch(whatsAppUrl);
  //   } else {
  //     throw 'Could not launch $whatsAppUrl';
  //   }
  // }
  //
  // /// function for _launchMail url
  //
  static Future<void> launchMail(String mailId) async {
    final mailIdUrl = 'mailto:$mailId';
    if (await canLaunch(mailIdUrl)) {
      await launch(mailIdUrl);
    } else {
      throw 'Could not launch $mailIdUrl';
    }
  }

  //
  // static Future<void> onShare(String url, BuildContext context) async {
  //   var uri = url;
  //   if (uri.isNotEmpty) {
  //     await Share.shareUri(Uri.parse(uri));
  //   } else {}
  // }

  // static Future<String?> pickImageWithoutCrop({
  //   required String pathName,
  //   required BuildContext context,
  // }) async {
  //   String finalFiles = "";
  //   final XFile? pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //   );
  //   // CircularProgressIndicator(color: AppColors.appColor);
  //
  //   if (pickedFile != null) {
  //     AppPopups.circularProgressIndicator(context);
  //     String pickedImage = await uploadFileToStorage(
  //       file: File(pickedFile.path),
  //       path: "${pathName}/${DateTime.now()}.png",
  //       metaData: "image/png",
  //     );
  //     finalFiles = pickedImage;
  //     Navigator.pop(context);
  //   }
  //   return finalFiles;
  // }

  static Future<String> uploadFileToStorage({
    required File file,
    required String path,
    required String metaData,
  }) async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: metaData),
    );
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // static Future<File?> pickImageWithImageCropper(
  //     {CropStyle cropStyle = CropStyle.circle,
  //       CropAspectRatio? aspectRatio}) async {
  //   File? finalFile;
  //   final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (file != null) {
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: file.path,
  //       compressFormat: ImageCompressFormat.png,
  //
  //       aspectRatio: aspectRatio,
  //
  //
  //     );
  //     if (croppedFile != null) {
  //       finalFile = File(croppedFile.path);
  //     }
  //   }
  //   return finalFile;
  // }

  // static Future<void> saveImage(
  //     {required BuildContext context, required Uint8List pngBytes}) async {
  //   try {
  //     await ImageGallerySaver.saveImage(pngBytes);
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Image saved to gallery'),
  //       duration: Duration(seconds: 2),
  //     ));
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("image saving error $e");
  //     }
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Failed to save image'),
  //       duration: Duration(seconds: 2),
  //     ));
  //   }
  // }

  // static String formattedDate(DateTime date) =>
  //     DateFormat('dd / MM / yyyy').format(date);
  //
  // /// date format conversion to date time to end time of a day
  // static DateTime convertFormattedEndDateToDateTime(String formattedDate) =>
  //     DateFormat("dd / MM / yyyy hh:mm:ss").parse("$formattedDate 23:59:59");
  //
  // static DateTime convertFormattedDateToDateTime(String formattedDate) =>
  //     DateFormat("dd / MM / yyyy hh:mm:ss").parse("$formattedDate 00:00:00");

  /// LAST DAY OF THE MONTH
  static DateTime findLastDateOfTheMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month + 1, 0);

  /// FIRST DAY OF THE MONTH
  static DateTime findFirstDateOfTheMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month, 1);

  /// function for pick date
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? lastDate,
    DateTime? initialDate,
    DateTime? firstDate,
  }) async {
    lastDate ??= DateTime(3000);
    initialDate ??= DateTime.now();
    firstDate ??= DateTime(2024);
    DateTime? pickedDate;
    pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: const DatePickerThemeData(
              backgroundColor: Colors.white,
              headerBackgroundColor: AppColors.appColor,
              headerForegroundColor: Colors.white,
              todayBackgroundColor: WidgetStatePropertyAll(AppColors.darkBlue),
              todayForegroundColor: WidgetStatePropertyAll(Colors.white),
              dayForegroundColor: WidgetStatePropertyAll(Colors.black),
              // dayBackgroundColor: WidgetStatePropertyAll(Colors.amber),
              dayStyle: TextStyle(color: Colors.white),
              dayOverlayColor: WidgetStatePropertyAll(AppColors.themeRed),
              surfaceTintColor: AppColors.white,
              weekdayStyle: TextStyle(
                color: AppColors.darkRed,
                fontWeight: FontWeight.bold,
              ),
              yearForegroundColor: MaterialStatePropertyAll(AppColors.darkRed),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkRed, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return pickedDate;
  }

  static Future<Uint8List> readAssetImageData(String name) async {
    final ByteData data = await rootBundle.load(name);
    return Uint8List.fromList(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
  }

  static Future<Uint8List> readNetworkImageData(String imageUrl) async {
    return (await NetworkAssetBundle(
      Uri.parse(imageUrl),
    ).load(imageUrl)).buffer.asUint8List();
  }

  // static Future<void> saveAndLaunchFile(
  //     List<int> bytes, String fileName) async {
  //   //Get the storage folder location using path_provider package.
  //   String? path;
  //   if (Platform.isAndroid ||
  //       Platform.isIOS ||
  //       Platform.isLinux ||
  //       Platform.isWindows) {
  //     final Directory directory =
  //     await path_provider.getApplicationSupportDirectory();
  //     path = directory.path;
  //   } else {
  //     path = await PathProviderPlatform.instance.getApplicationSupportPath();
  //   }
  //   final File file =
  //   File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
  //   await file.writeAsBytes(bytes, flush: true);
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     //Launch the file (used open_file package)
  //     await open_file.OpenFile.open('$path/$fileName');
  //   } else if (Platform.isWindows) {
  //     await Process.run('start', <String>['$path\\$fileName'],
  //         runInShell: true);
  //   } else if (Platform.isMacOS) {
  //     await Process.run('open', <String>['$path/$fileName'], runInShell: true);
  //   } else if (Platform.isLinux) {
  //     await Process.run('xdg-open', <String>['$path/$fileName'],
  //         runInShell: true);
  //   }
  // }

  static Future<Uint8List> networkImageToBytes(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      ui.Codec codec = await ui.instantiateImageCodec(response.bodyBytes);
      ui.FrameInfo frame = await codec.getNextFrame();
      ByteData? byteData = await frame.image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      return byteData!.buffer.asUint8List();
    } else {
      throw Exception('Failed to load network image');
    }
  }

  static Future<Uint8List> assetImageToBytes(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    ui.FrameInfo frame = await codec.getNextFrame();
    ByteData? byteData = await frame.image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty || value == "") {
      return 'Please enter email';
    }
    // Using a regular expression for email validation
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// function for time picker
  static Future<TimeOfDay?> pickTime(BuildContext context) async {
    TimeOfDay? pickedTime;
    pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              confirmButtonStyle: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  TextStyle(color: AppColors.darkRed),
                ),
              ),
              cancelButtonStyle: ButtonStyle(
                textStyle: WidgetStatePropertyAll(
                  TextStyle(color: Colors.black),
                ),
              ),
              backgroundColor: Colors.white,
              dialHandColor: AppColors.appColor.withOpacity(0.5),
              dayPeriodColor: AppColors.appColor,
              dayPeriodTextColor: Colors.black,
              dialBackgroundColor: Colors.grey.shade200,
              dialTextColor: AppColors.appColor,
              hourMinuteColor: Colors.grey.shade200,
              hourMinuteTextColor: AppColors.appColor,
              hourMinuteShape: const CircleBorder(),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color>((
                  states,
                ) {
                  if (states.contains(MaterialState.disabled)) {
                    return Colors.grey;
                  }
                  return Colors
                      .red; // Default to Cancel color (Cancel comes first in dialog)
                }),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    return pickedTime;
  }
}
