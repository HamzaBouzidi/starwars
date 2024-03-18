import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



String formatDateString(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  return '${dateTime.year}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}';
}

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jems Star wars'),
        centerTitle: true,
      ),
      body: ApiDataList(),
    );
  }
}

class ApiDataList extends StatelessWidget {
  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('https://swapi.dev/api/films/'));
    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the decoded map directly
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final List<dynamic> filmsData = snapshot.data!['results']; 
          final int totalMovies = filmsData.length;
          return Column(
            children: [
              Container(
                color: Colors.black,
                width: double.infinity,
                height: 220,
                child: Column(
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Center(
                        child: Image.asset("assets/splash.png"),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(top: 8.0),
                          child: 
                          Text(
                            "Total movies: $totalMovies",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filmsData.length,
                  itemBuilder: (context, index) {
                    final Map<String, dynamic> data = filmsData[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilmDetailsScreen(data: data),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.black,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 3.5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: 
                                Text(
                                  data['title'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                               ),
                                Column(
                                  children: [
                                    const Text(
                                      "Release Date",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      data['release_date'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    const Text(
                                      "Director",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      data['director'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    const SizedBox(width: 8),
                                     Text(
                                      "Producer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      data['producer'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                           // SizedBox(height: 20,),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0), 
                                    child: Text(
                                      '${data['opening_crawl']}'.replaceAll('\n', ''),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class FilmDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const FilmDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
      ),
      body: Column(
        children: [
           Container(
                color: Colors.black,
                width: double.infinity,
                height: 200,
                child: Container(
                        color: Colors.black,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 3.5),
                        child: Column(
                          children: [
                            const SizedBox(height: 70,),
                            Row(
                              
                              children: [
                                Padding(padding: const EdgeInsets.all(8.0),
                                child: 
                                Text(
                                  "${data['title']}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 33,
                                  ),
                                ),
                                )
                                
                              ],
                            ),
                            const SizedBox(height: 25,),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    const Text(
                                      "Release Date",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      data['release_date'],
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                      
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    const Text(
                                      "Director",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${data['director']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis, 
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    const SizedBox(width: 8),
                                    const Text(
                                      "Producer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis, 
                                    ),
                                    Text(
                                      "${data['producer']}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis, 
                                    ),
                                  ],
                                ),
                                
                              ],
                            ),
                            
                          ],
                        ),
                      ),
              ),
              Container(
                width: double.infinity,
                padding:  EdgeInsets.all(8.0),
                child:  Column(
                  
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                          Text(
                               "Opening craw",
                                style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                ),
                                ),
                      ],
                    ),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                        Expanded(
                          child: 
                            
                              Text(
                                   "${data['opening_crawl']}".replaceAll('\n', ''),
                                    style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    ),
                                    maxLines: 8,
                                    overflow: TextOverflow.ellipsis, 
                                    ),
                                    
  
                        ),
                      ],

                    ),
                    Row(
                      
                      children: [
                        
                        Column(
                              children: [
                                    SizedBox(width: 8,height: 10,),
                                    Text(
                                      "Created",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      formatDateString("${data['created']}"),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),

                                Column(
                              children: [
                                    
                                    SizedBox(width: 8,height: 10,),
                                    Text(
                                      "Edited",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold 
                                      ),
                                    ),
                                    Text(
                                      //"${data['edited']}",
                                      formatDateString(data['edited']),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),

                      ],
                    )
                  ],
                ),


              )
        ]
        

      )
    );
  }
}
