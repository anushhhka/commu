import 'package:flutter/material.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? selectedOption; // Variable to store selected dropdown value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Options"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please choose an upload option:",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedOption,
              hint: Text("Select an option"),
              onChanged: (String? newValue) {
                setState(() {
                  selectedOption = newValue;
                });

                // Perform different actions based on the selected option
                if (newValue != null) {
                  if (newValue == "Upload Recent Forms") {
                    // Navigate to a screen to upload recent forms
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadRecentFormsScreen()),
                    );
                  } else if (newValue == "Upload a Scanned Copy of Form") {
                    // Navigate to a screen to upload a scanned copy
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadScannedFormScreen()),
                    );
                  } else if (newValue == "Upload a PDF Required") {
                    // Navigate to a screen to upload a PDF
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadPdfScreen()),
                    );
                  }
                }
              },
              items: <String>[
                'Upload Recent Forms',
                'Upload a Scanned Copy of Form',
                'Upload a PDF Required',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            // Add any other UI elements here if necessary
          ],
        ),
      ),
    );
  }
}

// Placeholder screen for uploading recent forms
class UploadRecentFormsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Recent Forms")),
      body: Center(
        child: Text("Upload Recent Forms Screen"),
      ),
    );
  }
}

// Placeholder screen for uploading a scanned copy of a form
class UploadScannedFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Scanned Copy of Form")),
      body: Center(
        child: Text("Upload Scanned Copy of Form Screen"),
      ),
    );
  }
}

// Placeholder screen for uploading a PDF
class UploadPdfScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload PDF Required")),
      body: Center(
        child: Text("Upload PDF Screen"),
      ),
    );
  }
}
