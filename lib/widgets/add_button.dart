import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class AddFunctions {
  static final FirestoreService _firestoreService = FirestoreService();
  static final StorageService _storageService = StorageService();

  // Functionalities for add folder option
  static void addFolder(BuildContext context, Function(String) onFolderAdded) {
    TextEditingController _folderNameController = TextEditingController();
    final userId = FirebaseAuth.instance.currentUser?.uid;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Folder'),
          content: TextField(
            controller: _folderNameController,
            decoration: InputDecoration(hintText: "Enter folder name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () async {
                String folderName = _folderNameController.text;
                if (folderName.isNotEmpty && userId != null) {
                  await _firestoreService.addFolder(userId, folderName);
                  onFolderAdded(folderName); // Call the callback
                  Navigator.of(context).pop(); // Close dialog
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Functionalities for the add pdf option
  static void addPDF(BuildContext context) async {
    try {
      // Open the file picker for PDF files
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        File selectedFile = File(result.files.single.path!);
        String fileName = result.files.single.name;

        // Save file locally
        String filePath = await _storageService.saveFileLocally(selectedFile, fileName);

        String fileUrl = 'file://$filePath';
        await _firestoreService.addFileReference('uid', 'folderId', fileName, fileUrl);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File added: $fileName")),
        );
      } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No PDF selected")),
          );
        }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error picking PDF: $e")),
        );
    }
  }

  // static void addImage(BuildContext context) async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['jpg', 'jpeg'],
  //     );
  //
  //     if (result != null) {
  //       String filePath = result.files.single.path!;
  //       File imageFile = File(filePath);
  //
  //       // Save image file locally
  //       String localFilePath = await _storageService.saveFileLocally(imageFile, imageFile.uri.pathSegments.last);
  //
  //       // Save file reference in Firestore (only the local URL or path is stored)
  //       String fileUrl = 'file://$localFilePath'; // URL to the local file
  //
  //       // await _firestoreServiceoreService.addFileReference(fileUrl, 'image', 'folderId', imageFile.uri.pathSegments.last as File);
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Image saved locally and uploaded to Firestore.")),
  //         );
  //     } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text("No image selected")),
  //         );
  //     }
  //   } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error picking image: $e")),
  //       );
  //   }
  // }
}

