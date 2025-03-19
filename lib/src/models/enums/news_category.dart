import 'package:flutter/material.dart';

enum NewsCategory {
  general("General", Icons.newspaper),
  business("Business", Icons.work),
  entertainment("Entertainment", Icons.movie_creation),
  health("Health", Icons.local_hospital),
  science("Science", Icons.science),
  sports("Sports", Icons.sports_cricket),
  technology("Technology", Icons.devices),
  ;

  final String title;
  final IconData icon;

  const NewsCategory(this.title, this.icon);
}
