import 'package:flutter/material.dart';
import 'package:news_flutter/src/services/saved_article_service.dart';
import 'package:news_flutter/src/ui/widgets/article_item_view.dart';

class SavedArticlesView extends StatefulWidget {
  const SavedArticlesView({super.key});

  @override
  State<SavedArticlesView> createState() => _SavedArticlesViewState();
}

class _SavedArticlesViewState extends State<SavedArticlesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Articles")),
      body: SafeArea(
        child: StreamBuilder(
          stream: SavedArticleService.savedStream,
          builder: (context, snapshot) {
            final articles = SavedArticleService.getLocalSavedArticles();

            return ListView.builder(
              // Number of articles to display.
              itemCount: articles.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                // Get the article at the current index.
                final article = articles[index];
                // Display the article using a custom widget.
                return ArticleItemView(article: article);
              },
            );
          },
        ),
      ),
    );
  }
}
