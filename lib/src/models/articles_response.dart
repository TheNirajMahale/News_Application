/*
* This is a data model class that represents the response from the News API.
* It is generated using https://app.quicktype.io/, which helps in creating
* type-safe data models from JSON responses.
*
* The response structure can be referenced at:
* https://newsapi.org/docs/endpoints/everything
*/

// Online - Firestore (https://pub.dev/packages/cloud_firestore), Offline - HiveDB (https://pub.dev/packages/hive)

class ArticlesResponse {
  final String? status; // Status of the response (e.g., "ok" or "error")
  final int? totalResults; // Total number of results available
  final String? code; // Error code if any (optional)
  final String? message; // Error message if any (optional)
  final List<Article>? articles; // List of articles returned by the API

  ArticlesResponse({
    this.status,
    this.totalResults,
    this.code,
    this.message,
    this.articles,
  });

  // Factory constructor to create an ArticlesResponse object from JSON
  factory ArticlesResponse.fromJson(Map<String, dynamic> json) =>
      ArticlesResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        code: json["code"],
        message: json["message"],
        articles: json["articles"] == null
            ? [] // Return an empty list if no articles are present
            : List<Article>.from(
                json["articles"]!.map((x) => Article.fromJson(x)),
              ),
      );

  // Converts the ArticlesResponse object back to JSON
  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "code": code,
        "message": message,
        "articles": articles == null
            ? [] // Return an empty list if no articles are present
            : List<dynamic>.from(articles!.map((x) => x.toJson())),
      };
}

// Model representing a single news article
class Article {
  final Source? source; // Source of the article (e.g., CNN, BBC)
  final String? author; // Author of the article (if available)
  final String? title; // Title of the article
  final String? description; // Brief description of the article
  final String? url; // URL to the full article
  final String? urlToImage; // URL to an image related to the article
  final DateTime? publishedAt; // Date and time when the article was published
  final String? content; // Full content of the article (if available)

  Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  // Factory constructor to create an Article object from JSON
  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: json["source"] == null ? null : Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: json["publishedAt"] == null
            ? null
            : DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  // Converts the Article object back to JSON
  Map<String, dynamic> toJson() => {
        "source": source?.toJson(),
        "author": author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt?.toIso8601String(),
        "content": content,
      };
}

// Model representing the source of the article
class Source {
  final String? id; // ID of the source (if available)
  final String? name; // Name of the source (e.g., CNN, BBC)

  Source({
    this.id,
    this.name,
  });

  // Factory constructor to create a Source object from JSON
  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  // Converts the Source object back to JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
