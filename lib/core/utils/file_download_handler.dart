import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SecureFileHandler {
  static final _key =
      encrypt.Key.fromUtf8('12345678901234567890123456789012'); // 32-byte key
  static final _iv = encrypt.IV.fromLength(16);
  static final _encrypter = encrypt.Encrypter(
      encrypt.AES(_key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

  /// **Decrypt PDF for Viewing**
  // static Future<File> decryptPDF(
  //     String encryptedFilePath, String outputFilename) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final outputPath = '${directory.path}/$outputFilename.pdf';
  //   debugPrint("output path: $outputPath");

  //   final file = File(encryptedFilePath);
  //   final encryptedBytes = await file.readAsBytes();
  //   final decryptedBytes =
  //       _encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: _iv);

  //   final decryptedFile = File(outputPath);
  //   await decryptedFile.writeAsBytes(decryptedBytes);

  //   return decryptedFile;
  // }

  static Future<File> decryptPDF(
      String encryptedFilePath, String outputFilename) async {
    final directory = await getApplicationDocumentsDirectory();
    final outputPath = '${directory.path}/$outputFilename.pdf';

    final file = File(encryptedFilePath);
    final encryptedBytes = await file.readAsBytes();

    if (encryptedBytes.length < 16) {
      throw Exception("Invalid encrypted file: too short");
    }

    // Extract IV and encrypted data separately
    final iv = encrypt.IV(Uint8List.fromList(encryptedBytes.sublist(0, 16)));
    final encryptedData =
        encrypt.Encrypted(Uint8List.fromList(encryptedBytes.sublist(16)));

    debugPrint("Extracted IV: ${iv.base16}");
    debugPrint("Decryption started...");

    // Decrypt using extracted IV
    final decryptedBytes = _encrypter.decryptBytes(encryptedData, iv: iv);

    final decryptedFile = File(outputPath);
    await decryptedFile.writeAsBytes(decryptedBytes);

    // Validate that the file starts with %PDF-
    final firstBytes = String.fromCharCodes(decryptedBytes.take(5));
    debugPrint("Decrypted file header: $firstBytes");

    if (!firstBytes.startsWith("%PDF-")) {
      throw Exception("Decryption failed: File is not a valid PDF");
    }

    return decryptedFile;
  }

  static Future<String> downloadAndEncryptPDF(
      String url, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename.enc';

    final response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));

    // Generate a **random IV** for each encryption
    final iv = encrypt.IV.fromLength(16);

    // Encrypt the file
    final encryptedData = _encrypter.encryptBytes(response.data, iv: iv);

    // Combine IV + Encrypted Data
    final file = File(filePath);
    await file.writeAsBytes(
        iv.bytes + encryptedData.bytes); // Store IV at the beginning

    debugPrint(
        "Encrypted file saved: $filePath (Size: ${encryptedData.bytes.length})");

    return filePath;
  }

  /// **Download & Encrypt PDF**
  // static Future<String> downloadAndEncryptPDF(
  //     String url, String filename) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/$filename.enc';

  //   final response = await Dio()
  //       .get(url, options: Options(responseType: ResponseType.bytes));
  //   final encryptedData = _encrypter.encryptBytes(response.data, iv: _iv);

  //   final file = File(filePath);
  //   await file.writeAsBytes(encryptedData.bytes);

  //   return filePath;
  // }
}
