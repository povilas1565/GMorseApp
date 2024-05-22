import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const SettingsPage());
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double _currentSpeedValue = 7;
  double _currentToneValue = 500;

  /* Future<void> savePreferences() async {
    final SharedPreferences prefs = await _prefs;
  }*/
  Future<void> getSettingsVariable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.containsKey("frequency")
        ? _currentToneValue = prefs.getInt("frequency")!.toDouble()
        : _currentToneValue = 500;

    prefs.containsKey("speed")
        ? _currentSpeedValue = prefs.getInt("speed")!.toDouble()
        : _currentSpeedValue = 7;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSettingsVariable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: TextStyle(fontFamily: "CarterOne", fontSize: 40),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: const Color.fromARGB(255, 246, 255, 187),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Text(
              "SPEED = " + _currentSpeedValue.toStringAsFixed(0) + "WPM",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Slider(
            value: _currentSpeedValue,
            max: 50,
            min: 0,
            divisions: 50,
            activeColor: Colors.amber,
            inactiveColor: Colors.grey,
            onChanged: (double value) {
              setState(() {
                if (value == 0) {
                  value = 1;
                }
                _currentSpeedValue = value;
                //print(_currentSpeedValue.toInt());
              });
            },
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Text(
              "FREQUENCY = " + _currentToneValue.toStringAsFixed(0) + "Hz",
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Slider(
            value: _currentToneValue,
            max: 1000,
            min: 100,
            divisions: 900,
            activeColor: Colors.amber,
            inactiveColor: Colors.grey,
            onChanged: (double value) {
              setState(() {
                _currentToneValue = value;
                //print(_currentToneValue.toInt());
              });
            },
          ),
          ElevatedButton(
              onPressed: (() async {
                AlertDialog alert;
                try {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('frequency', _currentToneValue.toInt());
                  prefs.setInt('speed', _currentSpeedValue.toInt());

                  alert = AlertDialog(
                    title: const Text("Success!"),
                    content: const Text("Settings is updated."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Okay")),
                    ],
                  );
                } catch (e) {
                  alert = AlertDialog(
                    title: const Text("Error!"),
                    content: const Text(
                        "Unable to update Settings, please try again."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Okay")),
                    ],
                  );
                }
                setState(() {});
                showDialog(
                    context: context,
                    builder: (BuildContext cotext) {
                      return alert;
                    });
              }),
              style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                  fixedSize: const Size(250, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0))),
              child: const Text(
                "CHANGE",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
