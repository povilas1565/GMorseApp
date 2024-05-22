import 'package:flutter/material.dart';
import 'package:morse_code_app/model/morseCode.dart';
import 'package:morse_code_app/model/morse_code_dic.dart';

class CodeBookPage extends StatefulWidget {
  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const CodeBookPage());
  const CodeBookPage({Key? key}) : super(key: key);

  @override
  State<CodeBookPage> createState() => _CodeBookPageState();
}

class _CodeBookPageState extends State<CodeBookPage> {
  List<Morsecode> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CODE BOOK",
          style: TextStyle(fontFamily: "CarterOne", fontSize: 40),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: true,
      ),
      backgroundColor: const Color.fromARGB(255, 246, 255, 187),
      body: ListView.builder(
          itemCount: morseCodeDic.length,
          itemBuilder: (BuildContext context, int index) {
            morseCodeDic.forEach((key, value) {
              list.add(Morsecode(alphabet: key, morseCode: value));
            });
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 50.0),
              child: ListTile(
                  trailing: Text(
                    list[index].morseCode.toString(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    list[index].alphabet.toString().toUpperCase(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  )),
            );
          }),
    );
  }
}
