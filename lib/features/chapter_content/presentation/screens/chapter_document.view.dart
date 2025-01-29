import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lms_system/core/utils/file_download_handler.dart';

class SecurePDFViewer extends StatefulWidget {
  final String encryptedFilePath;

  const SecurePDFViewer({super.key, required this.encryptedFilePath});

  @override
  _SecurePDFViewerState createState() => _SecurePDFViewerState();
}

class _SecurePDFViewerState extends State<SecurePDFViewer> {
  String decryptedFilePath = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //_disableScreenshots(); // we actually wont implement this here, remember to turn on the 
    // kotlin flag that we already setup earlier.
    _loadPDF();
  }

  

  /// **Decrypt and Load PDF**
  Future<void> _loadPDF() async {
    final file = await SecureFileHandler.decryptPDF(widget.encryptedFilePath, "temp_view");
    setState(() {
      decryptedFilePath = file.path;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Secure PDF Viewer")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
              filePath: decryptedFilePath,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}

