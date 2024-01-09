import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tv_app/models/show.dart';


class ListShows extends StatefulWidget {
  const ListShows({super.key, required this.userId});
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return _ListShowsState();
  }
}

class _ListShowsState extends State<ListShows> {
  late Future<List<Show>> _showsFuture;

  @override
  void initState() {
    super.initState();
    _showsFuture = fetchShows(0);
  }

  Future<List<Show>> fetchShows(int page) async {
    final String baseUrl = 'https://api.tvmaze.com/shows';
    var response = await http.get(Uri.parse('$baseUrl?page=$page'));

    if (response.statusCode == 200) {
      List<dynamic> parsedJson = json.decode(response.body);
      List<Show> shows = parsedJson.map((json) => Show.fromJson(json)).toList();
      return shows;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Show>>(
            future: _showsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scrollbar(
                  thickness: 5.0,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var show = snapshot.data![index];
                      return ListTile(
                        leading: Image.network(
                          show.image != null ? show.image!.medium : '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          show.name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        onTap: () {
                          context.go('/Home/Show/${show.id}/${widget.userId}');
                        },
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar los datos',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )
      ],
    );
  }
}