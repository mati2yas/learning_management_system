import 'document_status.dart';

class DocumentViewState {
  final DocumentStatus status;
  final String? encryptedFilePath;
  final String? decryptedFilePath;
  final String? errorMessage;

  const DocumentViewState({
    required this.status,
    this.encryptedFilePath,
    this.decryptedFilePath,
    this.errorMessage,
  });

  DocumentViewState copyWith({
    DocumentStatus? status,
    String? encryptedFilePath,
    String? decryptedFilePath,
    String? errorMessage,
  }) {
    return DocumentViewState(
      status: status ?? this.status,
      encryptedFilePath: encryptedFilePath ?? this.encryptedFilePath,
      decryptedFilePath: decryptedFilePath ?? this.decryptedFilePath,
      errorMessage: errorMessage,
    );
  }
}

