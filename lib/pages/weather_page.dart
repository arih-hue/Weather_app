import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';

import '../models/weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('b825ab38a7f7e4834d33a6c323d54867');
  Weather? _weather;    //weather object

  //fetch weather
  _fetchWeather() async     // method to fetch the weather
      {
    String cityName = await _weatherService.getCurrentCity();
    // get weather for city
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
        return Colors.blueGrey[800]!; // Moody grey for overcast
      case 'snow':
        return Colors.lightBlue[300]!; // Icy blue for snow
      case 'rain':
      case 'drizzle':
      case 'shower rain':
      case 'thunderstorm':
        return Colors.indigo[900]!; // Deep dark blue for storms/rain
      case 'clear':
        return Colors.lightBlue[200]!; // Bright blue for clear skies
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
      backgroundColor: _getWeatherColor(_weather?.mainCondition),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 32,
                      color: Colors.white70,
                  ),
                  SizedBox(width: 10),
                  Text(_weather?.cityName ?? 'Loading City...',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white70,
                      )
                  ),
                ],
              ),
            ),
               //city name
            SizedBox(height: 200),


            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),


            SizedBox(height: 25,),
            Text('${_weather?.temperature.round() ?? ''}°C',
                style: TextStyle(
                  fontSize: 75,
                  color: Colors.white,
                )
            ),  //temperature of the city

            Text(_weather?.mainCondition?? "",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white70,
                )
            ),
            SizedBox(height: 100,)
        ],),
      )
    );
  }
}
