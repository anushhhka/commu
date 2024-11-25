import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:heyoo/auth/signup/wait.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VillageMemberSignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "Let's Get to Know You",
      instructions: "Please fill out the following details.",
      questions: [
        "Email",
        "Full Name of the Member",
        "Middle Name / Husband's Name",
        "Mother's Name (Not to be filled by married woman)",
        "Mobile Number (This will be your WhatsApp number)",
      ],
      progress: 1 / 5,
      showUploadOption: true,
      nextScreen: (String whatsappNumber) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SecondQuestionPage(whatsappNumber: whatsappNumber),
        ),
      ),
    );
  }
}

class QuestionPage extends StatefulWidget {
  final String title;
  final String instructions;
  final List<String> questions;
  final double progress;
  final bool showUploadOption;
  final Function(String) nextScreen;

  QuestionPage({
    required this.title,
    required this.instructions,
    required this.questions,
    required this.progress,
    required this.nextScreen,
    this.showUploadOption = false,
  });

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<TextEditingController> _controllers = [];
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String whatsappNumber = ""; // Store WhatsApp number

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
      // Ensure WhatsApp number is valid
      String whatsappNumber = _controllers.last.text
          .trim(); // Assume last question is WhatsApp number
      if (whatsappNumber.isEmpty) {
        throw Exception("WhatsApp number cannot be empty.");
      }

      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('village_user_profiles')
          .doc(whatsappNumber);

      // Store the answers for each page in separate collections
      // Personal Info
      CollectionReference personalInfoRef =
          userDocRef.collection('personal_info');
      for (int i = 0; i < widget.questions.length; i++) {
        await personalInfoRef.doc(widget.questions[i]).set({
          'answer': _controllers[i].text,
        });
      }

      // Image Path (if available)
      if (_image != null) {
        await personalInfoRef.doc('image_path').set({
          'path': _image?.path,
        });
      }

      // Family Info
      CollectionReference familyInfoRef = userDocRef.collection('family_info');
      // Add your family info data here
      await familyInfoRef.doc('family_info').set({
        'answer': 'Family data here', // Replace with actual family data
      });

      // Career Info
      CollectionReference careerInfoRef = userDocRef.collection('career_info');
      // Add your career info data here
      await careerInfoRef.doc('career_info').set({
        'answer': 'Career data here', // Replace with actual career data
      });

      // Address Info
      CollectionReference addressInfoRef =
          userDocRef.collection('address_info');
      // Add your address info data here
      await addressInfoRef.doc('address_info').set({
        'answer': 'Address data here', // Replace with actual address data
      });

      // Health Info
      CollectionReference healthInfoRef = userDocRef.collection('health_info');
      // Add your health info data here
      await healthInfoRef.doc('health_info').set({
        'answer': 'Health data here', // Replace with actual health data
      });

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
                    widget.nextScreen(whatsappNumber);
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
  final String whatsappNumber;

  SecondQuestionPage({required this.whatsappNumber});

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "More About You",
      instructions: "Please provide some additional information.",
      questions: [
        "Grandfather's Name/Father in law's name",
        "Grandmother's name",
        "Surname",
        "Full Name of Family Head",
        "Relation with Head of the family",
      ],
      progress: 2 / 5,
      nextScreen: (String _) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ThirdQuestionPage(whatsappNumber: whatsappNumber),
        ),
      ),
    );
  }
}

class ThirdQuestionPage extends StatelessWidget {
  final String whatsappNumber;

  ThirdQuestionPage({required this.whatsappNumber});

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "Career Background",
      instructions:
          "Let us know more about your career and address information.",
      questions: [
        "Date of Birth",
        "Hobbies",
        "Education",
        "Education Status",
        "Blood Group",
      ],
      progress: 3 / 5,
      nextScreen: (String _) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FourthQuestionPage(
            whatsappNumber: whatsappNumber,
            userId: '',
          ),
        ),
      ),
    );
  }
}

class FourthQuestionPage extends StatelessWidget {
  final String whatsappNumber;

  FourthQuestionPage({required this.whatsappNumber, required String userId});

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "Some More Information",
      instructions: "Tell us a bit about your health background.",
      questions: [
        "Residential Address",
        "State",
        "Pin Code",
        "Activity/Employee Status",
        "Own or Family's Business/Office Address",
        "Total number of family members residing at the same address",
      ],
      progress: 4 / 5,
      nextScreen: (String _) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FifthQuestionPage(
              userId: '',
              whatsappNumber: whatsappNumber), // Pass the whatsappNumber
        ),
      ),
      showUploadOption: false, // Assuming no upload option is needed here
    );
  }
}

class FifthQuestionPage extends StatelessWidget {
  final String userId;
  final String
      whatsappNumber; // Add this if you also want to pass whatsappNumber

  FifthQuestionPage(
      {required this.userId,
      required this.whatsappNumber}); // Include whatsappNumber if needed

  @override
  Widget build(BuildContext context) {
    return QuestionPage(
      title: "Some More Information",
      instructions: "Tell us a bit about your health background.",
      questions: [
        "Married Status",
        "Married Date",
        "Mavitra Name(For Married woman only)",
        "Mavitra Village(For Married woman only)",
      ],
      // userId: userId, // Pass userId to QuestionPage
      nextScreen: (String _) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PendingApprovalScreen(), // Ensure PendingApprovalScreen accepts necessary parameters
        ),
      ),
      progress: 5 / 5,
    );
  }
}
