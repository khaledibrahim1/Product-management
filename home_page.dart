import 'package:flutter/material.dart';
import 'product_entry_screen.dart'; // Import the ProductEntryScreen
import 'edit_delete_product_screen.dart'; // Import the EditDeleteProductScreen
import 'search_product_screen.dart'; // Import the SearchProductScreen

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
        backgroundColor: Colors.teal, // Optional: Customize the AppBar color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Services',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal, // Optional: Customize the text color
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Adjust the number of columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildGridItem(
                    context,
                    'assets/images/Add Product.png',
                    'Add Product',
                    ProductEntryScreen(), // Navigate to ProductEntryScreen
                  ),
                  _buildGridItem(
                    context,
                    'assets/images/EditDelete Product.jpg',
                    'Edit/Delete Product',
                    EditDeleteProductScreen(), // Navigate to EditDeleteProductScreen
                  ),
                  _buildGridItem(
                    context,
                    'assets/images/Search Product.jpeg',
                    'Search Product',
                    SearchProductScreen(), // Navigate to SearchProductScreen
                  ),
                  // Add more items here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String imagePath, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 5, // Add shadow to the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal, // Optional: Customize the text color
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
