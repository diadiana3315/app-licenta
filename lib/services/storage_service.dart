import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  // Function to get the local directory
  Future<String> getLocalFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  // Function to save a file locally
  Future<String> saveFileLocally(File file, String fileName) async {
    String filePath = await getLocalFilePath(fileName);
    await file.copy(filePath);
    return filePath;
  }
}
