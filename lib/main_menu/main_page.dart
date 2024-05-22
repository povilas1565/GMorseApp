import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainPage extends StatefulWidget {
  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const MainPage());
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Do you want to exit the app?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => SystemNavigator.pop(),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            )) ??
            false;
      },
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                  child: const Center(
                      child: Text(
                    'Audio Morse Code',
                    style: TextStyle(
                      fontFamily: 'CarterOne',
                      fontSize: 40,
                    ),
                  ))),
              Column(
                children: [
                  // Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 7,
                        width: MediaQuery.of(context).size.width * 2 / 7,
                        margin: const EdgeInsets.all(10.0),
                        child: const Icon(
                          Icons.mail,
                          size: 80,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 10,
                        width: MediaQuery.of(context).size.width * 3 / 5,
                        margin: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/encode');
                          },
                          child: const Text(
                            "Encode",
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: const Size(80, 35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0))),
                        ),
                      ),
                    ],
                  ),
                  // Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 7,
                        width: MediaQuery.of(context).size.width * 2 / 7,
                        margin: const EdgeInsets.all(10.0),
                        child: const Icon(
                          Icons.how_to_vote,
                          size: 80,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 10,
                        width: MediaQuery.of(context).size.width * 3 / 5,
                        margin: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/decode');
                          },
                          child: const Text(
                            "Decode",
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: const Size(80, 35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0))),
                        ),
                      ),
                    ],
                  ),
                  // Row 3
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 7,
                        width: MediaQuery.of(context).size.width * 2 / 7,
                        margin: const EdgeInsets.all(10.0),
                        child: const Icon(
                          Icons.auto_stories,
                          size: 80,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 10,
                        width: MediaQuery.of(context).size.width * 3 / 5,
                        margin: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/code_book');
                          },
                          child: const Text(
                            "Code Book",
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: const Size(80, 35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0))),
                        ),
                      ),
                    ],
                  ),
                  // Row 4
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 7,
                        width: MediaQuery.of(context).size.width * 2 / 7,
                        margin: const EdgeInsets.all(10.0),
                        child: const Icon(
                          Icons.settings,
                          size: 80,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 1 / 10,
                        width: MediaQuery.of(context).size.width * 3 / 5,
                        margin: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                          child: const Text(
                            "Settings",
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              fixedSize: const Size(80, 35),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0))),
                        ),
                      ),
                    ],
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
