import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/file_download_handler.dart';
import 'package:lms_system/core/utils/shared_pref/shared_pref.dart';
import 'package:lms_system/features/document_viewer/model/document_viewer_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/document_status.dart';

final documentProvider =
    StateNotifierProvider<DocumentNotifier, DocumentViewState>(
  (ref) => DocumentNotifier(),
);

class DocumentNotifier extends StateNotifier<DocumentViewState> {
  DocumentNotifier()
      : super(const DocumentViewState(status: DocumentStatus.idle));

  // Future<void> processPDF(String pdfUrl, String identifier) async {
  //   try {
  //     state = state.copyWith(status: DocumentStatus.downloading);

  //     if (await SharedPrefService.checkIfDocPathExists(
  //         "secure_doc_$identifier")) {

  //         }
  //     final encryptedPath = await SecureFileHandler.downloadAndEncryptPDF(
  //         pdfUrl, "secure_doc_$identifier");
  //     await SharedPrefService.addToDocumentDirs(encryptedPath);

  //     state = state.copyWith(
  //         status: DocumentStatus.encrypting, encryptedFilePath: encryptedPath);

  //     state = state.copyWith(status: DocumentStatus.decrypting);
  //     final decryptedFile =
  //         await SecureFileHandler.decryptPDF(encryptedPath, "temp_view");

  //     state = state.copyWith(
  //         status: DocumentStatus.loaded, decryptedFilePath: decryptedFile.path);
  //   } catch (e) {
  //     state = state.copyWith(
  //         status: DocumentStatus.error, errorMessage: e.toString());
  //   }
  // }
  Future<void> processPDF(String pdfUrl, String identifier) async {
    try {
      state = state.copyWith(status: DocumentStatus.downloading);

      // Check if the document is already encrypted
      final encryptedFileExists = await SharedPrefService.checkIfDocPathExists(
          "secure_doc_$identifier");

      String encryptedPath;
      if (encryptedFileExists) {
        print("encrypted file existsssssssssss");
        // Retrieve the existing encrypted path
        final prefs = await SharedPreferences.getInstance();
        List<String> docs = prefs.getStringList("documentPaths") ?? [];
        encryptedPath =
            docs.firstWhere((path) => path.contains("secure_doc_$identifier"));

        state = state.copyWith(
            status: DocumentStatus.encrypting,
            encryptedFilePath: encryptedPath);
      } else {
        // Download and encrypt the document
        encryptedPath = await SecureFileHandler.downloadAndEncryptPDF(
            pdfUrl, "secure_doc_$identifier");
        await SharedPrefService.addToDocumentDirs(encryptedPath);

        state = state.copyWith(
            status: DocumentStatus.encrypting,
            encryptedFilePath: encryptedPath);
      }

      state = state.copyWith(status: DocumentStatus.decrypting);
      final decryptedFile =
          await SecureFileHandler.decryptPDF(encryptedPath, "temp_view");

      state = state.copyWith(
          status: DocumentStatus.loaded, decryptedFilePath: decryptedFile.path);
    } catch (e) {
      state = state.copyWith(
          status: DocumentStatus.error, errorMessage: e.toString());
    }
  }
}
