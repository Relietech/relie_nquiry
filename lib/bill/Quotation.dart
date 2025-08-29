// // import 'package:flutter/material.dart';
// //
// // import 'package:syncfusion_flutter_pdf/pdf.dart';
// // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// // import 'package:flutter/services.dart';
// // import 'dart:io';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:share_plus/share_plus.dart';
// //
// // class QuotationPage extends StatefulWidget {
// //   @override
// //   State<QuotationPage> createState() => _QuotationPageState();
// // }
// //
// // class _QuotationPageState extends State<QuotationPage> {
// //   final String customerName = "Rokesh";
// //   final String ownerName = "Ramesh Kumar";
// //   final String officeNumber = "9943719312";
// //   final List<Map<String, dynamic>> items = [
// //     {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //     {"name": "Installation Service", "qty": 1, "rate": 500},    {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //     {"name": "Installation Service", "qty": 1, "rate": 500},    {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //     {"name": "Installation Service", "qty": 1, "rate": 500},    {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //     {"name": "Installation Service", "qty": 1, "rate": 500},
// //     {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //
// //   ];
// //
// //   String? _pdfPath;
// //   final PdfViewerController _pdfViewerController = PdfViewerController();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final int totalAmount = items.fold(
// //       0,
// //           (sum, item) => sum + (item["qty"] * item["rate"] as int),
// //     );
// //
// //     return SafeArea(
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         appBar: AppBar(
// //           title: Text("Quotation", style: TextStyle(color: Colors.white)),
// //           backgroundColor: Colors.teal,
// //           actions: [
// //             IconButton(
// //               icon: Icon(Icons.picture_as_pdf, color: Colors.white),
// //               onPressed: () => _generateAndViewPDF(totalAmount),
// //               tooltip: 'Generate & View PDF',
// //             ),
// //             IconButton(
// //               icon: Icon(Icons.share, color: Colors.white),
// //               onPressed: () => _sharePDF(totalAmount),
// //               tooltip: 'Share PDF',
// //             ),
// //           ],
// //         ),
// //         body: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               _buildHeader(),
// //               SizedBox(height: 20),
// //               Align(
// //                 alignment: Alignment.centerLeft,
// //                 child: Text(
// //                   "Customer: $customerName",
// //                   style: TextStyle(fontSize: 16),
// //                 ),
// //               ),
// //               SizedBox(height: 10),
// //               Container(
// //                 decoration: BoxDecoration(
// //                   border: Border.all(color: Colors.teal.shade100, width: 1),
// //                   borderRadius: BorderRadius.all(Radius.circular(5)),
// //                 ),
// //                 child: Column(
// //                   children: [
// //                     _buildTableHeader(),
// //                     ...items.map((item) => _buildRow(item)).toList(),
// //                   ],
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Align(
// //                   alignment: Alignment.topRight,
// //                   child: Text(
// //                     "Total: ₹$totalAmount",
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                   ),
// //                 ),
// //               ),
// //               Spacer(),
// //               Center(
// //                 child: Text(
// //                   "Valid for 7 days",
// //                   style: TextStyle(color: Colors.black),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Image(
// //           image: AssetImage("asset/image/svg/log.png"),
// //           height: 80,
// //           width: 120,
// //         ),
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.end,
// //           children: const [
// //             Text("Mobile No: 9943719312", style: TextStyle(fontSize: 16)),
// //             Text("Email: info@zinfiton.com", style: TextStyle(fontSize: 16)),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildTableHeader() {
// //     return Container(
// //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
// //       color: Colors.teal.shade100,
// //       child: Row(
// //         children: const [
// //           Expanded(flex: 4, child: Text("Item")),
// //           Expanded(flex: 2, child: Text("Qty")),
// //           Expanded(flex: 2, child: Text("Rate")),
// //           Expanded(flex: 2, child: Text("Total")),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRow(Map<String, dynamic> item) {
// //     final int total = item["qty"] * item["rate"];
// //     return Column(
// //       children: [
// //         GestureDetector(
// //           onTap: () => (item),
// //           child: Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
// //             child: Row(
// //               children: [
// //                 Expanded(flex: 4, child: Text(item["name"])),
// //                 Expanded(flex: 2, child: Text("${item["qty"]}")),
// //                 Expanded(flex: 2, child: Text("₹${item["rate"]}")),
// //                 Expanded(flex: 2, child: Text("₹$total")),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   void _showError(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message), backgroundColor: Colors.red),
// //     );
// //   }
// //
// //   Future<String> _generatePDF(int totalAmount) async {
// //     PdfDocument document = PdfDocument();
// //     PdfPage page = document.pages.add();
// //     PdfGraphics graphics = page.graphics;
// //
// //     // Use standard font (built-in) — only ASCII characters
// //     final PdfFont standardFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
// //     final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
// //     final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
// //
// //     double currentY = 50;
// //
// //     // Load and draw logo image
// //     try {
// //       final ByteData imageBytes = await rootBundle.load('assets/image/svg/log.png');
// //       final Uint8List imageData = imageBytes.buffer.asUint8List();
// //       final PdfBitmap image = PdfBitmap(imageData);
// //
// //       graphics.drawImage(
// //         image,
// //         Rect.fromLTWH(50, currentY, 120, 60),
// //       );
// //     } catch (e) {
// //       // If image fails to load, draw company name instead
// //       graphics.drawString('RELIE tech', titleFont,
// //           brush: PdfBrushes.teal,
// //           bounds: Rect.fromLTWH(50, currentY, 200, 30));
// //     }
// //
// //     graphics.drawString('Mobile No: $officeNumber\nEmail: info@zinfiton.com', standardFont,
// //         brush: PdfBrushes.black,
// //         bounds: Rect.fromLTWH(350, currentY, 200, 40));
// //
// //     currentY += 80;
// //     graphics.drawString('QUOTATION', headerFont,
// //         brush: PdfBrushes.teal,
// //         bounds: Rect.fromLTWH(50, currentY, 100, 20));
// //
// //     currentY += 40;
// //     graphics.drawString('Customer: $customerName', standardFont,
// //         brush: PdfBrushes.black,
// //         bounds: Rect.fromLTWH(50, currentY, 200, 20));
// //
// //     currentY += 40;
// //
// //     PdfGrid grid = PdfGrid();
// //     grid.style = PdfGridStyle(
// //       font: standardFont,
// //       cellPadding: PdfPaddings(left: 8, right: 8, top: 8, bottom: 8),
// //     );
// //
// //     grid.columns.add(count: 4);
// //     grid.columns[0].width = 200;
// //     grid.columns[1].width = 80;
// //     grid.columns[2].width = 80;
// //     grid.columns[3].width = 80;
// //
// //     PdfGridRow headerRow = grid.headers.add(1)[0];
// //     headerRow.cells[0].value = 'Item';
// //     headerRow.cells[1].value = 'Qty';
// //     headerRow.cells[2].value = 'Rate';
// //     headerRow.cells[3].value = 'Total';
// //     headerRow.style = PdfGridRowStyle(
// //       backgroundBrush: PdfBrushes.lightGray,
// //       font: headerFont,
// //     );
// //
// //     for (var item in items) {
// //       PdfGridRow row = grid.rows.add();
// //       int itemTotal = item["qty"] * item["rate"];
// //       row.cells[0].value = item["name"];
// //       row.cells[1].value = item["qty"].toString();
// //       row.cells[2].value = 'Rs.${item["rate"]}'; // Replace ₹ with Rs.
// //       row.cells[3].value = 'Rs.$itemTotal';
// //     }
// //
// //     grid.draw(page: page, bounds: Rect.fromLTWH(50, currentY, 450, 0));
// //     currentY += grid.rows.count * 25 + 50;
// //
// //     graphics.drawString('Total: Rs.$totalAmount', headerFont,
// //         brush: PdfBrushes.black,
// //         bounds: Rect.fromLTWH(350, currentY, 300, 80));
// //
// //     currentY += 60;
// //     graphics.drawString('Valid for 7 days', standardFont,
// //         brush: PdfBrushes.gray,
// //         bounds: Rect.fromLTWH(50, currentY, 300, 20));
// //
// //     List<int> pdfBytes = await document.save();
// //     document.dispose();
// //
// //     Directory? directory = await getExternalStorageDirectory();
// //     String path = '${directory!.path}/quotation_${DateTime.now().millisecondsSinceEpoch}.pdf';
// //     File file = File(path);
// //     await file.writeAsBytes(pdfBytes);
// //
// //     return path;
// //   }
// //
// //   Future<void> _generateAndViewPDF(int totalAmount) async {
// //     try {
// //       showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (context) => const Center(child: CircularProgressIndicator()),
// //       );
// //
// //       String pdfPath = await _generatePDF(totalAmount);
// //       _pdfPath = pdfPath;
// //
// //       Navigator.pop(context);
// //
// //       // Navigate to PDF Viewer
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => PDFViewerPage(
// //             pdfPath: pdfPath,
// //             title: 'Quotation - $customerName',
// //           ),
// //         ),
// //       );
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('PDF generated successfully!'), backgroundColor: Colors.green),
// //       );
// //     } catch (e) {
// //       Navigator.pop(context);
// //       _showError('Error generating PDF: $e');
// //     }
// //   }
// //
// //   Future<void> _sharePDF(int totalAmount) async {
// //     try {
// //       showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (context) => const Center(child: CircularProgressIndicator()),
// //       );
// //
// //       String pdfPath;
// //       if (_pdfPath != null && File(_pdfPath!).existsSync()) {
// //         pdfPath = _pdfPath!;
// //       } else {
// //         pdfPath = await _generatePDF(totalAmount);
// //         _pdfPath = pdfPath;
// //       }
// //
// //       Navigator.pop(context);
// //       await Share.shareXFiles([XFile(pdfPath)], text: 'Quotation for $customerName');
// //
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('PDF shared successfully!'), backgroundColor: Colors.green),
// //       );
// //     } catch (e) {
// //       Navigator.pop(context);
// //       _showError('Error sharing PDF: $e');
// //     }
// //   }
// // }
// //
// // // Separate PDF Viewer Page
// // class PDFViewerPage extends StatefulWidget {
// //   final String pdfPath;
// //   final String title;
// //
// //   const PDFViewerPage({Key? key, required this.pdfPath, required this.title}) : super(key: key);
// //
// //   @override
// //   State<PDFViewerPage> createState() => _PDFViewerPageState();
// // }
// //
// // class _PDFViewerPageState extends State<PDFViewerPage> {
// //   final PdfViewerController _pdfViewerController = PdfViewerController();
// //   int _currentPageNumber = 1;
// //   int _totalPages = 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold( backgroundColor: Colors.white,
// //         appBar: AppBar(
// //           title: Text(widget.title, style: TextStyle(color: Colors.white)),
// //           backgroundColor: Colors.teal,
// //           actions: [
// //             IconButton(
// //               icon: Icon(Icons.zoom_in, color: Colors.white),
// //               onPressed: () => _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25,
// //               tooltip: 'Zoom In',
// //             ),
// //             IconButton(
// //               icon: Icon(Icons.zoom_out, color: Colors.white),
// //               onPressed: () => _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25,
// //               tooltip: 'Zoom Out',
// //             ),
// //             IconButton(
// //               icon: Icon(Icons.share, color: Colors.white),
// //               onPressed: () => _sharePDF(),
// //               tooltip: 'Share PDF',
// //             ),
// //           ],
// //         ),
// //         body: Column(
// //           children: [
// //             // Page Navigation Bar
// //             Container(
// //               padding: EdgeInsets.all(8.0),
// //               color: Colors.teal.shade50,
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   IconButton(
// //                     icon: Icon(Icons.navigate_before),
// //                     onPressed: _currentPageNumber > 1 ? () => _pdfViewerController.previousPage() : null,
// //                   ),
// //                   Text(
// //                     'Page $_currentPageNumber of $_totalPages',
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                   ),
// //                   IconButton(
// //                     icon: Icon(Icons.navigate_next),
// //                     onPressed: _currentPageNumber < _totalPages ? () => _pdfViewerController.nextPage() : null,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             // PDF Viewer
// //             Expanded(
// //               child: SfPdfViewer.file(
// //                 File(widget.pdfPath),
// //                 controller: _pdfViewerController,
// //                 onDocumentLoaded: (PdfDocumentLoadedDetails details) {
// //                   setState(() {
// //                     _totalPages = details.document.pages.count;
// //                   });
// //                 },
// //                 onPageChanged: (PdfPageChangedDetails details) {
// //                   setState(() {
// //                     _currentPageNumber = details.newPageNumber;
// //                   });
// //                 },
// //                 enableDoubleTapZooming: true,
// //                 enableTextSelection: true,
// //                 canShowScrollHead: true,
// //                 canShowScrollStatus: true,
// //                 canShowPaginationDialog: true,
// //               ),
// //             ),
// //           ],
// //         ),
// //         floatingActionButton: FloatingActionButton(
// //           onPressed: () => _pdfViewerController.jumpToPage(1),
// //           backgroundColor: Colors.teal,
// //           child: Icon(Icons.first_page, color: Colors.white),
// //           tooltip: 'Go to First Page',
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _sharePDF() async {
// //     try {
// //       await Share.shareXFiles([XFile(widget.pdfPath)], text: widget.title);
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error sharing PDF: $e'), backgroundColor: Colors.red),
// //       );
// //     }
// //   }
// // }
// //
// // import 'package:flutter/material.dart';
// // import 'package:syncfusion_flutter_pdf/pdf.dart';
// // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// // import 'package:flutter/services.dart';
// // import 'dart:io';
// // import 'package:path_provider/path_provider.dart';
// // import 'package:share_plus/share_plus.dart';
// //
// // class QuotationPage extends StatefulWidget {
// //   final String? customerName;
// //   final String? customerMobile;
// //   final String? customerEmail;
// //   final List<Map<String, dynamic>>? items;
// //   final String? documentType; // 'Bill' or 'Quotation'
// //
// //   const QuotationPage({
// //     Key? key,
// //     this.customerName,
// //     this.customerMobile,
// //     this.customerEmail,
// //     this.items,
// //     this.documentType,
// //   }) : super(key: key);
// //
// //   @override
// //   State<QuotationPage> createState() => _QuotationPageState();
// // }
// //
// // class _QuotationPageState extends State<QuotationPage> {
// //   late String customerName;
// //   late String customerMobile;
// //   late String customerEmail;
// //   late List<Map<String, dynamic>> items;
// //   late String documentType;
// //
// //   final String ownerName = "Ramesh Kumar";
// //   final String officeNumber = "9943719312";
// //
// //   // Default items if none provided
// //   final List<Map<String, dynamic>> defaultItems = [
// //     {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //     {"name": "Installation Service", "qty": 1, "rate": 500},
// //     {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //     {"name": "Installation Service", "qty": 1, "rate": 500},
// //     {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //     {"name": "Installation Service", "qty": 1, "rate": 500},
// //     {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //     {"name": "Installation Service", "qty": 1, "rate": 500},
// //     {"name": "WiFi Router", "qty": 1, "rate": 1200},
// //   ];
// //
// //   String? _pdfPath;
// //   final PdfViewerController _pdfViewerController = PdfViewerController();
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Initialize with provided data or defaults
// //     customerName = widget.customerName ?? "Rokesh";
// //     customerMobile = widget.customerMobile ?? "9876543210";
// //     customerEmail = widget.customerEmail ?? "";
// //     items = widget.items ?? defaultItems;
// //     documentType = widget.documentType ?? "Quotation";
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final int totalAmount = items.fold(
// //       0,
// //           (sum, item) => sum + (item["qty"] * item["rate"] as int),
// //     );
// //
// //     return SafeArea(
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         appBar: AppBar(
// //           title: Text("$documentType - $customerName", style: TextStyle(color: Colors.white)),
// //           backgroundColor: Colors.teal,
// //           actions: [
// //             IconButton(
// //               icon: Icon(Icons.save_alt, color: Colors.white),
// //               onPressed: () => _generateAndViewPDF(totalAmount),
// //               tooltip: 'Generate & View PDF',
// //             ),
// //
// //           ],
// //         ),
// //         body: Padding(
// //           padding: const EdgeInsets.all(16),
// //           child: Column(
// //             children: [
// //               _buildHeader(),
// //               SizedBox(height: 20),
// //               _buildCustomerInfo(),
// //               SizedBox(height: 20),
// //               Expanded(
// //                 child: Container(
// //                   decoration: BoxDecoration(
// //                     border: Border.all(color: Colors.teal.shade100, width: 1),
// //                     borderRadius: BorderRadius.all(Radius.circular(5)),
// //                   ),
// //                   child: Column(
// //                     children: [
// //                       _buildTableHeader(),
// //                       Expanded(
// //                         child: ListView.builder(
// //                           itemCount: items.length,
// //                           itemBuilder: (context, index) => _buildRow(items[index]),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.all(8.0),
// //                 child: Align(
// //                   alignment: Alignment.topRight,
// //                   child: Text(
// //                     "Total: ₹$totalAmount",
// //                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 10),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   ElevatedButton.icon(
// //                     onPressed: () => _generateAndViewPDF(totalAmount),
// //                     icon: Icon(Icons.picture_as_pdf, color: Colors.white),
// //                     label: Text('View PDF', style: TextStyle(color: Colors.white)),
// //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
// //                   ),
// //                   ElevatedButton.icon(
// //                     onPressed: () => _sharePDF(totalAmount),
// //                     icon: Icon(Icons.share, color: Colors.white),
// //                     label: Text('Share PDF', style: TextStyle(color: Colors.white)),
// //                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 10),
// //               Center(
// //                 child: Text(
// //                   "Valid for 7 days",
// //                   style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildHeader() {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Image(
// //           image: AssetImage("asset/image/svg/log.png"),
// //           height: 80,
// //           width: 120,
// //         ),
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.end,
// //           children: [
// //             Text("Mobile No: $officeNumber", style: TextStyle(fontSize: 16)),
// //             Text("Email: info@zinfiton.com", style: TextStyle(fontSize: 16)),
// //           ],
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildCustomerInfo() {
// //     return Container(
// //       padding: EdgeInsets.all(16),
// //       decoration: BoxDecoration(
// //         color: Colors.teal.shade50,
// //         borderRadius: BorderRadius.circular(8),
// //         border: Border.all(color: Colors.teal.shade200),
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             "$documentType Details",
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.bold,
// //               color: Colors.teal,
// //             ),
// //           ),
// //           SizedBox(height: 10),
// //           Row(
// //             children: [
// //               Expanded(
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text("Customer: $customerName", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
// //                     SizedBox(height: 5),
// //                     Text("Mobile: $customerMobile", style: TextStyle(fontSize: 16)),
// //                     if (customerEmail.isNotEmpty) ...[
// //                       SizedBox(height: 5),
// //                       Text("Email: $customerEmail", style: TextStyle(fontSize: 16)),
// //                     ],
// //                   ],
// //                 ),
// //               ),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.end,
// //                 children: [
// //                   Text("Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
// //                   Text("Time: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}"),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTableHeader() {
// //     return Container(
// //       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
// //       color: Colors.teal.shade100,
// //       child: Row(
// //         children: [
// //           Expanded(flex: 4, child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold))),
// //           Expanded(flex: 2, child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
// //           Expanded(flex: 2, child: Text("Rate", style: TextStyle(fontWeight: FontWeight.bold))),
// //           Expanded(flex: 2, child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget _buildRow(Map<String, dynamic> item) {
// //     final int total = item["qty"] * item["rate"];
// //     return Container(
// //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
// //       decoration: BoxDecoration(
// //         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
// //       ),
// //       child: Row(
// //         children: [
// //           Expanded(flex: 4, child: Text(item["name"], style: TextStyle(fontSize: 14))),
// //           Expanded(flex: 2, child: Text("${item["qty"]}", style: TextStyle(fontSize: 14))),
// //           Expanded(flex: 2, child: Text("₹${item["rate"]}", style: TextStyle(fontSize: 14))),
// //           Expanded(flex: 2, child: Text("₹$total", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   void _showError(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message), backgroundColor: Colors.red),
// //     );
// //   }
// //
// //   void _showSuccess(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(content: Text(message), backgroundColor: Colors.green),
// //     );
// //   }
// //
// //   Future<String> _generatePDF(int totalAmount) async {
// //     PdfDocument document = PdfDocument();
// //     PdfPage page = document.pages.add();
// //     PdfGraphics graphics = page.graphics;
// //
// //     // Use standard font (built-in) — only ASCII characters
// //     final PdfFont standardFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
// //     final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
// //     final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);
// //
// //     double currentY = 50;
// //
// //     // Load and draw logo image
// //     try {
// //       final ByteData imageBytes = await rootBundle.load('assets/image/svg/log.png');
// //       final Uint8List imageData = imageBytes.buffer.asUint8List();
// //       final PdfBitmap image = PdfBitmap(imageData);
// //
// //       graphics.drawImage(
// //         image,
// //         Rect.fromLTWH(50, currentY, 120, 60),
// //       );
// //     } catch (e) {
// //       // If image fails to load, draw company name instead
// //       graphics.drawString('RELIE tech', titleFont,
// //           brush: PdfBrushes.teal,
// //           bounds: Rect.fromLTWH(50, currentY, 200, 30));
// //     }
// //
// //     graphics.drawString('Mobile No: $officeNumber\nEmail: info@zinfiton.com', standardFont,
// //         brush: PdfBrushes.black,
// //         bounds: Rect.fromLTWH(350, currentY, 200, 40));
// //
// //     currentY += 80;
// //     graphics.drawString(documentType.toUpperCase(), headerFont,
// //         brush: PdfBrushes.teal,
// //         bounds: Rect.fromLTWH(50, currentY, 100, 20));
// //
// //     currentY += 40;
// //     // Customer details
// //     String customerDetails = 'Customer: $customerName\nMobile: $customerMobile';
// //     if (customerEmail.isNotEmpty) {
// //       customerDetails += '\nEmail: $customerEmail';
// //     }
// //     customerDetails += '\nDate: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
// //
// //     graphics.drawString(customerDetails, standardFont,
// //         brush: PdfBrushes.black,
// //         bounds: Rect.fromLTWH(50, currentY, 300, 80));
// //
// //     currentY += 100;
// //
// //     PdfGrid grid = PdfGrid();
// //     grid.style = PdfGridStyle(
// //       font: standardFont,
// //       cellPadding: PdfPaddings(left: 8, right: 8, top: 8, bottom: 8),
// //     );
// //
// //     grid.columns.add(count: 4);
// //     grid.columns[0].width = 200;
// //     grid.columns[1].width = 80;
// //     grid.columns[2].width = 80;
// //     grid.columns[3].width = 80;
// //
// //     PdfGridRow headerRow = grid.headers.add(1)[0];
// //     headerRow.cells[0].value = 'Item';
// //     headerRow.cells[1].value = 'Qty';
// //     headerRow.cells[2].value = 'Rate';
// //     headerRow.cells[3].value = 'Total';
// //     headerRow.style = PdfGridRowStyle(
// //       backgroundBrush: PdfBrushes.lightGray,
// //       font: headerFont,
// //     );
// //
// //     for (var item in items) {
// //       PdfGridRow row = grid.rows.add();
// //       int itemTotal = item["qty"] * item["rate"];
// //       row.cells[0].value = item["name"];
// //       row.cells[1].value = item["qty"].toString();
// //       row.cells[2].value = 'Rs.${item["rate"]}'; // Replace ₹ with Rs.
// //       row.cells[3].value = 'Rs.$itemTotal';
// //     }
// //
// //     grid.draw(page: page, bounds: Rect.fromLTWH(50, currentY, 450, 0));
// //     currentY += grid.rows.count * 25 + 50;
// //
// //     graphics.drawString('Total: Rs.$totalAmount', headerFont,
// //         brush: PdfBrushes.black,
// //         bounds: Rect.fromLTWH(350, currentY, 300, 80));
// //
// //     currentY += 60;
// //     graphics.drawString('Valid for 7 days', standardFont,
// //         brush: PdfBrushes.gray,
// //         bounds: Rect.fromLTWH(50, currentY, 300, 20));
// //
// //     List<int> pdfBytes = await document.save();
// //     document.dispose();
// //
// //     Directory? directory = await getExternalStorageDirectory();
// //     String fileName = '${documentType.toLowerCase()}_${customerName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
// //     String path = '${directory!.path}/$fileName';
// //     File file = File(path);
// //     await file.writeAsBytes(pdfBytes);
// //
// //     return path;
// //   }
// //
// //   Future<void> _generateAndViewPDF(int totalAmount) async {
// //     try {
// //       showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (context) => const Center(child: CircularProgressIndicator()),
// //       );
// //
// //       String pdfPath = await _generatePDF(totalAmount);
// //       _pdfPath = pdfPath;
// //
// //       Navigator.pop(context);
// //
// //       // Navigate to PDF Viewer
// //       Navigator.push(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => PDFViewerPage(
// //             pdfPath: pdfPath,
// //             title: '$documentType - $customerName',
// //           ),
// //         ),
// //       );
// //
// //       _showSuccess('PDF generated successfully!');
// //     } catch (e) {
// //       Navigator.pop(context);
// //       _showError('Error generating PDF: $e');
// //     }
// //   }
// //
// //   Future<void> _sharePDF(int totalAmount) async {
// //     try {
// //       showDialog(
// //         context: context,
// //         barrierDismissible: false,
// //         builder: (context) => const Center(child: CircularProgressIndicator()),
// //       );
// //
// //       String pdfPath;
// //       if (_pdfPath != null && File(_pdfPath!).existsSync()) {
// //         pdfPath = _pdfPath!;
// //       } else {
// //         pdfPath = await _generatePDF(totalAmount);
// //         _pdfPath = pdfPath;
// //       }
// //
// //       Navigator.pop(context);
// //
// //       // Show share dialog
// //       await _showShareDialog(pdfPath);
// //
// //     } catch (e) {
// //       Navigator.pop(context);
// //       _showError('Error sharing PDF: $e');
// //     }
// //   }
// //
// //   Future<void> _showShareDialog(String pdfPath) async {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return AlertDialog(
// //           title: Text('Share $documentType'),
// //           content: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text('Choose sharing option:'),
// //               SizedBox(height: 20),
// //               ListTile(
// //                 leading: Icon(Icons.share, color: Colors.blue),
// //                 title: Text('Share PDF'),
// //                 subtitle: Text('Share via apps (WhatsApp, Email, etc.)'),
// //                 onTap: () async {
// //                   Navigator.pop(context);
// //                   try {
// //                     await Share.shareXFiles(
// //                         [XFile(pdfPath)],
// //                         text: '$documentType for $customerName\nTotal Amount: ₹${items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int))}'
// //                     );
// //                     _showSuccess('PDF shared successfully!');
// //                   } catch (e) {
// //                     _showError('Error sharing: $e');
// //                   }
// //                 },
// //               ),
// //               ListTile(
// //                 leading: Icon(Icons.message, color: Colors.green),
// //                 title: Text('Share via WhatsApp'),
// //                 subtitle: Text('Direct WhatsApp sharing'),
// //                 onTap: () async {
// //                   Navigator.pop(context);
// //                   try {
// //                     await Share.shareXFiles(
// //                         [XFile(pdfPath)],
// //                         text: '📄 $documentType\n\n👤 Customer: $customerName\n📱 Mobile: $customerMobile\n💰 Total: ₹${items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int))}\n\n✅ Valid for 7 days',
// //                         subject: '$documentType - $customerName'
// //                     );
// //                     _showSuccess('Shared via WhatsApp!');
// //                   } catch (e) {
// //                     _showError('Error sharing via WhatsApp: $e');
// //                   }
// //                 },
// //               ),
// //             ],
// //           ),
// //           actions: [
// //             TextButton(
// //               onPressed: () => Navigator.pop(context),
// //               child: Text('Cancel'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// // }
// //
// // // Separate PDF Viewer Page
// // class PDFViewerPage extends StatefulWidget {
// //   final String pdfPath;
// //   final String title;
// //
// //   const PDFViewerPage({Key? key, required this.pdfPath, required this.title}) : super(key: key);
// //
// //   @override
// //   State<PDFViewerPage> createState() => _PDFViewerPageState();
// // }
// //
// // class _PDFViewerPageState extends State<PDFViewerPage> {
// //   final PdfViewerController _pdfViewerController = PdfViewerController();
// //   int _currentPageNumber = 1;
// //   int _totalPages = 0;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         backgroundColor: Colors.white,
// //         appBar: AppBar(
// //           title: Text(widget.title, style: TextStyle(color: Colors.white)),
// //           backgroundColor: Colors.teal,
// //           actions: [
// //             IconButton(
// //               icon: Icon(Icons.zoom_in, color: Colors.white),
// //               onPressed: () => _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25,
// //               tooltip: 'Zoom In',
// //             ),
// //             IconButton(
// //               icon: Icon(Icons.zoom_out, color: Colors.white),
// //               onPressed: () => _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25,
// //               tooltip: 'Zoom Out',
// //             ),
// //             IconButton(
// //               icon: Icon(Icons.share, color: Colors.white),
// //               onPressed: () => _sharePDF(),
// //               tooltip: 'Share PDF',
// //             ),
// //           ],
// //         ),
// //         body: Column(
// //           children: [
// //             // Page Navigation Bar
// //             Container(
// //               padding: EdgeInsets.all(8.0),
// //               color: Colors.teal.shade50,
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   IconButton(
// //                     icon: Icon(Icons.navigate_before),
// //                     onPressed: _currentPageNumber > 1 ? () => _pdfViewerController.previousPage() : null,
// //                   ),
// //                   Text(
// //                     'Page $_currentPageNumber of $_totalPages',
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                   ),
// //                   IconButton(
// //                     icon: Icon(Icons.navigate_next),
// //                     onPressed: _currentPageNumber < _totalPages ? () => _pdfViewerController.nextPage() : null,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             // PDF Viewer
// //             Expanded(
// //               child: SfPdfViewer.file(
// //                 File(widget.pdfPath),
// //                 controller: _pdfViewerController,
// //                 onDocumentLoaded: (PdfDocumentLoadedDetails details) {
// //                   setState(() {
// //                     _totalPages = details.document.pages.count;
// //                   });
// //                 },
// //                 onPageChanged: (PdfPageChangedDetails details) {
// //                   setState(() {
// //                     _currentPageNumber = details.newPageNumber;
// //                   });
// //                 },
// //                 enableDoubleTapZooming: true,
// //                 enableTextSelection: true,
// //                 canShowScrollHead: true,
// //                 canShowScrollStatus: true,
// //                 canShowPaginationDialog: true,
// //               ),
// //             ),
// //           ],
// //         ),
// //         floatingActionButton: Column(
// //           mainAxisAlignment: MainAxisAlignment.end,
// //           children: [
// //             FloatingActionButton(
// //               onPressed: () => _sharePDF(),
// //               backgroundColor: Colors.green,
// //               heroTag: "share",
// //               child: Icon(Icons.share, color: Colors.white),
// //               tooltip: 'Share PDF',
// //             ),
// //             SizedBox(height: 10),
// //             FloatingActionButton(
// //               onPressed: () => _pdfViewerController.jumpToPage(1),
// //               backgroundColor: Colors.teal,
// //               heroTag: "first_page",
// //               child: Icon(Icons.first_page, color: Colors.white),
// //               tooltip: 'Go to First Page',
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _sharePDF() async {
// //     try {
// //       await Share.shareXFiles([XFile(widget.pdfPath)], text: widget.title);
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('PDF shared successfully!'), backgroundColor: Colors.green),
// //       );
// //     } catch (e) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Error sharing PDF: $e'), backgroundColor: Colors.red),
// //       );
// //     }
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdf/pdf.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:flutter/services.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';
//
// class QuotationPage extends StatefulWidget {
//   final String? customerName;
//   final String? customerMobile;
//   final String? customerEmail;
//   final List<Map<String, dynamic>>? items;
//   final String? documentType; // 'Bill' or 'Quotation'
//
//   const QuotationPage({
//     Key? key,
//     this.customerName,
//     this.customerMobile,
//     this.customerEmail,
//     this.items,
//     this.documentType,
//   }) : super(key: key);
//
//   @override
//   State<QuotationPage> createState() => _QuotationPageState();
// }
//
// class _QuotationPageState extends State<QuotationPage> {
//   late String customerName;
//   late String customerMobile;
//   late String customerEmail;
//   late List<Map<String, dynamic>> items;
//   late String documentType;
//
//   final String ownerName = "Ramesh Kumar";
//   final String officeNumber = "9943719312";
//
//   // Default items if none provided
//   final List<Map<String, dynamic>> defaultItems = [
//     {"name": "WiFi Router", "qty": 1, "rate": 1200},
//     {"name": "Installation Service", "qty": 1, "rate": 500},
//     {"name": "Network Cable", "qty": 2, "rate": 150},
//     {"name": "Configuration", "qty": 1, "rate": 300},
//     {"name": "Support Service", "qty": 1, "rate": 400},
//   ];
//
//   String? _pdfPath;
//   final PdfViewerController _pdfViewerController = PdfViewerController();
//
//   @override
//   void initState() {
//     super.initState();
//     customerName = widget.customerName ?? "Rokesh";
//     customerMobile = widget.customerMobile ?? "9876543210";
//     customerEmail = widget.customerEmail ?? "";
//     items = widget.items ?? defaultItems;
//     documentType = widget.documentType ?? "Quotation";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final int totalAmount = items.fold(
//       0,
//           (sum, item) => sum + (item["qty"] * item["rate"] as int),
//     );
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Text("$documentType - $customerName",
//               style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.teal,
//           actions: [
//             IconButton(
//               icon: Icon(Icons.save_alt, color: Colors.white),
//               onPressed: () => _generateAndViewPDF(totalAmount),
//               tooltip: 'Generate & View PDF',
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _buildHeader(),
//               SizedBox(height: 20),
//               _buildCustomerInfo(),
//               SizedBox(height: 20),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.teal.shade100, width: 1),
//                     borderRadius: BorderRadius.all(Radius.circular(5)),
//                   ),
//                   child: Column(
//                     children: [
//                       _buildTableHeader(),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: items.length,
//                           itemBuilder: (context, index) => _buildRow(items[index]),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Align(
//                   alignment: Alignment.topRight,
//                   child: Text(
//                     "Total: ₹$totalAmount",
//                     style: TextStyle(fontWeight: FontWeight.bold,
//                         fontSize: 18, color: Colors.teal),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _generateAndViewPDF(totalAmount),
//                     icon: Icon(Icons.picture_as_pdf, color: Colors.white),
//                     label: Text('View PDF', style: TextStyle(color: Colors.white)),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _sharePDF(totalAmount),
//                     icon: Icon(Icons.share, color: Colors.white),
//                     label: Text('Share PDF', style: TextStyle(color: Colors.white)),
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Center(
//                 child: Text(
//                   "Valid for 7 days",
//                   style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Image(
//           image: AssetImage("asset/image/svg/log.png"),
//           height: 80,
//           width: 120,
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text("Mobile No: $officeNumber", style: TextStyle(fontSize: 16)),
//             Text("Email: info@zinfiton.com", style: TextStyle(fontSize: 16)),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCustomerInfo() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.teal.shade50,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.teal.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "$documentType Details",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.teal,
//             ),
//           ),
//           SizedBox(height: 10),
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Customer: $customerName",
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//                     SizedBox(height: 5),
//                     Text("Mobile: $customerMobile", style: TextStyle(fontSize: 16)),
//                     if (customerEmail.isNotEmpty) ...[
//                       SizedBox(height: 5),
//                       Text("Email: $customerEmail", style: TextStyle(fontSize: 16)),
//                     ],
//                   ],
//                 ),
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Text("Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
//                   Text("Time: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}"),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTableHeader() {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
//       color: Colors.teal.shade100,
//       child: Row(
//         children: [
//           Expanded(flex: 4, child: Text("Item",
//               style: TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(flex: 2, child: Text("Qty",
//               style: TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(flex: 2, child: Text("Rate",
//               style: TextStyle(fontWeight: FontWeight.bold))),
//           Expanded(flex: 2, child: Text("Total",
//               style: TextStyle(fontWeight: FontWeight.bold))),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRow(Map<String, dynamic> item) {
//     final int total = item["qty"] * item["rate"];
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       decoration: BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: Row(
//         children: [
//           Expanded(flex: 4, child: Text(item["name"],
//               style: TextStyle(fontSize: 14))),
//           Expanded(flex: 2, child: Text("${item["qty"]}",
//               style: TextStyle(fontSize: 14))),
//           Expanded(flex: 2, child: Text("₹${item["rate"]}",
//               style: TextStyle(fontSize: 14))),
//           Expanded(flex: 2, child: Text("₹$total",
//               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
//         ],
//       ),
//     );
//   }
//
//   void _showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.red),
//     );
//   }
//
//   void _showSuccess(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), backgroundColor: Colors.green),
//     );
//   }
//
//   Future<String> _generatePDF(int totalAmount) async {
//     PdfDocument document = PdfDocument();
//     PdfPage page = document.pages.add();
//     PdfGraphics graphics = page.graphics;
//
//     // Define fonts with better sizing
//     final PdfFont standardFont = PdfStandardFont(PdfFontFamily.helvetica, 11);
//     final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 18,
//         style: PdfFontStyle.bold);
//     final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 13,
//         style: PdfFontStyle.bold);
//     final PdfFont smallFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
//
//     // Page dimensions
//     final double pageWidth = page.getClientSize().width;
//     final double margin = 40;
//     final double contentWidth = pageWidth - (2 * margin);
//
//     double currentY = 30;
//
//     // Header Section with better alignment
//     try {
//       final ByteData imageBytes = await rootBundle.load('assets/image/svg/log.png');
//       final Uint8List imageData = imageBytes.buffer.asUint8List();
//       final PdfBitmap image = PdfBitmap(imageData);
//
//       // Logo on left
//       graphics.drawImage(
//         image,
//         Rect.fromLTWH(margin, currentY, 100, 50),
//       );
//     } catch (e) {
//       // Company name as fallback
//       graphics.drawString('RELIE TECH', titleFont,
//           brush: PdfBrushes.teal,
//           bounds: Rect.fromLTWH(margin, currentY, 150, 30));
//     }
//
//     // Company info on right - better aligned
//     final String companyInfo = 'Mobile: $officeNumber\nEmail: info@zinfiton.com';
//     final Size companyInfoSize = companyInfo.length > 0 ?
//     Size(150, 40) : Size(0, 0);
//     graphics.drawString(companyInfo, standardFont,
//         brush: PdfBrushes.black,
//         bounds: Rect.fromLTWH(pageWidth - margin - 150, currentY, 150, 40),
//         format: PdfStringFormat(alignment: PdfTextAlignment.right));
//
//     currentY += 70;
//
//     // Document title - centered
//     graphics.drawString(documentType.toUpperCase(), titleFont,
//         brush: PdfBrushes.teal,
//         bounds: Rect.fromLTWH(margin, currentY, contentWidth, 25),
//         format: PdfStringFormat(alignment: PdfTextAlignment.center));
//
//     currentY += 40;
//
//     // Draw a separator line
//     graphics.drawLine(PdfPens.gray,
//         Offset(margin, currentY),
//         Offset(pageWidth - margin, currentY));
//     currentY += 20;
//
//     // Customer details section - better layout
//     final String dateTime = 'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}\n' +
//         'Time: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';
//
//     // Customer info on left
//     String customerDetails = 'Customer: $customerName\nMobile: $customerMobile';
//     if (customerEmail.isNotEmpty) {
//       customerDetails += '\nEmail: $customerEmail';
//     }
//
//     graphics.drawString(customerDetails, standardFont,
//         brush: PdfBrushes.black,
//         bounds: Rect.fromLTWH(margin, currentY, contentWidth * 0.6, 60));
//
//     // Date/time on right
//     graphics.drawString(dateTime, standardFont,
//         brush: PdfBrushes.black,
//         bounds: Rect.fromLTWH(pageWidth - margin - 120, currentY, 120, 60),
//         format: PdfStringFormat(alignment: PdfTextAlignment.right));
//
//     currentY += 80;
//
//     // Another separator line
//     graphics.drawLine(PdfPens.gray,
//         Offset(margin, currentY),
//         Offset(pageWidth - margin, currentY));
//     currentY += 15;
//
//     // Create table with proper alignment
//     PdfGrid grid = PdfGrid();
//     grid.style = PdfGridStyle(
//       font: standardFont,
//       cellPadding: PdfPaddings(left: 8, right: 8, top: 6, bottom: 6),
//     );
//
//     // Set up columns with proper widths
//     grid.columns.add(count: 4);
//     grid.columns[0].width = contentWidth * 0.5; // Item name - 50%
//     grid.columns[1].width = contentWidth * 0.15; // Qty - 15%
//     grid.columns[2].width = contentWidth * 0.175; // Rate - 17.5%
//     grid.columns[3].width = contentWidth * 0.175; // Total - 17.5%
//
//     // Header row with better styling
//     PdfGridRow headerRow = grid.headers.add(1)[0];
//     headerRow.cells[0].value = 'Item Description';
//     headerRow.cells[1].value = 'Qty';
//     headerRow.cells[2].value = 'Rate';
//     headerRow.cells[3].value = 'Amount';
//
//     // Style header row
//     for (int i = 0; i < 4; i++) {
//       headerRow.cells[i].style = PdfGridCellStyle(
//         backgroundBrush: PdfBrushes.lightGray,
//         textBrush: PdfBrushes.black,
//         font: headerFont,
//         stringFormat: PdfStringFormat(alignment: i == 0 ?
//         PdfTextAlignment.left : PdfTextAlignment.center),
//       );
//     }
//
//     // Add data rows with proper alignment
//     for (var item in items) {
//       PdfGridRow row = grid.rows.add();
//       int itemTotal = item["qty"] * item["rate"];
//
//       row.cells[0].value = item["name"];
//       row.cells[1].value = item["qty"].toString();
//       row.cells[2].value = 'Rs.${item["rate"]}';
//       row.cells[3].value = 'Rs.$itemTotal';
//
//       // Style data cells
//       row.cells[0].style = PdfGridCellStyle(
//           stringFormat: PdfStringFormat(alignment: PdfTextAlignment.left));
//       row.cells[1].style = PdfGridCellStyle(
//           stringFormat: PdfStringFormat(alignment: PdfTextAlignment.center));
//       row.cells[2].style = PdfGridCellStyle(
//           stringFormat: PdfStringFormat(alignment: PdfTextAlignment.center));
//       row.cells[3].style = PdfGridCellStyle(
//           stringFormat: PdfStringFormat(alignment: PdfTextAlignment.center));
//     }
//
//     // Draw the grid
//     PdfLayoutResult result = grid.draw(
//         page: page,
//         bounds: Rect.fromLTWH(margin, currentY, contentWidth, 0))!;
//
//     currentY = result.bounds.bottom + 20;
//
//     // Draw total line
//     graphics.drawLine(PdfPens.gray,
//         Offset(pageWidth - margin - 150, currentY),
//         Offset(pageWidth - margin, currentY));
//     currentY += 10;
//
//     // Total amount - right aligned and prominent
//     graphics.drawString('TOTAL: Rs.$totalAmount', headerFont,
//         brush: PdfBrushes.teal,
//         bounds: Rect.fromLTWH(pageWidth - margin - 150, currentY, 150, 25),
//         format: PdfStringFormat(alignment: PdfTextAlignment.right));
//
//     currentY += 40;
//
//     // Footer section
//     graphics.drawLine(PdfPens.lightGray,
//         Offset(margin, currentY),
//         Offset(pageWidth - margin, currentY));
//     currentY += 15;
//
//     // Terms and validity
//     graphics.drawString('Terms: Valid for 7 days from date of quotation',
//         smallFont,
//         brush: PdfBrushes.gray,
//         bounds: Rect.fromLTWH(margin, currentY, contentWidth, 20));
//
//     currentY += 25;
//     graphics.drawString('Thank you for your business!', standardFont,
//         brush: PdfBrushes.teal,
//         bounds: Rect.fromLTWH(margin, currentY, contentWidth, 20),
//         format: PdfStringFormat(alignment: PdfTextAlignment.center));
//
//     // Save PDF
//     List<int> pdfBytes = await document.save();
//     document.dispose();
//
//     // Save to phone storage
//     Directory? directory;
//     if (Platform.isAndroid) {
//       directory = await getExternalStorageDirectory();
//     } else {
//       directory = await getApplicationDocumentsDirectory();
//     }
//
//     String fileName = '${documentType.toLowerCase()}_${customerName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
//     String path = '${directory!.path}/$fileName';
//     File file = File(path);
//     await file.writeAsBytes(pdfBytes);
//
//     return path;
//   }
//
//   Future<void> _generateAndViewPDF(int totalAmount) async {
//     try {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(child: CircularProgressIndicator()),
//       );
//
//       String pdfPath = await _generatePDF(totalAmount);
//       _pdfPath = pdfPath;
//
//       Navigator.pop(context);
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PDFViewerPage(
//             pdfPath: pdfPath,
//             title: '$documentType - $customerName',
//           ),
//         ),
//       );
//
//       _showSuccess('PDF saved to phone and ready to view!');
//     } catch (e) {
//       Navigator.pop(context);
//       _showError('Error generating PDF: $e');
//     }
//   }
//
//   Future<void> _sharePDF(int totalAmount) async {
//     try {
//       showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) => const Center(child: CircularProgressIndicator()),
//       );
//
//       String pdfPath;
//       if (_pdfPath != null && File(_pdfPath!).existsSync()) {
//         pdfPath = _pdfPath!;
//       } else {
//         pdfPath = await _generatePDF(totalAmount);
//         _pdfPath = pdfPath;
//       }
//
//       Navigator.pop(context);
//       await _showShareDialog(pdfPath);
//
//     } catch (e) {
//       Navigator.pop(context);
//       _showError('Error sharing PDF: $e');
//     }
//   }
//
//   Future<void> _showShareDialog(String pdfPath) async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Share $documentType'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text('Choose sharing option:'),
//               SizedBox(height: 20),
//               ListTile(
//                 leading: Icon(Icons.share, color: Colors.blue),
//                 title: Text('Share PDF'),
//                 subtitle: Text('Share via apps (WhatsApp, Email, etc.)'),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   try {
//                     await Share.shareXFiles(
//                         [XFile(pdfPath)],
//                         text: '$documentType for $customerName\nTotal Amount: ₹${items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int))}'
//                     );
//                     _showSuccess('PDF shared successfully!');
//                   } catch (e) {
//                     _showError('Error sharing: $e');
//                   }
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.message, color: Colors.green),
//                 title: Text('Share via WhatsApp'),
//                 subtitle: Text('Direct WhatsApp sharing'),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   try {
//                     await Share.shareXFiles(
//                         [XFile(pdfPath)],
//                         text: '📄 $documentType\n\n👤 Customer: $customerName\n📱 Mobile: $customerMobile\n💰 Total: ₹${items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int))}\n\n✅ Valid for 7 days',
//                         subject: '$documentType - $customerName'
//                     );
//                     _showSuccess('Shared via WhatsApp!');
//                   } catch (e) {
//                     _showError('Error sharing via WhatsApp: $e');
//                   }
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
// // PDF Viewer Page with enhanced features
// class PDFViewerPage extends StatefulWidget {
//   final String pdfPath;
//   final String title;
//
//   const PDFViewerPage({Key? key, required this.pdfPath, required this.title})
//       : super(key: key);
//
//   @override
//   State<PDFViewerPage> createState() => _PDFViewerPageState();
// }
//
// class _PDFViewerPageState extends State<PDFViewerPage> {
//   final PdfViewerController _pdfViewerController = PdfViewerController();
//   int _currentPageNumber = 1;
//   int _totalPages = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           title: Text(widget.title, style: TextStyle(color: Colors.white)),
//           backgroundColor: Colors.teal,
//           actions: [
//             IconButton(
//               icon: Icon(Icons.zoom_in, color: Colors.white),
//               onPressed: () => _pdfViewerController.zoomLevel =
//                   _pdfViewerController.zoomLevel + 0.25,
//               tooltip: 'Zoom In',
//             ),
//             IconButton(
//               icon: Icon(Icons.zoom_out, color: Colors.white),
//               onPressed: () => _pdfViewerController.zoomLevel =
//                   _pdfViewerController.zoomLevel - 0.25,
//               tooltip: 'Zoom Out',
//             ),
//             IconButton(
//               icon: Icon(Icons.share, color: Colors.white),
//               onPressed: () => _sharePDF(),
//               tooltip: 'Share PDF',
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             // Enhanced Page Navigation Bar
//             Container(
//               padding: EdgeInsets.all(8.0),
//               color: Colors.teal.shade50,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.navigate_before),
//                     onPressed: _currentPageNumber > 1 ?
//                         () => _pdfViewerController.previousPage() : null,
//                   ),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.teal.shade100,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       'Page $_currentPageNumber of $_totalPages',
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.navigate_next),
//                     onPressed: _currentPageNumber < _totalPages ?
//                         () => _pdfViewerController.nextPage() : null,
//                   ),
//                 ],
//               ),
//             ),
//             // Enhanced PDF Viewer
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 margin: EdgeInsets.all(8),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: SfPdfViewer.file(
//                     File(widget.pdfPath),
//                     controller: _pdfViewerController,
//                     onDocumentLoaded: (PdfDocumentLoadedDetails details) {
//                       setState(() {
//                         _totalPages = details.document.pages.count;
//                       });
//                     },
//                     onPageChanged: (PdfPageChangedDetails details) {
//                       setState(() {
//                         _currentPageNumber = details.newPageNumber;
//                       });
//                     },
//                     enableDoubleTapZooming: true,
//                     enableTextSelection: true,
//                     canShowScrollHead: true,
//                     canShowScrollStatus: true,
//                     canShowPaginationDialog: true,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         floatingActionButton: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             FloatingActionButton(
//               onPressed: () => _sharePDF(),
//               backgroundColor: Colors.green,
//               heroTag: "share",
//               child: Icon(Icons.share, color: Colors.white),
//               tooltip: 'Share PDF',
//             ),
//             SizedBox(height: 10),
//             FloatingActionButton(
//               onPressed: () => _pdfViewerController.jumpToPage(1),
//               backgroundColor: Colors.teal,
//               heroTag: "first_page",
//               child: Icon(Icons.first_page, color: Colors.white),
//               tooltip: 'Go to First Page',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _sharePDF() async {
//     try {
//       await Share.shareXFiles([XFile(widget.pdfPath)], text: widget.title);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('PDF shared successfully!'),
//             backgroundColor: Colors.green),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error sharing PDF: $e'),
//             backgroundColor: Colors.red),
//       );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class QuotationPage extends StatefulWidget {
  final String? customerName;
  final String? customerMobile;
  final String? customerEmail;
  final List<Map<String, dynamic>>? items;
  final String? documentType; // 'Bill' or 'Quotation'

  const QuotationPage({
    Key? key,
    this.customerName,
    this.customerMobile,
    this.customerEmail,
    this.items,
    this.documentType,
    String? existingDocumentId,
  }) : super(key: key);

  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  late String customerName;
  late String customerMobile;
  late String customerEmail;
  late List<Map<String, dynamic>> items;
  late String documentType;

  final String ownerName = "Ramesh Kumar";
  final String officeNumber = "8807136927";

  // Firebase instances
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Default items if none provided
  final List<Map<String, dynamic>> defaultItems = [
    {"name": "WiFi Router", "qty": 1, "rate": 1200},
    {"name": "Installation Service", "qty": 1, "rate": 500},
    {"name": "WiFi Router", "qty": 1, "rate": 1200},
    {"name": "Installation Service", "qty": 1, "rate": 500},
    {"name": "WiFi Router", "qty": 1, "rate": 1200},
    {"name": "Installation Service", "qty": 1, "rate": 500},
    {"name": "WiFi Router", "qty": 1, "rate": 1200},
    {"name": "Installation Service", "qty": 1, "rate": 500},
    {"name": "WiFi Router", "qty": 1, "rate": 1200},
  ];

  String? _pdfPath;
  String? _documentId; // Store the Firebase document ID
  final PdfViewerController _pdfViewerController = PdfViewerController();

  // Firebase: Store document data to Firestore
  Future<String> _storeToFirebase(int totalAmount, String pdfPath) async {
    try {
      // Create document data
      Map<String, dynamic> documentData = {
        'customerName': customerName,
        'customerMobile': customerMobile,
        'customerEmail': customerEmail,
        'documentType': documentType,
        'items': items,
        'totalAmount': totalAmount,
        'createdAt': FieldValue.serverTimestamp(),
        'ownerName': ownerName,
        'officeNumber': officeNumber,
        'validityDays': documentType == 'Bill' ? 0 : 7, // Bills don't have validity, Quotations have 7 days
        'status': documentType == 'Bill' ? 'completed' : 'pending',
        'pdfFileName': pdfPath.split('/').last,
      };

      // Store document in appropriate collection
      String collectionName = documentType.toLowerCase() == 'bill' ? 'bills' : 'quotations';
      DocumentReference docRef = await _firestore.collection(collectionName).add(documentData);

      // Upload PDF to Firebase Storage
      await _uploadPDFToStorage(pdfPath, docRef.id, collectionName);

      // Update document with PDF URL
      String pdfUrl = await _storage.ref('$collectionName/${docRef.id}.pdf').getDownloadURL();
      await docRef.update({'pdfUrl': pdfUrl});

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to store to Firebase: $e');
    }
  }

  // Firebase: Upload PDF to Firebase Storage
  Future<void> _uploadPDFToStorage(String localPath, String documentId, String collectionName) async {
    try {
      File pdfFile = File(localPath);
      Reference ref = _storage.ref('$collectionName/$documentId.pdf');
      await ref.putFile(pdfFile);
    } catch (e) {
      throw Exception('Failed to upload PDF to Firebase Storage: $e');
    }
  }

  Future<void> _generateAndSavePDF(int totalAmount) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.teal),
              SizedBox(height: 16),
              Text('Generating PDF and saving to Firebase...',
                  style: TextStyle(color: Colors.teal)),
            ],
          ),
        ),
      );

      // Generate PDF
      String pdfPath = await _generatePDF(totalAmount);

      // Store to Firebase
      String documentId = await _storeToFirebase(totalAmount, pdfPath);
      _documentId = documentId;

      // Dismiss loading dialog
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("PDF Generated & Saved Successfully!",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Local: ${pdfPath.split('/').last}"),
              Text("Firebase ID: $documentId"),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'OPEN',
            textColor: Colors.white,
            onPressed: () async {
              try {
                await OpenFile.open(pdfPath);
              } catch (e) {
                _showError('Could not open PDF: $e');
              }
            },
          ),
        ),
      );

    } catch (e) {
      // Dismiss loading dialog if still showing
      Navigator.pop(context);
      _showError('Error saving to Firebase: $e');
    }
  }

  Future<String> _generatePDF(int totalAmount) async {
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    // Use standard font with better sizing
    final PdfFont regularFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 18, style: PdfFontStyle.bold);
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 12, style: PdfFontStyle.bold);
    final PdfFont smallFont = PdfStandardFont(PdfFontFamily.helvetica, 9);

    double currentY = 40;
    double pageWidth = page.size.width;
    double pageHeight = page.size.height;
    double margin = 40;

    // Document type title (centered)
    String docTitle = documentType.toUpperCase();
    Size titleSize = titleFont.measureString(docTitle);
    graphics.drawString(docTitle, titleFont,
        brush: PdfBrushes.teal,
        bounds: Rect.fromLTWH((pageWidth - titleSize.width) / 2, currentY, titleSize.width, 25));

    currentY += 40;

    // Header Section with better alignment
    try {
      final ByteData imageBytes = await rootBundle.load('asset/image/svg/log.png');
      final Uint8List imageData = imageBytes.buffer.asUint8List();
      final PdfBitmap image = PdfBitmap(imageData);

      graphics.drawImage(
        image,
        Rect.fromLTWH(margin, currentY, 100, 50),
      );
    } catch (e) {
      // If image fails to load, draw company name instead
      graphics.drawString('RELIE TECH', titleFont,
          brush: PdfBrushes.teal,
          bounds: Rect.fromLTWH(margin, currentY, 200, 30));
    }

    // Company contact info (right aligned)
    String contactInfo = 'Mobile No: $officeNumber\nEmail: relietech@gmail.com';
    graphics.drawString(contactInfo, regularFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(pageWidth - margin - 230, currentY, 200, 40),
        format: PdfStringFormat(alignment: PdfTextAlignment.left));

    currentY += 70;

    // Customer details section
    String customerDetails = 'To :\n';
    customerDetails += 'Customer Name: $customerName\n';
    customerDetails += 'Mobile Number: $customerMobile';
    if (customerEmail.isNotEmpty) {
      customerDetails += '\nEmail: $customerEmail';
    }

    // Date section (right aligned)
    String dateInfo = 'Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}\nTime: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';

    graphics.drawString(customerDetails, regularFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(margin, currentY, 250, 80));

    graphics.drawString(dateInfo, regularFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(pageWidth - margin - 180, currentY, 120, 100),
        format: PdfStringFormat(alignment: PdfTextAlignment.left));

    currentY += 100;

    // Items table
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
      font: regularFont,
      cellPadding: PdfPaddings(left: 8, right: 8, top: 6, bottom: 6),
    );

    grid.columns.add(count: 4);
    double tableWidth = pageWidth - (2 * margin);
    grid.columns[0].width = tableWidth * 0.4;
    grid.columns[1].width = tableWidth * 0.15;
    grid.columns[2].width = tableWidth * 0.175;
    grid.columns[3].width = tableWidth * 0.175;

    // Header row
    PdfGridRow headerRow = grid.headers.add(1)[0];
    headerRow.cells[0].value = 'ITEM DESCRIPTION';
    headerRow.cells[1].value = 'QTY';
    headerRow.cells[2].value = 'RATE';
    headerRow.cells[3].value = 'TOTAL';

    // Style header cells
    for (int i = 0; i < 4; i++) {
      headerRow.cells[i].style = PdfGridCellStyle(
        backgroundBrush: PdfBrushes.teal,
        textBrush: PdfBrushes.white,
        font: headerFont,
        format: PdfStringFormat(
            alignment: i == 0 ? PdfTextAlignment.left : PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle
        ),
      );
    }

    // Add items
    for (var item in items) {
      PdfGridRow row = grid.rows.add();
      int itemTotal = item["qty"] * item["rate"];

      row.cells[0].value = item["name"];
      row.cells[1].value = item["qty"].toString();
      row.cells[2].value = 'Rs.${item["rate"]}';
      row.cells[3].value = 'Rs.$itemTotal';

      // Style data cells
      row.cells[0].style = PdfGridCellStyle(
          format: PdfStringFormat(alignment: PdfTextAlignment.left, lineAlignment: PdfVerticalAlignment.middle)
      );
      for (int i = 1; i < 4; i++) {
        row.cells[i].style = PdfGridCellStyle(
            format: PdfStringFormat(alignment: PdfTextAlignment.center, lineAlignment: PdfVerticalAlignment.middle)
        );
      }
    }

    // Draw grid
    PdfLayoutResult result = grid.draw(page: page, bounds: Rect.fromLTWH(margin, currentY, tableWidth, 0))!;
    currentY = result.bounds.bottom + 20;

    // Draw separator line
    graphics.drawLine(PdfPen(PdfColor(0, 128, 128), ),
        Offset(pageWidth - margin - 200, currentY), Offset(pageWidth - margin, currentY));

    currentY += 15;

    // Total amount
    String totalText = 'TOTAL: ₹$totalAmount';
    graphics.drawString(totalText, headerFont,
        brush: PdfBrushes.teal,
        bounds: Rect.fromLTWH(pageWidth - margin - 200, currentY, 200, 25),
        format: PdfStringFormat(alignment: PdfTextAlignment.center));

    currentY += 50;

    // Terms and conditions - Different based on document type
    String terms = '';
    if (documentType.toLowerCase() == 'bill') {
      terms = 'TERMS & CONDITIONS:\n• Thank you for your business\n• All prices are inclusive of applicable taxes\n• Payment completed successfully';
    } else {
      terms = 'TERMS & CONDITIONS:\n• Valid for 7 days from date of issue\n• All prices are inclusive of applicable taxes\n• Payment terms: As per agreement';
    }

    graphics.drawString(terms, smallFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(margin, currentY, pageWidth - (2 * margin), 60));

    currentY += 80;

    // Footer with signature
    if (currentY < pageHeight - 100) {
      graphics.drawString('Authorized Signature:', regularFont,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(pageWidth - margin - 150, currentY, 150, 20));

      graphics.drawLine(PdfPen(PdfColor(0, 0, 0), ),
          Offset(pageWidth - margin - 150, currentY + 40),
          Offset(pageWidth - margin - 20, currentY + 40));

      graphics.drawString('$ownerName\nRELIE TECH', smallFont,
          brush: PdfBrushes.black,
          bounds: Rect.fromLTWH(pageWidth - margin - 150, currentY + 45, 150, 30),
          format: PdfStringFormat(alignment: PdfTextAlignment.center));
    }

    // Save PDF
    List<int> pdfBytes = await document.save();
    document.dispose();

    // Better file saving with proper naming
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = '${documentType}_${customerName.replaceAll(' ', '_')}_$timestamp.pdf';

    try {
      // Try to save to Downloads folder (Android)
      if (Platform.isAndroid) {
        Directory downloadsDir = Directory('/storage/emulated/0/Download');
        if (await downloadsDir.exists()) {
          String path = '${downloadsDir.path}/$fileName';
          File file = File(path);
          await file.writeAsBytes(pdfBytes);
          return path;
        }
      }

      // Fallback to external storage directory
      Directory? directory = await getExternalStorageDirectory();
      if (directory != null) {
        // Create a subfolder for your app
        Directory appDir = Directory('${directory.path}/RELIE_TECH_Bills');
        if (!await appDir.exists()) {
          await appDir.create(recursive: true);
        }

        String path = '${appDir.path}/$fileName';
        File file = File(path);
        await file.writeAsBytes(pdfBytes);
        return path;
      }

    } catch (e) {
      print('External storage error: $e');
    }

    // Final fallback to app documents directory
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/$fileName';
    File file = File(path);
    await file.writeAsBytes(pdfBytes);
    return path;
  }

  // Firebase: Get all documents from Firestore
  Future<List<Map<String, dynamic>>> _getDocumentsFromFirebase() async {
    try {
      List<Map<String, dynamic>> allDocuments = [];

      // Get Bills
      QuerySnapshot billsSnapshot = await _firestore.collection('bills').orderBy('createdAt', descending: true).get();
      for (var doc in billsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['collection'] = 'bills';
        allDocuments.add(data);
      }

      // Get Quotations
      QuerySnapshot quotationsSnapshot = await _firestore.collection('quotations').orderBy('createdAt', descending: true).get();
      for (var doc in quotationsSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['collection'] = 'quotations';
        allDocuments.add(data);
      }

      // Sort by creation date
      allDocuments.sort((a, b) {
        Timestamp aTime = a['createdAt'] ?? Timestamp.now();
        Timestamp bTime = b['createdAt'] ?? Timestamp.now();
        return bTime.compareTo(aTime);
      });

      return allDocuments;
    } catch (e) {
      throw Exception('Failed to fetch documents from Firebase: $e');
    }
  }

  // Show Firebase documents list
  void _showFirebaseDocuments() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      List<Map<String, dynamic>> documents = await _getDocumentsFromFirebase();

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Firebase Documents'),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: documents.isEmpty
                ? Center(child: Text('No documents found'))
                : ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var doc = documents[index];
                DateTime createdAt = (doc['createdAt'] as Timestamp).toDate();
                return Card(
                  child: ListTile(
                    title: Text('${doc['documentType']} - ${doc['customerName']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount: ₹${doc['totalAmount']}'),
                        Text('Date: ${createdAt.day}/${createdAt.month}/${createdAt.year}'),
                        Text('Status: ${doc['status']}'),
                      ],
                    ),
                    trailing: Icon(
                      doc['documentType'] == 'Bill' ? Icons.receipt : Icons.description,
                      color: doc['documentType'] == 'Bill' ? Colors.green : Colors.blue,
                    ),
                    onTap: () => _showDocumentDetails(doc),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );

    } catch (e) {
      Navigator.pop(context);
      _showError('Error fetching documents: $e');
    }
  }

  // Show document details
  void _showDocumentDetails(Map<String, dynamic> doc) {
    DateTime createdAt = (doc['createdAt'] as Timestamp).toDate();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${doc['documentType']} Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Firebase ID: ${doc['id']}', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Customer: ${doc['customerName']}'),
              Text('Mobile: ${doc['customerMobile']}'),
              if (doc['customerEmail'].isNotEmpty) Text('Email: ${doc['customerEmail']}'),
              SizedBox(height: 10),
              Text('Total Amount: ₹${doc['totalAmount']}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Status: ${doc['status']}'),
              Text('Created: ${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute}'),
              SizedBox(height: 10),
              Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...((doc['items'] as List).map((item) =>
                  Text('• ${item['name']} - Qty: ${item['qty']} - Rate: ₹${item['rate']}'))),
            ],
          ),
        ),
        actions: [
          if (doc['pdfUrl'] != null)
            TextButton(
              onPressed: () {
                // Open PDF URL (you can implement web view or download)
                _showSuccess('PDF URL: ${doc['pdfUrl']}');
              },
              child: Text('View PDF'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<bool> _requestStoragePermissions() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }

      if (Platform.isAndroid) {
        var manageStatus = await Permission.manageExternalStorage.status;
        if (!manageStatus.isGranted) {
          await Permission.manageExternalStorage.request();
        }
      }

      return status.isGranted;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    customerName = widget.customerName ?? "Rokesh";
    customerMobile = widget.customerMobile ?? "9876543210";
    customerEmail = widget.customerEmail ?? "";
    items = widget.items ?? defaultItems;
    documentType = widget.documentType ?? "Quotation";
    _requestStoragePermission();
  }

  Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalAmount = items.fold(
      0,
          (sum, item) => sum + (item["qty"] * item["rate"] as int),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("$documentType - $customerName", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: Icon(Icons.cloud, color: Colors.white),
              onPressed: _showFirebaseDocuments,
              tooltip: 'View Firebase Documents',
            ),
            IconButton(
              icon: Icon(Icons.save_alt, color: Colors.white),
              onPressed: () => _generateAndSavePDF(totalAmount),
              tooltip: 'Generate & Save PDF to Firebase',
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                _buildCustomerInfo(),
                SizedBox(height: 20),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal.shade100, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Column(
                      children: [
                        _buildTableHeader(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) => _buildRow(items[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Total: ₹$totalAmount",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _generateAndViewPDF(totalAmount),
                      icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: Text('View PDF', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _sharePDF(totalAmount),
                      icon: Icon(Icons.share, color: Colors.white),
                      label: Text('Share PDF', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    documentType == 'Bill' ? "Thank you for your business!" : "Valid for 7 days only",
                    style: TextStyle(
                      color: documentType == 'Bill' ? Colors.green : Colors.orange,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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
          children: [
            Text("Mobile No: $officeNumber", style: TextStyle(fontSize: 16)),
            Text("Email: info@zinfiton.com", style: TextStyle(fontSize: 16)),
          ],
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$documentType Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Customer: $customerName", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    SizedBox(height: 5),
                    Text("Mobile: $customerMobile", style: TextStyle(fontSize: 16)),
                    if (customerEmail.isNotEmpty) ...[
                      SizedBox(height: 5),
                      Text("Email: $customerEmail", style: TextStyle(fontSize: 16)),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"),
                  Text("Time: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      color: Colors.teal.shade100,
      child: Row(
        children: [
          Expanded(flex: 4, child: Text("Item", style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Rate", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> item) {
    final int total = item["qty"] * item["rate"];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(item["name"], style: TextStyle(fontSize: 14))),
          Expanded(flex: 2, child: Text("${item["qty"]}", style: TextStyle(fontSize: 14), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("₹${item["rate"]}", style: TextStyle(fontSize: 14), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text("₹$total", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500), textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _generateAndViewPDF(int totalAmount) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      String pdfPath = await _generatePDF(totalAmount);
      _pdfPath = pdfPath;

      Navigator.pop(context);

      // Navigate to PDF Viewer
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerPage(
            pdfPath: pdfPath,
            title: '$documentType - $customerName',
          ),
        ),
      );

      _showSuccess('PDF saved to phone and opened successfully!');
    } catch (e) {
      Navigator.pop(context);
      _showError('Error generating PDF: $e');
    }
  }

  Future<void> _sharePDF(int totalAmount) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      String pdfPath;
      if (_pdfPath != null && File(_pdfPath!).existsSync()) {
        pdfPath = _pdfPath!;
      } else {
        pdfPath = await _generatePDF(totalAmount);
        _pdfPath = pdfPath;
      }

      Navigator.pop(context);

      // Show share dialog
      await _showShareDialog(pdfPath);

    } catch (e) {
      Navigator.pop(context);
      _showError('Error sharing PDF: $e');
    }
  }

  Future<void> _showShareDialog(String pdfPath) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share $documentType'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Choose sharing option:'),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.share, color: Colors.blue),
                title: Text('Share PDF'),
                subtitle: Text('Share via apps (WhatsApp, Email, etc.)'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    String shareText = documentType == 'Bill'
                        ? '$documentType for $customerName\nTotal Amount: ₹${items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int))}\nThank you for your business!'
                        : '$documentType for $customerName\nTotal Amount: ₹${items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int))}\nValid for 7 days only';

                    await Share.shareXFiles([XFile(pdfPath)], text: shareText);
                    _showSuccess('PDF shared successfully!');
                  } catch (e) {
                    _showError('Error sharing: $e');
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.message, color: Colors.green),
                title: Text('Share via WhatsApp'),
                subtitle: Text('Direct WhatsApp sharing'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    String whatsappText = documentType == 'Bill'
                        ? '📄 $documentType\n\n👤 Customer: $customerName\n📱 Mobile: $customerMobile\n💰 Total: ₹${items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int))}\n\n✅ Thank you for your business!'
                        : '📄 $documentType\n\n👤 Customer: $customerName\n📱 Mobile: $customerMobile\n💰 Total: ₹${items.fold(0, (sum, item) => sum + (item["qty"] * item["rate"] as int))}\n\n⏰ Valid for 7 days only';

                    await Share.shareXFiles(
                        [XFile(pdfPath)],
                        text: whatsappText,
                        subject: '$documentType - $customerName'
                    );
                    _showSuccess('Shared via WhatsApp!');
                  } catch (e) {
                    _showError('Error sharing via WhatsApp: $e');
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

// Separate PDF Viewer Page
class PDFViewerPage extends StatefulWidget {
  final String pdfPath;
  final String title;

  const PDFViewerPage({Key? key, required this.pdfPath, required this.title}) : super(key: key);

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPageNumber = 1;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: Icon(Icons.zoom_in, color: Colors.white),
              onPressed: () => _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25,
              tooltip: 'Zoom In',
            ),
            IconButton(
              icon: Icon(Icons.zoom_out, color: Colors.white),
              onPressed: () => _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25,
              tooltip: 'Zoom Out',
            ),
            IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () => _sharePDF(),
              tooltip: 'Share PDF',
            ),
          ],
        ),
        body: Column(
          children: [
            // Page Navigation Bar
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.teal.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: _currentPageNumber > 1 ? () => _pdfViewerController.previousPage() : null,
                  ),
                  Text(
                    'Page $_currentPageNumber of $_totalPages',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: _currentPageNumber < _totalPages ? () => _pdfViewerController.nextPage() : null,
                  ),
                ],
              ),
            ),
            // PDF Viewer
            Expanded(
              child: SfPdfViewer.file(
                File(widget.pdfPath),
                controller: _pdfViewerController,
                onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                  setState(() {
                    _totalPages = details.document.pages.count;
                  });
                },
                onPageChanged: (PdfPageChangedDetails details) {
                  setState(() {
                    _currentPageNumber = details.newPageNumber;
                  });
                },
                enableDoubleTapZooming: true,
                enableTextSelection: true,
                canShowScrollHead: true,
                canShowScrollStatus: true,
                canShowPaginationDialog: true,
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () => _sharePDF(),
              backgroundColor: Colors.green,
              heroTag: "share",
              child: Icon(Icons.share, color: Colors.white),
              tooltip: 'Share PDF',
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () => _pdfViewerController.jumpToPage(1),
              backgroundColor: Colors.teal,
              heroTag: "first_page",
              child: Icon(Icons.first_page, color: Colors.white),
              tooltip: 'Go to First Page',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sharePDF() async {
    try {
      await Share.shareXFiles([XFile(widget.pdfPath)], text: widget.title);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF shared successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing PDF: $e'), backgroundColor: Colors.red),
      );
    }
  }
}