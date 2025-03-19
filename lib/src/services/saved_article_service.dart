import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news_flutter/src/models/articles_response.dart';
import 'package:sp_util/sp_util.dart';

class SavedArticleService {
  static CollectionReference get reference =>
      FirebaseFirestore.instance.collection("Saved Articles");

  static final _savedStreamController = StreamController.broadcast();

  static Stream get savedStream => _savedStreamController.stream;

  static Future saveArticle(Article article) async {
    final id = convertUrlToFirestoreId(article.url!);
    await reference.doc(id).set({
      ...article.toJson(),
      "user": FirebaseAuth.instance.currentUser!.uid,
    });
    await SpUtil.putObject(id, article.toJson());
    _savedStreamController.add(null);
  }

  static Future unsaveArticle(Article article) async {
    final id = convertUrlToFirestoreId(article.url!);
    await reference.doc(id).delete();
    await SpUtil.remove(id);
    _savedStreamController.add(null);
  }

  static Future sync() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    final querySnapshot = await reference
        .where("user", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    await SpUtil.clear();
    for (final snapshot in querySnapshot.docs) {
      await SpUtil.putObject(snapshot.id, snapshot.data()!);
    }
    _savedStreamController.add(null);
  }

  static String convertUrlToFirestoreId(String url) {
    final bytes = utf8.encode(url); // Convert string to bytes
    final hash = sha256.convert(bytes); // Generate SHA-256 hash
    return hash.toString() +
        (FirebaseAuth.instance.currentUser?.uid ??
            ""); // Return the hash as a hexadecimal string
  }

  static List<Article> getLocalSavedArticles() {
    final keys = List<String>.from(SpUtil.getKeys() ?? []);
    return keys
        .map((key) =>
            Article.fromJson(<String, dynamic>{...SpUtil.getObject(key) ?? {}}))
        .toList();
  }
}
