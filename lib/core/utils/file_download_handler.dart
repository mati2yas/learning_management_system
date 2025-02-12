import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class SecureFileHandler {
  static final _key = encrypt.Key.fromUtf8('12345678901234567890123456789012'); // 32-byte key
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(encrypt.AES(_key));

  /// **Download & Encrypt PDF**
  static Future<String> downloadAndEncryptPDF(String url, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename.enc';

    final response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    final encryptedData = _encrypter.encryptBytes(response.data, iv: _iv);

    final file = File(filePath);
    await file.writeAsBytes(encryptedData.bytes);

    return filePath;
  }

  /// **Decrypt PDF for Viewing**
  static Future<File> decryptPDF(String encryptedFilePath, String outputFilename) async {
    final directory = await getApplicationDocumentsDirectory();
    final outputPath = '${directory.path}/$outputFilename.pdf';

    final file = File(encryptedFilePath);
    final encryptedBytes = await file.readAsBytes();
    final decryptedBytes = _encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: _iv);

    final decryptedFile = File(outputPath);
    await decryptedFile.writeAsBytes(decryptedBytes);

    return decryptedFile;
  }
}
