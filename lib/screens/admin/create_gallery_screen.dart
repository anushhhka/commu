import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heyoo/widgets/primary_elevated_button.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateGallery extends StatefulWidget {
  const CreateGallery({super.key});

  @override
  _CreateGalleryState createState() => _CreateGalleryState();
}

class _CreateGalleryState extends State<CreateGallery> {
  final TextEditingController _titleController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _createAnnouncement() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
      String? imageUrl;
      if (_image != null) {
        final storageRef = FirebaseStorage.instance.ref().child('gallery/${DateTime.now().toIso8601String()}');
        final uploadTask = storageRef.putFile(_image!);
        final snapshot = await uploadTask.whenComplete(() => {});
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      final querySnapshot = await FirebaseFirestore.instance.collection('gallery').get();
      final docLength = querySnapshot.docs.length;

      final newDocRef = FirebaseFirestore.instance.collection('gallery').doc((docLength + 1).toString());

      await newDocRef.set({
        'image': imageUrl,
      });

      Fluttertoast.showToast(msg: 'Image uploaded successfully');

      _titleController.clear();
      setState(() {
        _image = null;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image to Gallery'),
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
            const SizedBox(height: 50),
            PrimaryElevatedButton(
              onPressed: _isLoading ? null : _createAnnouncement,
              buttonText: 'Save',
              child: _isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
