import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchProductScreen extends StatefulWidget {
  @override
  _SearchProductScreenState createState() => _SearchProductScreenState();
}

class _SearchProductScreenState extends State<SearchProductScreen> {
  final _searchController = TextEditingController();
  Map<String, dynamic>? _searchedProduct;

  Future<void> _searchProduct() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.3:5000/search_product?name=${_searchController.text}'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          setState(() {
            _searchedProduct = responseData['product'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Product'),
        backgroundColor: Colors.teal,
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
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchProduct,
              child: Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Button color
              ),
            ),
            SizedBox(height: 20),
            _searchedProduct != null
                ? Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Details',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SizedBox(height: 10),
                          ListTile(
                            leading: Icon(Icons.label),
                            title: Text('Name'),
                            subtitle: Text(_searchedProduct!['name'] ?? 'N/A'),
                          ),
                          ListTile(
                            leading: Icon(Icons.attach_money),
                            title: Text('Price'),
                            subtitle: Text(_searchedProduct!['price'] ?? 'N/A'),
                          ),
                          ListTile(
                            leading: Icon(Icons.discount),
                            title: Text('Discount'),
                            subtitle:
                                Text(_searchedProduct!['discount'] ?? 'N/A'),
                          ),
                          ListTile(
                            leading: Icon(Icons.description),
                            title: Text('Description'),
                            subtitle:
                                Text(_searchedProduct!['description'] ?? 'N/A'),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: Text('No product details found')),
          ],
        ),
      ),
    );
  }
}
