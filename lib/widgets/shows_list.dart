import 'package:tv_app/screens/show_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ListShows extends StatefulWidget {
  const ListShows({super.key, required this.userId});
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return _ListShowsState();
  }
}

class _ListShowsState extends State<ListShows> {
  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'https://api.tvmaze.com/shows';
    int currentPage = 0;

    Future<List<dynamic>> fetchShows(int page) async {
      var response = await http.get(Uri.parse('$baseUrl?page=$page'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load shows');
      }
    }

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: fetchShows(currentPage),
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
                          show['image'] != null ? show['image']['medium'] : '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          show['name'],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        onTap: () {
                          {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShowDetailsScreen(showName: show['id'], userId: widget.userId),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error al cargar los datos',
                    style: Theme.of(context).textTheme.bodyLarge,
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
