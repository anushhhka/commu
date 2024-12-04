import 'package:flutter/material.dart';

class ContactBookScreen extends StatefulWidget {
  @override
  _ContactBookScreenState createState() => _ContactBookScreenState();
}

class _ContactBookScreenState extends State<ContactBookScreen> {
  // The current index of the selected tab
  int _selectedIndex = 0;

  // List of widgets for the tabs
  final List<Widget> _screens = [
    VillageMembersScreen(),
    NiyaniScreen(),
  ];

  // Function to change the selected index when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Book")),
      body: _screens[_selectedIndex], // Display the corresponding screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Handle tab taps
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Village Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Niyani',
          ),
        ],
      ),
    );
  }
}

// Screen for Village Members
class VillageMembersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Village Members Content Goes Here",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

// Screen for Niyani
class NiyaniScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Niyani Content Goes Here",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
