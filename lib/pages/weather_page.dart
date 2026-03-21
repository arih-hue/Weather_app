import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/services/weather_service.dart';
import 'dart:ui';
import 'dialog.dart';
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
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
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
  final _weatherService = WeatherService('b825ab38a7f7e4834d33a6c323d54867');
  Weather? _weather;
  final _searchController = TextEditingController();
  bool isCelsius = true;

  _fetchWeather([String? cityName]) async {
    String city = cityName ?? await _weatherService.getCurrentCity();
    try {
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  double getDisplayTemp() {
    double temperature = _weather?.temperature ?? 0;
    return isCelsius ? temperature : (temperature * 9 / 5) + 32;
  }

  void openSearchBox() {
    showDialog(
      context: context,
      builder: (context) => dialog(
        controller: _searchController,
        onSearch: () {
          _fetchWeather(_searchController.text);
          _searchController.clear();
          Navigator.pop(context);
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds': return 'assets/cloudy.json';
      case 'mist': return 'assets/mist.json';
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog': return 'assets/partly cloudy.json';
      case 'snow': return 'assets/snow.json';
      case 'rain': return 'assets/rain.json';
      case 'drizzle': return 'assets/partly shower.json';
      case 'thunderstorm': return 'assets/storm.json';
      default: return 'assets/sunny.json';
    }
  }

  String getWeatherBackground(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.png';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'fog': return 'assets/cloud.png';
      case 'snow': return 'assets/snow.png';
      case 'rain':
      case 'thunderstorm': return 'assets/rain.jpg';
      default: return 'assets/sunny.png';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: openSearchBox,
          icon: const Icon(Icons.search_outlined, color: Colors.white, size: 30),
        ),
        title: Text(
          _weather?.cityName ?? 'Loading...',
          style: const TextStyle(fontSize: 45, color: Colors.white, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => setState(() => isCelsius = !isCelsius),
            icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(getWeatherBackground(_weather?.mainCondition)),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(height: 100),
              SizedBox(
                height: 280,
                child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              ),
              SizedBox(height: 50),
              Center(
                child: Text(
                  '${getDisplayTemp().round()}°${isCelsius ? 'C' : 'F'}',
                  style: const TextStyle(fontSize: 85, color: Colors.white, fontWeight: FontWeight.w200),
                ),
              ),
              Center(
                child: Text(
                  _weather?.mainCondition?.toUpperCase() ?? "",
                  style: const TextStyle(fontSize: 18, color: Colors.white70, letterSpacing: 3),
                ),
              ),
              SizedBox(height: 20),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: GlassBox(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.water_drop_outlined, color: Colors.white, size: 50),
                          const SizedBox(height: 50),
                          Text('${_weather?.humidity ?? 0}%', style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                          const Text("Humidity", style: TextStyle(color: Colors.white70, fontSize: 23)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: GlassBox(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.air, color: Colors.white, size: 50),
                          const SizedBox(height: 50),
                          Text('${_weather?.windSpeed ?? 0} m/s', style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                          const Text("Wind", style: TextStyle(color: Colors.white70, fontSize: 23)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}