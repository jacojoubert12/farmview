import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart';

class WaterChannel {
  int channelNumber;
  String name;
  List onTimesDurations = [];
  bool on = false;
  int duration = 0;
  int timeLeft = 0;

  WaterChannel(this.channelNumber, this.name);

  void addOnTime(TimeOfDay newOnTime, double duration) {
    var timeDuration = {'time': newOnTime, 'duration': duration};
    onTimesDurations.add(timeDuration);
  }

  void removeOnTime(int index) {
    onTimesDurations.removeAt(index);
  }

  void setOn(bool on, int duration) {
    this.on = on;
    this.duration = duration;
  }

  void updateDuration(int duration) {
    this.duration = duration;
    timeLeft = duration;
  }

  Future<String> turnChannelOnOff() async {
    int isOn;
    if (on) {
      isOn = 1;
    } else {
      isOn = 0;
    }
    final Map<String, String> queryParameters = {
      'channel': channelNumber.toString(),
      'duration': timeLeft.toString(),
      'on': isOn.toString(),
    };
    final uri = Uri.http("68.183.44.212:5000", "/", queryParameters);
    var response = await http.get(uri, headers: {"Accept": "application/json"});
    //Map data = json.decode(response.body);
    // String data = response.body;
    //print(data[1]["title"]);
    print(response.body);

    return "Success!";
  }

  // Future<void> getDuration() async {
  //   try {
  //     // make the request
  //     Response response =
  //         await get('http://worldtimeapi.org/api/timezone/$url');
  //     Map data = jsonDecode(response.body);

  //     response = await get('http://68.183.44.212:5000/');
  //     Map data2 = jsonDecode(response.data);
  //     print(data2);

  //     // get properties from json
  //     String datetime = data['datetime'];
  //     String offset = data['utc_offset'].substring(1, 3);

  //     // create DateTime object
  //     DateTime now = DateTime.parse(datetime);
  //     now = now.add(Duration(hours: int.parse(offset)));

  //     // set the time property
  //     // isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
  //     // time = DateFormat.jm().format(now);
  //   } catch (e) {
  //     print(e);
  //     time = 'could not get time';
  //   }
  // }
}
