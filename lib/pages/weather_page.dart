import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';
import 'dart:ui';

import '../models/weather_model.dart';

class GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const GlassBox({
    super.key,
    required this.child,

    this.padding = const EdgeInsets.all(30),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('b825ab38a7f7e4834d33a6c323d54867');
  Weather? _weather;

  _fetchWeather() async
      {
    String cityName = await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch(mainCondition.toLowerCase()){
      case 'clouds':
        return 'assets/cloudy.json';
      case 'mist':
        return 'assets/mist.json';
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/partly cloudy.json';
      case 'snow':
        return 'assets/snow.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/partly shower.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  Color _getWeatherColor(String? mainCondition){
    if(mainCondition == null) return Colors.grey[900]!;

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return Colors.blueGrey[800]!;
      case 'snow':
        return Colors.lightBlue[300]!;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return Colors.indigo[900]!;
      case 'clear':
        return Colors.lightBlue[200]!;
      default:
        return Colors.grey[800]!;
    }
  }

  @override
  void initState(){
    super.initState();
    _fetchWeather();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: openSearchBox,
            icon: Icon(
                Icons.search_outlined,
                color: Colors.white,
                size: 30
            ),
          ),
          title: Text(
            _weather?.cityName ?? 'Loading City...',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isCelsius=!isCelsius;
                });
              },
              icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 30
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      backgroundColor: _getWeatherColor(_weather?.mainCondition),
      body: Center(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [


            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),


            SizedBox(height: 0,),
            Center(
              child: Text('${_weather?.temperature.round() ?? ''}°${isCelsius ? 'C' : 'F'}',
                  style: TextStyle(
                    fontSize: 75,
                    color: Colors.white,
                  )
              ),
            ),

            Center(
              child: Text(_weather?.mainCondition?? "",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white70,
                  )
              ),
            ),

            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GlassBox(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                  child: Column(
                    children: [
                      const Icon(Icons.water_drop_outlined, color: Colors.white, size: 50),
                      const SizedBox(height: 5),
                      Text(
                        '${_weather?.humidity.toString() ?? ''} %',
                        style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const Text("Humidity", style: TextStyle(color: Colors.white70, fontSize: 25)),
                    ],
                  ),
                ),
                GlassBox(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                  child: Column(
                    children: [
                      const Icon(Icons.air, color: Colors.white, size: 50),
                      const SizedBox(height: 5),
                      Text(
                        '${_weather?.windSpeed.toString()  ?? ''} m/s',
                        style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const Text("Wind", style: TextStyle(color: Colors.white70, fontSize: 25)),
                    ],
                  ),
                ),
              ],
            ),

        ],),
      )
    );
  }
}
