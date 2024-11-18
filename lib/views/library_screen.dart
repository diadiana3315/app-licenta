// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../models/library_model.dart';
//
// class LibraryScreen extends StatelessWidget {
//   const LibraryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final libraryModel = Provider.of<LibraryModel>(context);  // Access the state
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Library')),
//       body: ListView.builder(
//         itemCount: libraryModel.folders.length,
//         itemBuilder: (context, index) {
//           final folderName = libraryModel.folders[index];  // Get folder name
//
//           // Wrap ListTile with Dismissible for swipe-to-delete
//           return Dismissible(
//             key: Key(folderName),  // Unique key for each item
//             direction: DismissDirection.endToStart,  // Swipe from right to left
//
//             // Red background with "Delete" text on swipe
//             background: Container(
//               color: Colors.redAccent,
//               alignment: Alignment.centerRight,  // Align to right
//               padding: EdgeInsets.only(right: 20),  // Padding from right edge
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Icon(Icons.delete, color: Colors.white),  // Delete icon
//                   SizedBox(width: 8),
//                   Text(
//                     'Delete',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // What happens when the item is dismissed
//             onDismissed: (direction) {
//               libraryModel.deleteFolder(folderName);  // Remove folder
//
//               // Show snackbar to confirm deletion
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('$folderName deleted'),
//                   duration: Duration(seconds: 1),
//               ));
//             },
//
//             child: ListTile(
//               leading: Icon(Icons.folder),
//               title: Text(folderName),
//               onTap: () {
//                 // Navigate to FolderScreen on tap
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FolderScreen(folderName: folderName),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class FolderScreen extends StatelessWidget {
//   final String folderName;
//
//   const FolderScreen({super.key, required this.folderName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(folderName)),
//       body: Center(
//         child: Text('Welcome to the folder: $folderName'),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/library_model.dart';
import '../services/firestore_service.dart';
import 'folder_screen.dart';

class LibraryScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final libraryModel = Provider.of<LibraryModel>(context);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId != null) {
      libraryModel.loadFolders(userId);
    }

    return Scaffold(
      appBar: AppBar(title: Text('Library')),
      body: libraryModel.folders.isEmpty
          ? Center(child: Text("No folders found"))
          : ListView.builder(
              itemCount: libraryModel.folders.length,
              itemBuilder: (context, index) {
                var folder = libraryModel.folders[index];
                return ListTile(
                  title: Text(folder['folderName']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FolderScreen(folderId: folder['id']),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
