//
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//
// // Replace your _generatePDF with this:
// Future<void> _generateAndViewPDF(int totalAmount) async {
//   final pdf = pw.Document();
//
//   // Load Logo
//   final logo = await rootBundle.load('assets/image/svg/log.png');
//   final logoImage = pw.MemoryImage(logo.buffer.asUint8List());
//
//   pdf.addPage(
//     pw.Page(
//       pageFormat: PdfPageFormat.a4,
//       build: (context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // 🔹 Header Row (Logo + Contact Info)
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Image(logoImage, width: 100, height: 60),
//                 pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.end,
//                   children: [
//                     pw.Text("Mobile No: $officeNumber",
//                         style: pw.TextStyle(fontSize: 14)),
//                     pw.Text("Email: info@zinfiton.com",
//                         style: pw.TextStyle(fontSize: 14)),
//                   ],
//                 ),
//               ],
//             ),
//             pw.SizedBox(height: 20),
//
//             // 🔹 Title Center
//             pw.Center(
//               child: pw.Text(
//                 documentType.toUpperCase(),
//                 style: pw.TextStyle(
//                     fontSize: 22, fontWeight: pw.FontWeight.bold),
//               ),
//             ),
//             pw.SizedBox(height: 20),
//
//             // 🔹 Customer Info Box
//             pw.Container(
//               padding: const pw.EdgeInsets.all(10),
//               decoration: pw.BoxDecoration(
//                 borderRadius: pw.BorderRadius.circular(8),
//                 border: pw.Border.all(color: PdfColors.teal, width: 1),
//                 color: PdfColors.teal100,
//               ),
//               child: pw.Row(
//                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                 children: [
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text("Customer: $customerName",
//                           style: pw.TextStyle(
//                               fontSize: 14, fontWeight: pw.FontWeight.bold)),
//                       pw.SizedBox(height: 5),
//                       pw.Text("Mobile: $customerMobile"),
//                       if (customerEmail.isNotEmpty)
//                         pw.Text("Email: $customerEmail"),
//                     ],
//                   ),
//                   pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.end,
//                     children: [
//                       pw.Text(
//                           "Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
//                       pw.Text(
//                           "Time: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}"),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             pw.SizedBox(height: 20),
//
//             // 🔹 Items Table
//             pw.Table.fromTextArray(
//               headers: ['Item', 'Qty', 'Rate', 'Total'],
//               data: items
//                   .map((item) => [
//                 item['name'],
//                 item['qty'].toString(),
//                 "₹${item['rate']}",
//                 "₹${item['qty'] * item['rate']}",
//               ])
//                   .toList(),
//               headerStyle: pw.TextStyle(
//                   fontWeight: pw.FontWeight.bold, color: PdfColors.white),
//               headerDecoration: pw.BoxDecoration(color: PdfColors.teal),
//               cellHeight: 28,
//               cellAlignments: {
//                 0: pw.Alignment.centerLeft,
//                 1: pw.Alignment.center,
//                 2: pw.Alignment.center,
//                 3: pw.Alignment.centerRight,
//               },
//             ),
//             pw.SizedBox(height: 20),
//
//             // 🔹 Total
//             pw.Align(
//               alignment: pw.Alignment.centerRight,
//               child: pw.Text("Total: ₹$totalAmount",
//                   style: pw.TextStyle(
//                       fontSize: 16, fontWeight: pw.FontWeight.bold)),
//             ),
//             pw.SizedBox(height: 10),
//
//             // 🔹 Footer
//             pw.Center(
//               child: pw.Text("Valid for 7 days",
//                   style: pw.TextStyle(
//                       fontStyle: pw.FontStyle.italic,
//                       color: PdfColors.grey700)),
//             ),
//           ],
//         );
//       },
//     ),
//   );
//
//   // 🔹 Show PDF inside app
//   await Printing.layoutPdf(
//       onLayout: (PdfPageFormat format) async => pdf.save());
// }
