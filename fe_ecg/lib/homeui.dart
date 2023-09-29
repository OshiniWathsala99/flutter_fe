import 'package:flutter/material.dart';
import 'package:fe_ecg/app_routes.dart';

class homeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        // Create a Drawer widget for the navigation menu
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'App Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                // Navigate to the Home screen (close the drawer first)
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                // Navigate to the Login screen (close the drawer first)
                Navigator.pushNamed(context, AppRoutes.login);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Registration'),
              onTap: () {
                // Navigate to the Registration screen (close the drawer first)
                Navigator.pushNamed(context, AppRoutes.registration);
              },
            ),
            // Add more menu items as needed
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to the Home Screen!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
