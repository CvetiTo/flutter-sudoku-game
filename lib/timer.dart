//import 'dart:async';
//
//import 'package:flutter/material.dart';
//
//class CounterScreen extends StatefulWidget {
//  const CounterScreen({Key? key}) : super(key: key);
//
//  @override
//  _CounterScreenState createState() => _CounterScreenState();
//}
//
//class _CounterScreenState extends State<CounterScreen> {
//  /// declare a cound variable with initial value
//  String time = '';
//
//  @override
//  void initState() {
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//      DateTime timenow = DateTime.now();
//      time = "${timenow.hour}:";
//      if (timenow.minute > 9) {
//        time = "$time${timenow.minute}:";
//      } else {
//        time = "${time}0${timenow.minute}:";
//      }
//
//      if (timenow.second > 9) {
//        time = time + timenow.second.toString();
//      } else {
//        time = "${time}0${timenow.second}";
//      }
//      setState(() {});
//    });
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//        child: Text(
//      time,
//      style: const TextStyle(
//        fontSize: 20,
//      ),
//    ));
//  }
//}
//

import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountUpTimerPage extends StatefulWidget {
  const CountUpTimerPage({super.key});

  @override
  _State createState() => _State();
}

class _State extends State<CountUpTimerPage> {
  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        /// Display stop watch time
        StreamBuilder<int>(
          stream: _stopWatchTimer.rawTime,
          initialData: _stopWatchTimer.rawTime.value,
          builder: (context, snap) {
            final value = snap.data!;
            final displayTime =
                StopWatchTimer.getDisplayTime(value, hours: _isHours);
            return Column(
              children: <Widget>[
                const Divider(
                  height: 8,
                  color: Colors.white,
                ),
                SizedBox(
                  child: Text(
                    displayTime,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        ),

        /// Lap time.
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.5),
          child: SizedBox(
            //height: 100,
            child: StreamBuilder<List<StopWatchRecord>>(
              stream: _stopWatchTimer.records,
              initialData: _stopWatchTimer.records.value,
              builder: (context, snap) {
                final value = snap.data!;
                if (value.isEmpty) {
                  return const SizedBox.shrink();
                }
                Future.delayed(const Duration(milliseconds: 100), () {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut);
                });
                //print('Listen records. $value');
                return ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    final data = value[index];
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(1),
                          child: Text(
                            '${index + 1} ${data.displayTime}',
                            style: const TextStyle(
                                fontSize: 8,
                                backgroundColor: Colors.transparent,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount: value.length,
                );
              },
            ),
          ),
        ),

        /// Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: _stopWatchTimer.onStartTimer,
                child: const Icon(
                  Icons.play_circle,
                  size: 20,
                  color: Colors.green,
                )),
            InkWell(
              onTap: _stopWatchTimer.onStopTimer,
              child: const Icon(
                Icons.pause_circle,
                size: 20,
                color: Colors.green,
              ),
            ),
            InkWell(
              onTap: _stopWatchTimer.onResetTimer,
              child: const Icon(
                Icons.timer_off,
                size: 20,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.child,
    this.color,
    //this.disableColor,
    //this.elevation,
    //this.side = BorderSide.none,
    this.onTap,
    super.key,
  });

  final Widget child;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
      ),
      onPressed: onTap,
      child: child,
    );
  }
}
