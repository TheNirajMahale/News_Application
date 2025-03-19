import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_flutter/src/models/articles_response.dart';
import 'package:news_flutter/src/models/enums/news_category.dart';

// This class handles API calls to fetch news articles from the News API.
class NewsApiService {
  // Replace this with your actual API key from News API.
  static const String _apiKey = "c9360f0ff2f24e7aab6b97ee6684c7ba";

  // This method retrieves the top headlines for a specific country.
  // The default country is set to "in" (India), but you can change it.
  static Future<List<Article>> getTopHeadlines({
    int page = 1,
    String country = "us",
    NewsCategory category = NewsCategory.general,
  }) async {
    try {
      // Constructing the API request URL using the country and API key.
      final response = await http.get(Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=$country&category=${category.name}&page=${page.toString()}&pageSize=10&apiKey=$_apiKey",
      ));

      log(response.request!.url.toString());

      // Decoding the JSON response and mapping it to the ArticlesResponse model.
      final articleResponse = ArticlesResponse.fromJson(
        jsonDecode(response.body),
      );

      // Check if the response status is "ok" (success).
      if (articleResponse.status == "ok") {
        // Return the list of articles, or an empty list if none are found.
        return articleResponse.articles ?? [];
      } else {
        // Throw an error if the status is not "200".
        throw articleResponse.message ?? "Something went wrong!!";
      }
    } catch (error, stackTrace) {
      // Print error details to the console for debugging.
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      // Rethrow the error for further handling if needed.
      rethrow;
    }
  }
}
