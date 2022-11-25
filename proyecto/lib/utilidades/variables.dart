import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riesgo/screens/buscar_screen.dart';
import 'package:riesgo/screens/feed_screen.dart';
import 'package:riesgo/screens/postear_screen.dart';
import 'package:riesgo/screens/profile_screen.dart';

var homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  PostearScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  const Text('hola4'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
