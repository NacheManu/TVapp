import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tv_app/provider/favorite_provider.dart';
import 'package:tv_app/screens/show_screen.dart';
import 'package:tv_app/widgets/shows_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedPageIndex = 0;
  bool _isSearching = false;
  bool _isSorted = false;
  late String _searchQuery = '';

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchQuery = '';
    });
  }

  Future<List<dynamic>> _performSearch(String query) async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/search/shows?q=$query'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> _fetchFavorites(List<String> favoriteShows) async {
    final List<dynamic> favoritesList = [];
    for (final showName in favoriteShows) {
      final response = await http.get(
        Uri.parse('https://api.tvmaze.com/singlesearch/shows?q=$showName'),
      );

      if (response.statusCode == 200) {
        favoritesList.add(
          json.decode(response.body),
        );
      } else {
        throw Exception('Failed to load favorite show details');
      }
    }
    return favoritesList;
  }

  void _toggleSorting() {
    setState(() {
      _isSorted = !_isSorted;
    });
  }

  List<dynamic>? currentFavorites;

  @override
  Widget build(BuildContext context) {
    final favoriteShows = ref.watch(favoriteShowsProvider(widget.userId));


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: _selectedPageIndex == 0
            ? _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(144, 255, 255, 255),
                      ),
                    ),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  )
                : const Text(
                    'TV APP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color.fromARGB(255, 255, 255, 255),
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Color.fromARGB(255, 54, 48, 48),
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  )
            : const Text(
                'Favorites',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
        actions: <Widget>[
          IconButton(
            icon: _selectedPageIndex == 0
                ? Icon(_isSearching ? Icons.close : Icons.search)
                : Icon(_isSorted ? Icons.sort : Icons.sort_by_alpha),
            color: _selectedPageIndex == 0 ? Colors.black : Colors.white,
            onPressed: () {
              if (_selectedPageIndex == 0) {
                if (_isSearching) {
                  _stopSearch();
                } else {
                  _startSearch();
                }
              } else {
                _toggleSorting();
              }
            },
          ),
        ],
      ),
      body: _selectedPageIndex == 0
          ? _isSearching
              ? FutureBuilder<List<dynamic>>(
                  future: _performSearch(_searchQuery),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData &&
                        (snapshot.data as List).isEmpty) {
                      return Center(
                        child: Text(
                          'No results',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var show = snapshot.data![index]['show'];
                          var imageUrl = show['image'] != null
                              ? show['image']['medium']
                              : 'https://via.placeholder.com/150';

                          return ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: imageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            title: Text(
                              show['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ShowDetailsScreen(showName: show['id'], userId: widget.userId),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('No results',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      );
                    }
                  },
                )
              : ListShows(userId: widget.userId,)
          : FutureBuilder<List<dynamic>>(
              future: _fetchFavorites(favoriteShows),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData &&
                    (snapshot.data as List).isEmpty) {
                  return Center(
                    child: Text('No favorite shows',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  );
                } else if (snapshot.hasData) {
                  if (_isSorted) {
                    currentFavorites = List.from(snapshot.data!);
                    currentFavorites!
                        .sort((a, b) => a['name'].compareTo(b['name']));
                  } else {
                    currentFavorites = snapshot.data;
                  }
                  return ListView.builder(
                    itemCount: currentFavorites!.length,
                    itemBuilder: (context, index) {
                      var show = currentFavorites![index];
                      var imageUrl = show['image'] != null
                          ? show['image']['medium']
                          : 'https://via.placeholder.com/150';
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16.0),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          ref
                              .read(
                                  favoriteShowsProvider(widget.userId).notifier)
                              .toggleFavorite(show['name']);
                        },
                        child: ListTile(
                          leading: Image.network(imageUrl),
                          title: Text(
                            show['name'],
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShowDetailsScreen(showName: show['id'], userId: widget.userId,),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'No favorite shows',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  );
                }
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectedPageIndex,
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        selectedItemColor: const Color.fromARGB(255, 212, 2, 2),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_filter_sharp),
            label: 'Shows',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
