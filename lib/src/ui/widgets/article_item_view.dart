import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter/src/models/articles_response.dart';
import 'package:news_flutter/src/services/saved_article_service.dart';
import 'package:news_flutter/src/utils/app_routes.dart';
import 'package:sp_util/sp_util.dart';
import 'package:url_launcher/url_launcher_string.dart';

// ArticleItemView is a StatelessWidget that displays a single article.
class ArticleItemView extends StatelessWidget {
  // The article to be displayed.
  final Article article;

  const ArticleItemView({
    super.key,
    // Required parameter for the article.
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card.outlined(
      // Margin around the card.
      margin: const EdgeInsets.all(8),
      // Clip the card's corners.
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        onTap: article.url != null ? () => launchUrlString(article.url!) : null,
        child: Column(
          children: [
            // If the article has an image URL, display the image.
            if (article.urlToImage != null)
              CachedNetworkImage(
                // Load the image from the network.
                imageUrl: article.urlToImage!,
                // Fixed height for the image.
                height: 200,
                // Full width for the image.
                width: double.maxFinite,
                // Cover the available space while maintaining aspect ratio.
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  );
                },
                errorWidget: (context, url, error) => Material(
                  color: colorScheme.surfaceContainer,
                  child: Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ListTile(
              // Padding inside the ListTile.
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                // Display the article title or a placeholder if not available.
                article.title ?? "Not Available",
                // Bold text for the title.
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: StreamBuilder(
                stream: SavedArticleService.savedStream,
                builder: (context, snapshot) {
                  final isSaved = SpUtil.containsKey(
                        SavedArticleService.convertUrlToFirestoreId(
                            article.url!),
                      ) ??
                      false;

                  return IconButton(
                    isSelected: isSaved,
                    color: colorScheme.primary,
                    icon: Icon(Icons.bookmark_outline),
                    selectedIcon: Icon(Icons.bookmark),
                    onPressed: () {
                      if (FirebaseAuth.instance.currentUser == null) {
                        Navigator.push(context, AppRoutes.signIn);
                        return;
                      }
                      if (isSaved) {
                        SavedArticleService.unsaveArticle(article);
                      } else {
                        SavedArticleService.saveArticle(article);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
