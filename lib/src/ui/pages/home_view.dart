import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:news_flutter/src/models/articles_response.dart';
import 'package:news_flutter/src/models/enums/news_category.dart';
import 'package:news_flutter/src/services/news_api_service.dart';
import 'package:news_flutter/src/services/saved_article_service.dart';
import 'package:news_flutter/src/ui/widgets/article_item_view.dart';
import 'package:news_flutter/src/utils/app_routes.dart';

// HomeView is a StatefulWidget that represents the main screen of the app.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

// State class for HomeView that manages the UI state.
class _HomeViewState extends State<HomeView> {
  final pagingController = PagingController<int, Article>(
    firstPageKey: 1,
  );

  String? error; // Variable to store error messages.
  bool loading = false; // Loading indicator state.
  List<Article> articles = []; // List to hold fetched articles.

  NewsCategory selectedCategory = NewsCategory.general;

  // Method to update selectedCategory and refresh headlines
  void updateCategory(NewsCategory category) {
    setState(() {
      selectedCategory = category;
    });
    pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      debugPrint("Called");
      final newItems = await NewsApiService.getTopHeadlines(
        category: selectedCategory,
        page: pageKey,
      );
      final isLastPage = newItems.length < 10;

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    SavedArticleService.sync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App title in the AppBar.
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Material(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(100),
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: Builder(builder: (context) {
            return ListTile(
              horizontalTitleGap: 0,
              title: Text("Search Notes"),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: Scaffold.of(context).openDrawer,
              ),
              onTap: () => ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  SnackBar(content: Text("We're working on this feature")),
                ),
            );
          }),
        ),
      ),
      // A Navigation Drawer for selecting categories
      drawer: _getDrawer(context),
      // Main body of the screen.
      body: SafeArea(child: _getPage(context)),
    );
  }

  Widget _getDrawer(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return NavigationDrawer(
      selectedIndex: selectedCategory.index,
      onDestinationSelected: (index) {
        Navigator.pop(context);
        if (index < NewsCategory.values.length) {
          updateCategory(NewsCategory.values[index]);
        } else {
          final newIndex = index - NewsCategory.values.length;
          if (newIndex == 0) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(content: Text("We're working on this feature")),
              );
          } else if (newIndex == 1) {
            if (FirebaseAuth.instance.currentUser == null) {
              Navigator.push(context, AppRoutes.signIn);
            } else {
              Navigator.push(context, AppRoutes.savedArticles);
            }
          } else {
            FirebaseAuth.instance.signOut().then(
                  (value) => Navigator.pushAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (route) => false,
                  ),
                );
          }
        }
      },
      children: [
        ListTile(
          title: Text("News Categories"),
          titleTextStyle: textTheme.headlineSmall!,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
        ),
        const SizedBox(height: 16),
        ...NewsCategory.values.map(
          (category) => NavigationDrawerDestination(
            icon: Icon(category.icon),
            label: Text(category.title),
          ),
        ),
        Divider(),
        NavigationDrawerDestination(
          label: Text("Country - US"),
          icon: Icon(Icons.public),
        ),
        if (FirebaseAuth.instance.currentUser == null)
          NavigationDrawerDestination(
            label: Text("Login"),
            icon: Icon(Icons.login),
          )
        else ...[
          NavigationDrawerDestination(
            label: Text("Saved Articles"),
            icon: Icon(Icons.bookmark),
          ),
          NavigationDrawerDestination(
            label: Text("Logout"),
            icon: Icon(Icons.logout),
          ),
        ],
      ],
    );
  }

  // Method to build the main content based on loading state or errors.
  Widget _getPage(BuildContext context) {
    return PagedListView<int, Article>(
      pagingController: pagingController,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      builderDelegate: PagedChildBuilderDelegate(
        animateTransitions: true,
        itemBuilder: (context, article, index) =>
            ArticleItemView(article: article),
      ),
    );
  }
}
