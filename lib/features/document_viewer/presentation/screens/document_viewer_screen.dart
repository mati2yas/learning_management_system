// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:lms_system/core/common_widgets/common_app_bar.dart';
// import 'package:lms_system/core/constants/colors.dart';
// import 'package:lms_system/core/utils/file_download_handler.dart';

// class SecurePDFViewer extends ConsumerStatefulWidget {
//   final String encryptedFilePath;

//   const SecurePDFViewer({super.key, required this.encryptedFilePath});

//   @override
//   ConsumerState<SecurePDFViewer> createState() => _SecurePDFViewerState();
// }

// class _SecurePDFViewerState extends ConsumerState<SecurePDFViewer> {
//   String decryptedFilePath = "";
//   bool isLoading = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CommonAppBar(titleText: "View Document"),
//       body: isLoading
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.mainBlue,
//               ),
//             )
//           : PDFView(
//               filePath: decryptedFilePath,
//               enableSwipe: true,
//               swipeHorizontal: false,
//               autoSpacing: true,
//               pageFling: true,
//             ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     //_disableScreenshots(); // we actually wont implement this here, remember to turn on the
//     // kotlin flag that we already setup earlier.
//     _loadPDF();
//   }

//   /// **Decrypt and Load PDF**
//   Future<void> _loadPDF() async {
//     final file = await SecureFileHandler.decryptPDF(
//         widget.encryptedFilePath, "temp_view");
//     setState(() {
//       decryptedFilePath = file.path;
//       isLoading = false;
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/common_app_bar.dart';
import 'package:lms_system/features/document_viewer/model/document_status.dart';
import 'package:lms_system/features/document_viewer/model/document_viewer_model.dart';
import 'package:lms_system/features/document_viewer/provider/document_viewer_provider.dart';

class SecurePDFViewer extends ConsumerStatefulWidget {
  const SecurePDFViewer({super.key});

  @override
  ConsumerState<SecurePDFViewer> createState() => _SecurePDFViewerState();
}

class _SecurePDFViewerState extends ConsumerState<SecurePDFViewer> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(documentProvider);

    return Scaffold(
      appBar: CommonAppBar(titleText: "Document Content"),
      body: _buildBody(state),
    );
  }

  @override
  void initState() {
    super.initState();
    // _disableScreenshots();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
  }

  Widget _buildBody(DocumentViewState state) {
    switch (state.status) {
      case DocumentStatus.downloading:
        return const Center(child: Text("Downloading PDF..."));
      case DocumentStatus.encrypting:
        return const Center(child: Text("Encrypting PDF..."));
      case DocumentStatus.decrypting:
        return const Center(child: Text("Decrypting PDF..."));
      case DocumentStatus.loaded:
        return PDFView(
          filePath: state.decryptedFilePath!,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
        );
      case DocumentStatus.error:
        return Center(
            child: Text("Error: ${state.errorMessage}",
                style: const TextStyle(color: Colors.red)));
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
