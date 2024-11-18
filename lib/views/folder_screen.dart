import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

class FolderScreen extends StatelessWidget {
  final String folderId;

  FolderScreen({required this.folderId});

  @override
  Widget build(BuildContext context) {
    final userId = 'user-unique-id';  // Replace with actual UID from auth
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(title: Text('Files')),
      body: StreamBuilder(
        stream: firestoreService.getFiles(userId, folderId),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          var files = snapshot.data.docs;

          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, index) {
              var file = files[index];
              return ListTile(
                title: Text(file['fileName']),
                onTap: () {
                  // Open or download the file using file['fileUrl']
                },
              );
            },
          );
        },
      ),
    );
  }
}
