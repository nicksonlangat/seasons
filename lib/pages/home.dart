import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seasons/models/weather.dart';
import 'package:seasons/services/weather_service.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final typedCity = TextEditingController();
  String cityName = "Kericho";
  List weatherlist = [];
  bool isLoaded = false;
  String timeOfDay = "";

  void getWeatherInfo() async {
    final response = await http.get(
      Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=3285d359b9f844e5a43165144243103&q=$cityName&days=1&aqi=no&alerts=no'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body));
      setState(() {
        weatherlist.add(jsonDecode(response.body));
        isLoaded = true;
      });
    } else {
      throw Exception('Failed to fetch categories.');
    }
  }

  @override
  void initState() {
    super.initState();
    getWeatherInfo();
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoaded) {
    //   print(weatherlist[0]);
    // }
    print("xxj");
    timeOfDay = greeting();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1C3769),
              Color(0xff080E18),
            ],
          )),
          child: isLoaded && weatherlist.isNotEmpty
              ? ListView(children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cityName,
                              style: GoogleFonts.lato(
                                  fontSize: 24, color: const Color(0xffD8DDE2)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${weatherlist[0]['current']['condition']['text']}",
                              style: GoogleFonts.lato(
                                  fontSize: 14, color: const Color(0xffA7A7C0)),
                            ),
                            Row(
                              children: [
                                Text(
                                  "${weatherlist[0]['current']['temp_c']} °C",
                                  // °C
                                  style: GoogleFonts.lato(
                                      fontSize: 44,
                                      color: const Color(0xffD8DDE2)),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "H ${weatherlist[0]['forecast']['forecastday'][0]['day']['maxtemp_c']} °C",
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: const Color(0xffA7A7C0)),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "L ${weatherlist[0]['forecast']['forecastday'][0]['day']['mintemp_c']} °C",
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: const Color(0xffA7A7C0)),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        timeOfDay == "Evening"
                            ? SvgPicture.asset(
                                "assets/icons/moon.svg",
                                height: 70,
                              )
                            : SvgPicture.asset(
                                "assets/icons/sun.svg",
                                height: 70,
                              )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Divider(
                      color: Color(0xff21355A),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Forecast",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: const Color(0xffA7A7C0)),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 70,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  "Today",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: const Color(0xff16284D)),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 70,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff3C5382)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "3-Day",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: const Color(0xffA7A7C0)),
                                ),
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 70,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xff3C5382)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "7-Day",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: const Color(0xffA7A7C0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Morning",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: const Color(0xffA7A7C0)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/half-sun.svg"),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  " ${weatherlist[0]['forecast']['forecastday'][0]['hour'][8]['temp_c']} °C",
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: const Color(0xffD8DDE2)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Noon",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: const Color(0xffA7A7C0)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/sun.svg"),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${weatherlist[0]['forecast']['forecastday'][0]['hour'][12]['temp_c']} °C",
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: const Color(0xffD8DDE2)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Evening",
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: const Color(0xffA7A7C0)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/mn.svg"),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${weatherlist[0]['forecast']['forecastday'][0]['hour'][16]['temp_c']} °C",
                                  style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: const Color(0xffD8DDE2)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Divider(
                      color: Color(0xff21355A),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: GoogleFonts.lato(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: const Color(0xffA7A7C0)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/air.svg"),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Wind",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: const Color(0xffA7A7C0)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${weatherlist[0]['current']['wind_kph']} km/hr",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: const Color(0xffA7A7C0)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/cloudy.svg"),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Rain",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: const Color(0xffA7A7C0)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${weatherlist[0]['current']['precip_mm']} mm",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: const Color(0xffD8DDE2)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/pressure.svg"),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pressure",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: const Color(0xffA7A7C0)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${weatherlist[0]['current']['pressure_mb']} hpa",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: const Color(0xffD8DDE2)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset("assets/icons/humidity.svg"),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Humidity",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: const Color(0xffA7A7C0)),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${weatherlist[0]['current']['humidity']} %",
                                        style: GoogleFonts.lato(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: const Color(0xffD8DDE2)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      controller: typedCity,
                      onSubmitted: (content) {
                        print(typedCity.text);
                        setState(() {
                          cityName = typedCity.text;
                          weatherlist = [];
                          isLoaded = false;
                        });
                        getWeatherInfo();
                      },
                      style: GoogleFonts.lato(color: Colors.white),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xff21355A))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                const BorderSide(color: Color(0xff21355A))),
                        filled: true,
                        fillColor: const Color(0xff131E35),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            "assets/icons/srch.svg",
                            height: 10,
                          ),
                        ),
                        hintText: "Enter city name",
                        hintStyle:
                            GoogleFonts.lato(color: const Color(0xff474E62)),
                      ),
                    ),
                  )
                ])
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xff474E62),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("Fetching weather for $cityName",
                        style: GoogleFonts.lato(
                          color: const Color(0xff474E62),
                        ))
                  ],
                )),
    );
  }
}
