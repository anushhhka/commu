import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateAnnouncement extends StatefulWidget {
  const CreateAnnouncement({super.key});

  @override
  _CreateAnnouncementState createState() => _CreateAnnouncementState();
}

class _CreateAnnouncementState extends State<CreateAnnouncement> {
  final TextEditingController _titleController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _createAnnouncement() async {
    try {
      if (_image == null && _titleController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image or enter a title')),
        );
        return;
      }
      String? imageUrl;
      if (_image != null) {
        final storageRef = FirebaseStorage.instance.ref().child('feeds/${DateTime.now().toIso8601String()}');
        final uploadTask = storageRef.putFile(_image!);
        final snapshot = await uploadTask.whenComplete(() => {});
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      final title = _titleController.text;

      final querySnapshot = await FirebaseFirestore.instance.collection('feeds').get();
      final docLength = querySnapshot.docs.length;

      final newDocRef = FirebaseFirestore.instance.collection('feeds').doc((docLength + 1).toString());

      await newDocRef.set({
        'createdAt': Timestamp.now(),
        'image': imageUrl,
        'text': title.trim().isEmpty ? null : title,
      });

      Fluttertoast.showToast(msg: 'Announcement created successfully');

      _titleController.clear();
      setState(() {
        _image = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Announcement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _image != null
                    ? ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(_image!, fit: BoxFit.cover))
                    : const Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 50),
                          SizedBox(height: 10),
                          Text('No image selected'),
                        ],
                      )),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
              ),
            ),
            const SizedBox(height: 50),
            PrimaryElevatedButton(
              onPressed: _createAnnouncement,
              buttonText: 'Create Announcement',
            ),
          ],
        ),
      ),
    );
  }
}
