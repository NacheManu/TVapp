import 'package:flutter/material.dart';
import 'package:tv_app/screens/episode_detail.dart';

class ListViewBuilderEpisodes extends StatelessWidget {
 const ListViewBuilderEpisodes({super.key, required this.episodes});

  final List<dynamic> episodes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final currentEpisode = episodes[index];
        final currentSeason = currentEpisode['season'];
        final currentEpisodeNumber = currentEpisode['number'];
        String seasonText = '';

        if (index == 0 || currentSeason != episodes[index - 1]['season']) {
          seasonText = 'Season $currentSeason';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (seasonText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  seasonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ListTile(
              title: Text(
                currentEpisode['name'],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              subtitle: Text(
                'Episode $currentEpisodeNumber',
                style: const TextStyle(
                  color: Color.fromARGB(255, 194, 186, 186),
                  fontSize: 15,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EpisodeDetail(
                      episodeId: currentEpisode['id'],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}