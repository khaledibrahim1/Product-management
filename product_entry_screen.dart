import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductEntryScreen extends StatefulWidget {
  @override
  _ProductEntryScreenState createState() => _ProductEntryScreenState();
}

class _ProductEntryScreenState extends State<ProductEntryScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _submitProduct() async {
    // Check if all fields are filled
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _discountController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.3:5000/add_product'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'name': _nameController.text,
          'price': _priceController.text,
          'discount': _discountController.text,
          'description': _descriptionController.text,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Product added successfully')),
        );
        // Clear fields after successful submission
        _nameController.clear();
        _priceController.clear();
        _discountController.clear();
        _descriptionController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add product')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<List<dynamic>> _displayProducts() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.3:5000/display_products'));
      final responseData = jsonDecode(response.body);

      print(
          'Response Data: $responseData'); // Print response data to check the structure

      if (responseData['products'] == null) {
        return [];
      }

      return responseData['products'];
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _discountController,
              decoration: InputDecoration(
                labelText: 'Discount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProduct,
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<dynamic>>(
              future: _displayProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data![index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(product['name'] ?? 'No Name'),
                            subtitle: Text(
                                'Price: ${product['price'] ?? 'No Price'}'),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('No products found'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
