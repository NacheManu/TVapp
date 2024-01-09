import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_app/models/show.dart';
import 'package:tv_app/provider/favorite_provider.dart';
import 'package:tv_app/widgets/episode_list.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class ShowDetailsScreen extends ConsumerStatefulWidget {
  const ShowDetailsScreen(
      {super.key, required this.showName, required this.userId});

  final String userId;
  final int showName;

  @override
  ConsumerState<ShowDetailsScreen> createState() {
    return _ShowDetailsScreenState();
  }
}

class _ShowDetailsScreenState extends ConsumerState<ShowDetailsScreen> {
  ShowDetails? _showDetails;
  List<Episode>? _episodes;
  String _showTitle = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final showDetailsResponse = await http.get(Uri.parse(
          'https://api.tvmaze.com/shows/${widget.showName}?embed=cast'));

      final episodesResponse = await http.get(Uri.parse(
          'https://api.tvmaze.com/shows/${widget.showName}/episodes'));

      if (showDetailsResponse.statusCode == 200 &&
          episodesResponse.statusCode == 200) {
        setState(() {
          _showDetails =
              ShowDetails.fromJson(json.decode(showDetailsResponse.body));
          _episodes = (json.decode(episodesResponse.body) as List<dynamic>)
              .map((episodeJson) => Episode.fromJson(episodeJson))
              .toList();
          _showTitle = _showDetails!.name;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load Show');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteShows = ref.watch(favoriteShowsProvider(widget.userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(_showDetails?.name ?? ''),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/Home/${widget.userId}');
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _showDetails!.image != null
                      ? Image.network(
                          _showDetails!.image!.original,
                          width: 500,
                        )
                      : const Placeholder(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              _showDetails!.name,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              favoriteShows.contains(_showTitle)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favoriteShows.contains(_showTitle)
                                  ? const Color.fromARGB(255, 219, 88, 94)
                                  : const Color.fromARGB(255, 255, 255, 255),
                            ),
                            iconSize: 40,
                            onPressed: () {
                              ref
                                  .read(favoriteShowsProvider(widget.userId)
                                      .notifier)
                                  .toggleFavorite(_showTitle);
                            },
                          ),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Genres:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: (_showDetails!.genres)
                                  ?.map<Widget>(
                                    (genre) => Chip(
                                      label: Text(genre),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  )
                                  .toList() ??
                              [],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Summary:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _showDetails!.summary != null
                              ? _showDetails!.summary!
                                  .replaceAll(RegExp(r'<[^>]*>'), '')
                              : 'Not available',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Schedule: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          _showDetails!.schedule != null && _showDetails!.schedule!.days!.isNotEmpty
                              ? '${_showDetails!.schedule!.days} at ${_showDetails!.schedule!.time}'
                              : 'Not available',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  ListViewBuilderEpisodes(
                    episodes: _episodes!,
                  ),
                ],
              ),
            ),
    );
  }
}
