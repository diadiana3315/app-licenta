import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a new folder for a specific user
  Future<void> addFolder(String uid, String folderName) async {
    try {
      await _firestore.collection('users').doc(uid).collection('folders').add({
        'folderName': folderName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding folder: $e");
    }

  }

  // Delete a folder
  Future<void> deleteFolder(String uid, String folderId) async {
    await _firestore.collection('users').doc(uid).collection('folders').doc(folderId).delete();
  }

  // Add a file reference after saving it locally
  Future<void> addFileReference(String uid, String folderId, String fileName, String fileUrl) async {
    try{
      await _firestore.collection('users').doc(uid).collection('folders').doc(folderId).collection('files').add({
        'fileName': fileName,
        'fileUrl': fileUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('File reference added successfully to Firestore');
    } catch (e) {
      print('Error adding file reference: $e');
    }
  }

  // Retrieve folders for the user
  Stream<QuerySnapshot> getFolders(String uid) {
    return _firestore.collection('users')
        .doc(uid)
        .collection('folders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Retrieve files in a specific folder
  Stream<QuerySnapshot> getFiles(String uid, String folderId) {
    return _firestore.collection('users').doc(uid).collection('folders').doc(folderId).collection('files').snapshots();
  }
}
