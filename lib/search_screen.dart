import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List searchResults = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool hasError = false;

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        hasError = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http
          .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));

      if (response.statusCode == 200) {
        setState(() {
          searchResults = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load results');
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search for movies...',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
          ),
          onSubmitted: searchMovies,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : hasError
              ? const Center(
                  child: Text(
                    'An error occurred. Please try again later.',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              : searchResults.isEmpty
                  ? const Center(
                      child: Text(
                        'Search Movie',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final movie = searchResults[index]['show'];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          color: Colors.grey[900],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                movie['image']?['medium'] ??
                                    'https://via.placeholder.com/150',
                                height: 100,
                                width: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 100,
                                    width: 70,
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              movie['name'] ?? 'Unknown Title',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(
                              movie['genres']?.join(', ') ?? 'No genre info',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/details',
                                  arguments: movie);
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}
