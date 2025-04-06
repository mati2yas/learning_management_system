import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/file_download_handler.dart';
import 'package:lms_system/core/utils/shared_pref/shared_pref.dart';
import 'package:lms_system/features/document_viewer/model/document_viewer_model.dart';

import '../model/document_status.dart';

final documentProvider =
    StateNotifierProvider<DocumentNotifier, DocumentViewState>(
  (ref) => DocumentNotifier(),
);

class DocumentNotifier extends StateNotifier<DocumentViewState> {
  DocumentNotifier()
      : super(const DocumentViewState(status: DocumentStatus.idle));

  Future<void> processPDF(String pdfUrl, String identifier) async {
    String encryptedPath = "";
    try {
      state = state.copyWith(status: DocumentStatus.downloading);

      // Check if the document is already encrypted
      final encryptedFilePath = await SharedPrefService.getEncryptedFilePath(
          "secure_doc_$identifier");

      if (encryptedFilePath != null && await File(encryptedFilePath).exists()) {
        debugPrint("encrypted file existsss");
        debugPrint(encryptedFilePath);
        state = state.copyWith(
            status: DocumentStatus.encrypting,
            encryptedFilePath: encryptedFilePath);
        encryptedPath = encryptedFilePath;
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
      debugPrint(state.errorMessage);
    }
  }
}
