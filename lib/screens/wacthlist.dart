import 'package:flutter/material.dart';

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  State<WatchList> createState() => _WatchlistState();
}

class _WatchlistState extends State<WatchList> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Watchlist Page")),
    );
  }
}
