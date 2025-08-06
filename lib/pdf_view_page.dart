import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PdfPreviewer extends StatelessWidget {
  final Future<List<int>> bytes;
  final String fileName;
  final bool isDownload;
  final bool isSave;
  final VoidCallback? onPressed;

  const PdfPreviewer({
    Key? key,
    required this.fileName,
    required this.bytes,
    this.isDownload = true,
    this.isSave = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(fileName),
          actions: [
            if (isDownload)
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () async {
                  final pdfBytes = await bytes;
                  Printing.sharePdf(bytes: Uint8List.fromList(pdfBytes), filename: fileName);
                },
              ),
            if (isSave && onPressed != null)
              TextButton(
                onPressed: onPressed,
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              )
          ],
        ),
        body: PdfPreview(
          build: (format) async => Uint8List.fromList(await bytes),
          canChangeOrientation: false,
          canChangePageFormat: false,
          allowPrinting: true,
          allowSharing: false,
        ),
      ),
    );
  }
}
