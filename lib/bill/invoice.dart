// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class InvoicePage extends StatefulWidget {
//   @override
//   State<InvoicePage> createState() => _InvoicePageState();
// }
//
// class _InvoicePageState extends State<InvoicePage> {
//   final String customerName = "Rokesh";
//   final String ownerName = "Ramesh Kumar";
//   final String officeNumber = "9943719312";
//
//   final List<Map<String, dynamic>> items = [
//     {"name": "WiFi Router", "qty": 1, "rate": 1200},
//     {"name": "Installation Service", "qty": 1, "rate": 500},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final int totalAmount =
//     items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int));
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           "Invoice",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.deepPurple,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.share, color: Colors.white),
//             onPressed: () =>
//             tooltip: 'Share via WhatsApp',
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildHeader(ownerName, officeNumber),
//             SizedBox(height: 20),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Customer: $customerName",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.deepPurple.shade100, width: 1),
//                 borderRadius: BorderRadius.all(Radius.circular(5)),
//               ),
//               child: Column(
//                 children: [
//                   _buildTableHeader(),
//                   ...items.map((item) => _buildRow(item)).toList(),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Align(
//                 alignment: Alignment.topRight,
//                 child: Text(
//                   "Total: ₹$totalAmount",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//             ),
//             Spacer(),
//             Center(
//               child: Text(
//                 "Thank you for your business!",
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _shareInvoiceViaWhatsApp(int totalAmount) async {
//     String invoiceText = "*INVOICE*\n\n";
//     invoiceText += "🏢 *Company:* $ownerName\n";
//     invoiceText += "📞 *Mobile:* $officeNumber\n";
//     invoiceText += "📧 *Email:* info@zinfiton.com\n\n";
//     invoiceText += "👤 *Customer:* $customerName\n\n";
//     invoiceText += "*ITEMS:*\n";
//     invoiceText += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
//
//     for (var item in items) {
//       int itemTotal = item["qty"] * item["rate"];
//       invoiceText += "${item["name"]}\n";
//       invoiceText += "Qty: ${item["qty"]} × ₹${item["rate"]} = ₹$itemTotal\n\n";
//     }
//
//     invoiceText += "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
//     invoiceText += "💰 *TOTAL: ₹$totalAmount*\n\n";
//     invoiceText += "🙏 Thank you for your business!";
//
//     // URL encode the message
//     String encodedText = Uri.encodeComponent(invoiceText);
//
//     // WhatsApp URL scheme
//     String whatsappUrl = "whatsapp://send?text=$encodedText";
//
//     try {
//       Uri uri = Uri.parse(whatsappUrl);
//       if (await canLaunchUrl(uri)) {
//         await launchUrl(uri);
//       } else {
//         // If WhatsApp is not installed, show a message
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("WhatsApp is not installed on this device"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     } catch (e) {
//       // Handle any errors
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Unable to share via WhatsApp: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//   Widget _buildHeader(String owner, String number) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Image(
//               image: AssetImage("asset/image/svg/log.png"),
//               height: 80,
//               width: 120,
//             ),
//           ],
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: const [
//             Text("Mobile No: 9943719312", style: TextStyle(fontSize: 16)),
//             Text("Email: info@zinfiton.com", style: TextStyle(fontSize: 16)),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTableHeader() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       color: Colors.deepPurple.shade100,
//       child: Row(
//         children: const [
//           Expanded(flex: 4, child: Text("Item")),
//           Expanded(flex: 2, child: Text("Qty")),
//           Expanded(flex: 2, child: Text("Rate")),
//           Expanded(flex: 2, child: Text("Total")),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRow(Map<String, dynamic> item) {
//     final int total = item["qty"] * item["rate"];
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//       child: Row(
//         children: [
//           Expanded(flex: 4, child: Text(item["name"])),
//           Expanded(flex: 2, child: Text("${item["qty"]}")),
//           Expanded(flex: 2, child: Text("₹${item["rate"]}")),
//           Expanded(flex: 2, child: Text("₹$total")),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class InvoicePage extends StatefulWidget {
  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final String customerName = "Rokesh";
  final String ownerName = "Ramesh Kumar";
  final String officeNumber = "9943719312";

  final List<Map<String, dynamic>> items = [
    {"name": "WiFi Router", "qty": 1, "rate": 1200},
    {"name": "Installation Service", "qty": 1, "rate": 500},
  ];

  @override
  Widget build(BuildContext context) {
    final int totalAmount = items.fold(
        0, (sum, item) => sum + (item["qty"] * item["rate"] as int));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Invoice", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () => _generatePDF(totalAmount),
              tooltip: 'Generate PDF',
            ),

          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Customer: $customerName",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border:
                  Border.all(color: Colors.deepPurple.shade100, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Column(
                  children: [
                    _buildTableHeader(),
                    ...items.map((item) => _buildRow(item)).toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "Total: ₹$totalAmount",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              Spacer(),
              Center(
                child: Text(
                  "Thank you for your business!",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image(
          image: AssetImage("asset/image/svg/log.png"),
          height: 80,
          width: 120,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text("Mobile No: 9943719312", style: TextStyle(fontSize: 16)),
            Text("Email: info@zinfiton.com", style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      color: Colors.deepPurple.shade100,
      child: Row(
        children: const [
          Expanded(flex: 4, child: Text("Item")),
          Expanded(flex: 2, child: Text("Qty")),
          Expanded(flex: 2, child: Text("Rate")),
          Expanded(flex: 2, child: Text("Total")),
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> item) {
    final int total = item["qty"] * item["rate"];
    return GestureDetector(
      onTap: () => (item),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Row(
          children: [
            Expanded(flex: 4, child: Text(item["name"])),
            Expanded(flex: 2, child: Text("${item["qty"]}")),
            Expanded(flex: 2, child: Text("₹${item["rate"]}")),
            Expanded(flex: 2, child: Text("₹$total")),
          ],
        ),
      ),
    );
  }



  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _generatePDF(int totalAmount) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      PdfDocument document = PdfDocument();
      PdfPage page = document.pages.add();
      PdfGraphics graphics = page.graphics;

      // Use standard font (built-in) — only ASCII characters
      final PdfFont standardFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
      final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
      final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);

      double currentY = 50;

      graphics.drawString('RELIE tech', titleFont,
          brush: PdfBrushes.aliceBlue,
          bounds: Rect.fromLTWH(50, currentY, 200, 30));

      graphics.drawString('Mobile No: $officeNumber\nEmail: info@zinfiton.com', standardFont,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(350, currentY, 200, 40));

      currentY += 80;
      graphics.drawString('INVOICE', headerFont,
          brush: PdfBrushes.aliceBlue,
          bounds: Rect.fromLTWH(50, currentY, 100, 20));

      currentY += 40;
      graphics.drawString('Customer: $customerName', standardFont,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(50, currentY, 200, 20));

      currentY += 40;

      PdfGrid grid = PdfGrid();
      grid.style = PdfGridStyle(
        font: standardFont,
        cellPadding: PdfPaddings(left: 8, right: 8, top: 8, bottom: 8),
      );

      grid.columns.add(count: 4);
      grid.columns[0].width = 200;
      grid.columns[1].width = 80;
      grid.columns[2].width = 80;
      grid.columns[3].width = 80;

      PdfGridRow headerRow = grid.headers.add(1)[0];
      headerRow.cells[0].value = 'Item';
      headerRow.cells[1].value = 'Qty';
      headerRow.cells[2].value = 'Rate';
      headerRow.cells[3].value = 'Total';
      headerRow.style = PdfGridRowStyle(
        backgroundBrush: PdfBrushes.lightGray,
        font: headerFont,
      );

      for (var item in items) {
        PdfGridRow row = grid.rows.add();
        int itemTotal = item["qty"] * item["rate"];
        row.cells[0].value = item["name"];
        row.cells[1].value = item["qty"].toString();
        row.cells[2].value = 'Rs.${item["rate"]}'; // Replace ₹ with Rs.
        row.cells[3].value = 'Rs.$itemTotal';
      }

      grid.draw(page: page, bounds: Rect.fromLTWH(50, currentY, 450, 0));
      currentY += grid.rows.count * 25 + 50;

      graphics.drawString('Total: Rs.$totalAmount', headerFont,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(350, currentY, 150, 50));

      currentY += 60;
      graphics.drawString('Thank you for your business!', standardFont,
          brush: PdfBrushes.gray,
          bounds: Rect.fromLTWH(50, currentY, 300, 20));

      List<int> bytes = await document.save();
      document.dispose();

      Directory? directory = await getExternalStorageDirectory();
      String path = '${directory!.path}/invoice_${DateTime.now().millisecondsSinceEpoch}.pdf';
      File file = File(path);
      await file.writeAsBytes(bytes);

      Navigator.pop(context);
      await Share.shareXFiles([XFile(path)], text: 'Invoice for $customerName');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF generated and shared successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      Navigator.pop(context);
      _showError('Error generating PDF: $e');
    }
  }

}
