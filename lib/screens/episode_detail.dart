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
  late Map<String, dynamic> _episodeDetails = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEpisodeDetails();
  }

  Future<void> _fetchEpisodeDetails() async {
    final response = await http
        .get(Uri.parse('https://api.tvmaze.com/episodes/${widget.episodeId}'));
    if (response.statusCode == 200) {
      setState(() {
        _episodeDetails = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load episode details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_episodeDetails['name'] ?? 'Episode Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_episodeDetails['image'] != null)
                    Image.network(
                      _episodeDetails['image']['original'],
                      width: 500,
                      errorBuilder: (context, error, stackTrace) {
                        return const Text('Image not available');
                      },
                    ),
                  const SizedBox(height: 15),
                  Text(
                    'Episode: ${_episodeDetails['name'] ?? 'Not available'}',
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Season: ${_episodeDetails['season'] ?? 'Not available'} Number: ${_episodeDetails['number'] ?? 'Not available'}',
                    style: const TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Summary: ',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    '${_episodeDetails['summary'] != null ? _episodeDetails['summary'].replaceAll(
                        RegExp(r'<[^>]*>'),
                        '',
                      ) : 'Not available'}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
    );
  }
}
