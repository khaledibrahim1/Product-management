import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditDeleteProductScreen extends StatefulWidget {
  @override
  _EditDeleteProductScreenState createState() =>
      _EditDeleteProductScreenState();
}

class _EditDeleteProductScreenState extends State<EditDeleteProductScreen> {
  final _searchController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Map<String, dynamic>? _searchedProduct;

  Future<void> _searchProduct() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.3:5000/search_product?name=${_searchController.text}'),
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          setState(() {
            _searchedProduct = responseData['product'];
            _nameController.text = _searchedProduct!['name'];
            _priceController.text = _searchedProduct!['price'].toString();
            _discountController.text = _searchedProduct!['discount'].toString();
            _descriptionController.text = _searchedProduct!['description'];
          });
        } else {
          setState(() {
            _searchedProduct = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching product')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to search product')),
      );
    }
  }

  Future<void> _updateProduct() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.3:5000/update_product'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id': _searchedProduct!['id'],
          'name': _nameController.text,
          'price': _priceController.text,
          'discount': _discountController.text,
          'description': _descriptionController.text,
        }),
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product updated successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update product')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating product')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product')),
      );
    }
  }

  Future<void> _deleteProduct() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.3:5000/delete_product'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'id': _searchedProduct!['id'],
        }),
      );
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          setState(() {
            _searchedProduct = null;
            _nameController.clear();
            _priceController.clear();
            _discountController.clear();
            _descriptionController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product deleted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting product')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit/Delete Product'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.teal, // Customize the AppBar color
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Product by Name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _searchProduct(), // Trigger search on submit
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchProduct,
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Customize button color
              ),
            ),
            SizedBox(height: 20),
            _searchedProduct != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _discountController,
                        decoration: InputDecoration(
                          labelText: 'Discount',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _updateProduct,
                            child: Text('Update'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.teal, // Customize button color
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _deleteProduct,
                            child: Text('Delete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.red, // Customize button color
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(child: Text('Product not found')),
          ],
        ),
      ),
    );
  }
}
