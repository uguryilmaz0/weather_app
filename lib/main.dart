import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final List<String> cities = ['İstanbul', 'Ankara', 'İzmir', 'Paris', 'London'];
  final String apiKey = 'cb46333a08mshca7d49bf3fab1cfp12883fjsn61802567e3c3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.blueAccent,
        title: const Text('Weather App'),
      ),
      body: FutureBuilder(
        future: fetchWeatherData(),
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
            return ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final weatherData = snapshot.data![index];
                return ListTile(
                  title: Text(cities[index]),
                  subtitle: Text('Temperature: ${weatherData['current']['temp_c']}°C'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchWeatherData() async {
    List<Map<String, dynamic>> weatherDataList = [];

    for (final city in cities) {
      final response = await http.get(
        Uri.parse('https://weatherapi-com.p.rapidapi.com/current.json?q=$city'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> weatherData = json.decode(response.body);
        weatherDataList.add(weatherData);
      } else {
        throw Exception('Failed to load weather data for $city');
      }
    }

    return weatherDataList;
  }
}
