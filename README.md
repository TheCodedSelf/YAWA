# YAWA — Yet _Another_ Weather App

## Setup

This app uses the [OpenWeather](https://openweathermap.org) API for weather data. To run the app, you'll need to generate an API key and add it to a `Secrets.xcconfig` file. 

Firstly, create a file named `Secrets.xcconfig` in the project directory.

```
touch Secrets.xcconfig
```

Then, add your OpenWeather API key to `Secrets.xcconfig` like this:

```
API_KEY = 1234567890abcdef
```

