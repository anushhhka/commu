import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heyoo/auth/signup/wait.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileBuildingScreen extends StatelessWidget {
  final String userId = DateTime.now()
      .millisecondsSinceEpoch
      .toString(); // Generate a user ID once

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "Let's Get to Know You",
      instructions: "Please fill out the following details.",
      questions: [
        "Email",
        "Full Name of Married Daughter",
        "Village Name",
        "Full Name of Mavitra"
      ],
      userId: userId, // Pass userId to the next pages
      nextScreen: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondQuestionPage(userId: userId),
        ),
      ),
      progress: 1 / 4,
      showUploadOption: true,
    );
  }
}

class QuestionPage extends StatefulWidget {
  final String title;
  final String instructions;
  final List<String> questions;
  final VoidCallback nextScreen;
  final double progress;
  final bool showUploadOption;
  final String userId; // Add userId

  QuestionPage({
    required this.title,
    required this.instructions,
    required this.questions,
    required this.nextScreen,
    required this.progress,
    required this.userId, // Accept userId
    this.showUploadOption = false,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<TextEditingController> _controllers = [];
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _controllers =
        List.generate(widget.questions.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveAnswersToFirestore() async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('user_profiles')
          .doc(widget.userId);

      // Create a map for the answers
      Map<String, String> answers = {};
      for (int i = 0; i < widget.questions.length; i++) {
        answers[widget.questions[i]] = _controllers[i].text;
      }

      // Update the Firestore document for the current user
      await userDocRef.set({
        'answers': answers,
        'image_path': _image?.path,
      }, SetOptions(merge: true));

      print("Data saved successfully.");
    } catch (e) {
      print("Error saving data to Firestore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[200]!, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              LinearProgressIndicator(
                value: widget.progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.instructions,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 30),
              if (widget.showUploadOption)
                Column(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            child: Icon(Icons.person,
                                color: Colors.grey[700], size: 50),
                          ),
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.upload_file, color: Colors.white),
                      label: Text(
                        "Upload Passport Size Photo",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.questions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          labelText: widget.questions[index],
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          prefixIcon:
                              Icon(Icons.person, color: Colors.blueAccent),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 16),
                          isDense: true,
                        ),
                        style: TextStyle(color: Colors.black87),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveAnswersToFirestore();
                    print("Moving to the next screen.");
                    widget.nextScreen();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 12.0),
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondQuestionPage extends StatelessWidget {
  final String userId;

  SecondQuestionPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "More About You",
      instructions: "Please provide some additional information.",
      questions: [
        "Date of Birth",
        "Hobbies",
        "Education",
        "Blood Group",
        "Mobile/Whatsapp Number",
        "Additional Phone/Mobile Number"
      ],
      userId: userId, // Pass userId to next page
      nextScreen: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThirdQuestionPage(
            userId: userId,
            whatsappNumber: '',
          ),
        ),
      ),
      progress: 2 / 4,
    );
  }
}

class ThirdQuestionPage extends StatelessWidget {
  final String userId;

  ThirdQuestionPage({required this.userId, required String whatsappNumber});

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "Address Information",
      instructions: "Let us know more about your career background.",
      questions: [
        "Residential Address",
        "State",
        "Pin Code",
        "Main Area of City (e.g., Dadar, Dombivali)"
      ],
      userId: userId, // Pass userId to next page
      nextScreen: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FourthQuestionPage(userId: userId),
        ),
      ),
      progress: 3 / 4,
    );
  }
}

class FourthQuestionPage extends StatelessWidget {
  final String userId;

  FourthQuestionPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "Some More Information",
      instructions: "Tell us a bit about your health background.",
      questions: [
        "Total number of family members residing at the same address",
        "Activity/Employee Status",
        "Own or Family's Business/Office Address",
        "Marital Status",
        "Marriage Date"
      ],
      userId: userId, // Pass userId to PendingApprovalScreen
      nextScreen: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PendingApprovalScreen(),
        ),
      ),
      progress: 4 / 4,
    );
  }
}
