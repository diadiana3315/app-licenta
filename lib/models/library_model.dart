import 'dart:io';

import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class LibraryModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  List<Map<String, dynamic>> folders = [];

  void setFolders(List<dynamic> folders) {
    folders = folders;
    notifyListeners();
  }

  // Load folders from Firestore and update the model
  Future<void> loadFolders(String uid) async {
    _firestoreService.getFolders(uid).listen((snapshot) {
      folders = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'folderName': doc['folderName'],
        };
      }).toList();
      notifyListeners();  // Update the UI
    });
  }

  // Function to add folder
  Future<void> addFolder(String uid, String folderName) async {
    await _firestoreService.addFolder(uid, folderName);
    // notifyListeners();  // Update the UI
  }

  // Function to delete folder
  Future<void> deleteFolder(String uid, String folderId) async {
    await _firestoreService.deleteFolder(uid, folderId);
    notifyListeners();  // Update the UI
  }

  // Function to add file
  Future<void> addFile(String uid, String folderId, File file) async {
    // Save file locally
    String localFilePath = await _storageService.saveFileLocally(file, file.uri.pathSegments.last);
    String fileUrl = 'file://$localFilePath';  // Local URL for the file

    // Save file reference in Firestore
    await _firestoreService.addFileReference(uid, folderId, file.uri.pathSegments.last, fileUrl);
    notifyListeners();  // Update the UI
  }
}
