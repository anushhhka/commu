import 'package:flutter/material.dart';

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  String? selectedOption; // Variable to store selected dropdown value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download Options"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Please choose an Download option:",
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
                  if (newValue == "Download Recent Forms") {
                    // Navigate to a screen to upload recent forms
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DownloadRecentFormsScreen()),
                    );
                  } else if (newValue == "Download a Scanned Copy of Form") {
                    // Navigate to a screen to upload a scanned copy
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DownloadScannedFormScreen()),
                    );
                  } else if (newValue == "Download a PDF Required") {
                    // Navigate to a screen to upload a PDF
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DownloadPdfScreen()),
                    );
                  }
                }
              },
              items: <String>[
                'Download Recent Forms',
                'Download a Scanned Copy of Form',
                'Download a PDF Required',
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
class DownloadRecentFormsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download Recent Forms")),
      body: Center(
        child: Text("Download Recent Forms Screen"),
      ),
    );
  }
}

// Placeholder screen for uploading a scanned copy of a form
class DownloadScannedFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download Scanned Copy of Form")),
      body: Center(
        child: Text("Download Scanned Copy of Form Screen"),
      ),
    );
  }
}

// Placeholder screen for uploading a PDF
class DownloadPdfScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download PDF Required")),
      body: Center(
        child: Text("Download PDF Screen"),
      ),
    );
  }
}
