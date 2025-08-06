import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class QuotationPage extends StatefulWidget {
  @override
  State<QuotationPage> createState() => _QuotationPageState();
}

class _QuotationPageState extends State<QuotationPage> {
  final String customerName = "Rokesh";
  final String ownerName = "Ramesh Kumar";
  final String officeNumber = "9943719312";
  final List<Map<String, dynamic>> items = [
    {"name": "WiFi Router", "qty": 1, "rate": 1200},
    {"name": "Installation Service", "qty": 1, "rate": 500},
  ];

  String? _pdfPath;
  final PdfViewerController _pdfViewerController = PdfViewerController();

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
          title: Text("Quotation", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
              icon: Icon(Icons.picture_as_pdf, color: Colors.white),
              onPressed: () => _generateAndViewPDF(totalAmount),
              tooltip: 'Generate & View PDF',
            ),
            IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () => _sharePDF(totalAmount),
              tooltip: 'Share PDF',
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
                  border: Border.all(color: Colors.teal.shade100, width: 1),
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
                  "Valid for 7 days",
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
      color: Colors.teal.shade100,
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

  Future<String> _generatePDF(int totalAmount) async {
    PdfDocument document = PdfDocument();
    PdfPage page = document.pages.add();
    PdfGraphics graphics = page.graphics;

    // Use standard font (built-in) — only ASCII characters
    final PdfFont standardFont = PdfStandardFont(PdfFontFamily.helvetica, 12);
    final PdfFont titleFont = PdfStandardFont(PdfFontFamily.helvetica, 20, style: PdfFontStyle.bold);
    final PdfFont headerFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);

    double currentY = 50;

    // Load and draw logo image
    try {
      final ByteData imageBytes = await rootBundle.load('assets/image/svg/log.png');
      final Uint8List imageData = imageBytes.buffer.asUint8List();
      final PdfBitmap image = PdfBitmap(imageData);

      graphics.drawImage(
        image,
        Rect.fromLTWH(50, currentY, 120, 60),
      );
    } catch (e) {
      // If image fails to load, draw company name instead
      graphics.drawString('RELIE tech', titleFont,
          brush: PdfBrushes.teal,
          bounds: Rect.fromLTWH(50, currentY, 200, 30));
    }

    graphics.drawString('Mobile No: $officeNumber\nEmail: info@zinfiton.com', standardFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(350, currentY, 200, 40));

    currentY += 80;
    graphics.drawString('QUOTATION', headerFont,
        brush: PdfBrushes.teal,
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
        bounds: Rect.fromLTWH(350, currentY, 300, 80));

    currentY += 60;
    graphics.drawString('Valid for 7 days', standardFont,
        brush: PdfBrushes.gray,
        bounds: Rect.fromLTWH(50, currentY, 300, 20));

    List<int> pdfBytes = await document.save();
    document.dispose();

    Directory? directory = await getExternalStorageDirectory();
    String path = '${directory!.path}/quotation_${DateTime.now().millisecondsSinceEpoch}.pdf';
    File file = File(path);
    await file.writeAsBytes(pdfBytes);

    return path;
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
            title: 'Quotation - $customerName',
          ),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF generated successfully!'), backgroundColor: Colors.green),
      );
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
      await Share.shareXFiles([XFile(pdfPath)], text: 'Quotation for $customerName');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF shared successfully!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      Navigator.pop(context);
      _showError('Error sharing PDF: $e');
    }
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
      child: Scaffold( backgroundColor: Colors.white,
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _pdfViewerController.jumpToPage(1),
          backgroundColor: Colors.teal,
          child: Icon(Icons.first_page, color: Colors.white),
          tooltip: 'Go to First Page',
        ),
      ),
    );
  }

  Future<void> _sharePDF() async {
    try {
      await Share.shareXFiles([XFile(widget.pdfPath)], text: widget.title);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing PDF: $e'), backgroundColor: Colors.red),
      );
    }
  }
}