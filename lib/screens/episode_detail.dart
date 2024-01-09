import 'package:tv_app/models/show.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EpisodeDetail extends StatefulWidget {
  const EpisodeDetail({super.key, required this.episodeId});

  final int episodeId;

  @override
  State<StatefulWidget> createState() {
    return _EpisodeDetailState();
  }
}

class _EpisodeDetailState extends State<EpisodeDetail> {
  late EpisodeDetails _episodeDetails = EpisodeDetails(
    id: 0,
    name: '',
    season: 0,
    number: 0,
    summary: '',
    image: null,
  );

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEpisodeDetails();
  }

  Future<void> _fetchEpisodeDetails() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.tvmaze.com/episodes/${widget.episodeId}'));
      if (response.statusCode == 200) {
        setState(() {
          _episodeDetails = EpisodeDetails.fromJson(json.decode(response.body));
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load episode details');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_episodeDetails.name),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_episodeDetails.image != null)
                    Image.network(
                      _episodeDetails.image!.original,
                      width: 500,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Image not available');
                      },
                    ),
                  const SizedBox(height: 15),
                  Text(
                    'Episode: ${_episodeDetails.name}',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Season: ${_episodeDetails.season} Number: ${_episodeDetails.number}',
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Summary: ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    _episodeDetails.summary != null &&
                            _episodeDetails.summary!.isNotEmpty
                        ? '${_episodeDetails.summary?.replaceAll(
                            RegExp(r'<[^>]*>'),
                            '',
                          )}'
                        : 'No summary Available',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
    );
  }
}
