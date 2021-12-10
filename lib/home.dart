import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/water_channel.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:async';

class WaterChannelView extends StatefulWidget {
  const WaterChannelView({Key? key}) : super(key: key);

  @override
  _WaterChannelViewState createState() => _WaterChannelViewState();
}

class _WaterChannelViewState extends State<WaterChannelView> {
  List<WaterChannel> waterChannels = [
    WaterChannel(1, "Channel 1"),
    WaterChannel(2, "Channel 2"),
    WaterChannel(3, "Channel 3"),
    WaterChannel(4, "Channel 4"),
    WaterChannel(5, "Channel 5"),
    WaterChannel(6, "Channel 6"),
    WaterChannel(7, "Channel 7"),
    WaterChannel(8, "Channel 8"),
  ];

  late Timer _timer;
  _WaterChannelViewState() {
    _timer = Timer.periodic(const Duration(milliseconds: 60000),
        (Timer _timer) async {
      for (var waterChannel in waterChannels) {
        if (waterChannel.on &&
            waterChannel.duration > 0 &&
            waterChannel.timeLeft > 0) {
          --waterChannel.timeLeft;
        }
        if (waterChannel.timeLeft <= 0 && waterChannel.on) {
          waterChannel.on = false;
          waterChannel.timeLeft = waterChannel.duration;
          await waterChannel.turnChannelOnOff();
        }
      }
      setState(() {
        for (var waterChannel in waterChannels) {
          if (waterChannel.timeLeft <= 0) {
            waterChannel.on = false;
            waterChannel.timeLeft = waterChannel.duration;
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: const Text('Water Channels'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
          itemCount: waterChannels.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
              child: Card(
                child: ListTile(
                  title: Text(waterChannels[index].name),
                  leading: const Image(
                    image: AssetImage('water_drop.png'),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Expanded(
                        child: SfSlider(
                          min: 0,
                          max: 100,
                          value: waterChannels[index].duration,
                          showTicks: true,
                          showLabels: true,
                          enableTooltip: true,
                          minorTicksPerInterval: 1,
                          onChanged: (dynamic value) {
                            setState(() {
                              waterChannels[index].duration = value.toInt();
                              waterChannels[index].timeLeft = value.toInt();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          child: SfRadialGauge(axes: <RadialAxis>[
                            RadialAxis(
                                minimum: 0,
                                maximum: waterChannels[index].duration + 0.1,
                                showLabels: false,
                                showTicks: false,
                                axisLineStyle: const AxisLineStyle(
                                  thickness: 0.2,
                                  cornerStyle: CornerStyle.bothCurve,
                                  color: Color.fromARGB(30, 0, 169, 181),
                                  thicknessUnit: GaugeSizeUnit.factor,
                                ),
                                pointers: <GaugePointer>[
                                  RangePointer(
                                      value: waterChannels[index]
                                          .timeLeft
                                          .toDouble(),
                                      cornerStyle: CornerStyle.bothCurve,
                                      width: 0.2,
                                      sizeUnit: GaugeSizeUnit.factor,
                                      enableAnimation: true,
                                      animationDuration: 100,
                                      animationType: AnimationType.linear)
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    positionFactor: 0.1,
                                    angle: 90,
                                    widget: Text(
                                      waterChannels[index]
                                              .timeLeft
                                              .toStringAsFixed(0) +
                                          ' / ' +
                                          waterChannels[index]
                                              .duration
                                              .toStringAsFixed(0) +
                                          '\nmin',
                                      style: const TextStyle(fontSize: 11),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ]),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  trailing: CupertinoSwitch(
                    value: waterChannels[index].on,
                    onChanged: (bool value) async {
                      setState(() {
                        waterChannels[index].on = value;
                      });
                      await waterChannels[index].turnChannelOnOff();
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}
