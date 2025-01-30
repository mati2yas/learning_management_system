import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/utils/file_download_handler.dart';
import 'package:lms_system/features/document_viewer/model/document_viewer_model.dart';

import '../model/document_status.dart';

final documentProvider =
    StateNotifierProvider<DocumentNotifier, DocumentViewState>(
  (ref) => DocumentNotifier(),
);

class DocumentNotifier extends StateNotifier<DocumentViewState> {
  DocumentNotifier()
      : super(const DocumentViewState(status: DocumentStatus.idle));

  Future<void> processPDF(String pdfUrl) async {
    try {
      state = state.copyWith(status: DocumentStatus.downloading);
      final encryptedPath =
          await SecureFileHandler.downloadAndEncryptPDF(pdfUrl, "secure_file");

      state = state.copyWith(
          status: DocumentStatus.encrypting, encryptedFilePath: encryptedPath);

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
