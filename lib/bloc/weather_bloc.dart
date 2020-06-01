import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fake_weather/weather_repository.dart';

import './bloc.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository);

  @override
  WeatherState get initialState => WeatherInitial();

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    yield WeatherLoading();

    if (event is GetWeather) {
      try {
        final weather = await weatherRepository.fetchWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError('Failed to fetch Weather data. Blah blah');
      }
    } else if (event is GetWeatherDetail) {
      try {
        final weather =
            await weatherRepository.fetchDetailedWeather(event.cityName);
        yield WeatherLoaded(weather);
      } on NetworkError {
        yield WeatherError('Failed to fetch Weather data. Blah blah');
      }
    }
  }
}
