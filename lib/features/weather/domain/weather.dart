class Weather {
  const Weather({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.code,
  });

  final double temperature;
  final double humidity;
  final double windSpeed;
  final int code;
}
