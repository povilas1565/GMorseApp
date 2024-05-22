import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:morse_code_app/decode/decode_viewmodel.dart';
import 'package:morse_code_app/model/decode.dart';
import 'package:just_audio/just_audio.dart';

import '../model/audio_morse.dart';

class DecodePage extends StatefulWidget {
  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const DecodePage());
  const DecodePage({Key? key}) : super(key: key);

  @override
  State<DecodePage> createState() => _DecodePageState();
}

class _DecodePageState extends State<DecodePage> {
  final DecodeViewmodel viewmodel = DecodeViewmodel();
  final morseTextController = TextEditingController();
  Decode? decode;
  AudioMorse? audioMorse;
  bool haveAudio = false;
  String? fileTitle;
  String? path;

  late AudioPlayer player;
  late AudioPlayer player2;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player2 = AudioPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int maxline = 3;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DECODE",
          style: TextStyle(
            fontFamily: "CarterOne",
            fontSize: 40,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
              onPressed: () {
                AlertDialog alert = openRulesDialog(context);
                showDialog(
                    context: context,
                    builder: (BuildContext cotext) {
                      return alert;
                    });
              },
              icon: const Icon(
                Icons.question_mark,
                color: Colors.white,
              ))
        ],
        // leading: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      backgroundColor: const Color.fromARGB(255, 246, 255, 187),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Morse code Text Box
            Container(
              margin: const EdgeInsets.all(20.0),
              color: const Color.fromARGB(255, 131, 230, 204),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "MORSE CODE",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                          onPressed: (() async {
                            AlertDialog alert = const AlertDialog();
                            String morse;
                            if (decode?.processedMorse != null ||
                                decode?.processedMorse == "") {
                              morse = decode!.processedMorse.toString();

                              audioMorse =
                                  await viewmodel.playMorseSound(morse);

                              if (DecodeViewmodel.decodeError) {
                                alert = AlertDialog(
                                  title: const Text("Error!"),
                                  content: const Text(
                                      "Unable to play sound, please try again."),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Okay")),
                                  ],
                                );
                                showDialog(
                                    context: context,
                                    builder: (BuildContext cotext) {
                                      return alert;
                                    });
                              } else {
                                try {
                                  await player
                                      .setFilePath(audioMorse!.path.toString());
                                  player.play();
                                } catch (e) {
                                  alert = AlertDialog(
                                    title: const Text("Error!"),
                                    content: const Text(
                                        "Unable to play sound, please try again."),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Okay")),
                                    ],
                                  );
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext cotext) {
                                        return alert;
                                      });
                                }
                              }
                            } else {
                              AlertDialog alert = AlertDialog(
                                title: const Text("Error!"),
                                content: const Text(
                                    "Plaese make sure you have decode the text."),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Okay")),
                                ],
                              );

                              showDialog(
                                  context: context,
                                  builder: (BuildContext cotext) {
                                    return alert;
                                  });
                            }
                          }),
                          icon: const Icon(
                            Icons.surround_sound,
                            size: 30,
                            color: Colors.grey,
                          ))
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    height: maxline * 35,
                    child: Form(
                        child: TextField(
                      controller: morseTextController,
                      maxLines: maxline,
                      style: const TextStyle(fontSize: 30),
                      decoration: const InputDecoration(
                        hintText: "Please enter your text with '.' and '-'",
                        hintStyle: TextStyle(fontSize: 22),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                    )),
                  ),
                ],
              ),
            ),
            // Message Box
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(20.0),
              color: const Color.fromARGB(255, 144, 198, 241),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          "TEXT",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    height: maxline * 30,
                    child: (decode != null)
                        ? Text(
                            decode!.decodedMessage.toString(),
                            style: const TextStyle(fontSize: 22),
                            maxLines: maxline,
                          )
                        : Text(
                            (decode != null)
                                ? decode!.decodedMessage!
                                : "Text here",
                            style: const TextStyle(fontSize: 22),
                            maxLines: maxline,
                          ),
                  ),
                ],
              ),
            ),
            if (haveAudio) ...[
              Text(fileTitle.toString()),
              IconButton(
                  onPressed: () async {
                    if (path != null || path != "") {
                      await player2.setUrl(path.toString());
                      player2.play();
                    }
                  },
                  icon: const Icon(Icons.play_arrow))
            ],
            ElevatedButton.icon(
              onPressed: () async {
                var result;
                try {
                  result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    allowedExtensions: ['wav'],
                    type: FileType.custom,
                  );
                } catch (e) {
                  AlertDialog alert = AlertDialog(
                    title: const Text("Error!"),
                    content: const Text(
                        "Please allow the permission to select files."),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Okay")),
                    ],
                  );
                  showDialog(
                      context: context,
                      builder: (BuildContext cotext) {
                        return alert;
                      });
                }

                if (result == null) {
                  setState(() {
                    haveAudio = false;
                  });
                  return;
                }

                // Open single file
                final audio = result.files.first;
                haveAudio = true;
                path = audio.path;
                fileTitle = audio.name;

                decode = await viewmodel.decodeAudio(
                    audio.path.toString(), audio.name);
                setState(() {
                  if (decode != null && !DecodeViewmodel.decodeError) {
                    morseTextController.text = decode!.morseMessage!;
                  } else {
                    AlertDialog alert = AlertDialog(
                      title: const Text("Error!"),
                      content: const Text(
                          "Something error in decode Audio file, please try again."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Okay")),
                      ],
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext cotext) {
                          return alert;
                        });
                  }
                });
              },
              icon: const Icon(Icons.upload),
              label: const Text(
                "Upload Audio Files",
                style: TextStyle(fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.grey,
                  fixedSize: const Size(250, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                  onPressed: (() async {
                    String mMes = morseTextController.text;
                    String a = mMes.replaceAll(RegExp(r'\s{3,}'), ';');
                    // print(a);
                    String b = a.replaceAll(RegExp(r'\s'), '/');
                    // print(b);
                    decode = await viewmodel.getDecodeMes(mMes, b);

                    if (DecodeViewmodel.decodeError) {
                      AlertDialog alert = AlertDialog(
                        title: const Text("Error!"),
                        content: const Text(
                            "Something error with text, please try again."),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Okay")),
                        ],
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext cotext) {
                            return alert;
                          });
                    }
                    setState(() {});
                  }),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      fixedSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0))),
                  child: const Text(
                    "DECODE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  AlertDialog openRulesDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "RULES OF MORSE CODE",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: RichText(
          text: const TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 18),
              children: <InlineSpan>[
                WidgetSpan(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child:
                      Text("1. The duration of the dash is 3 times of dot.\n"),
                )),
                WidgetSpan(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                      "2. Each dot of dash is followed by the blank period which equals to the dot duration.\n"),
                )),
                WidgetSpan(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("3. Space between letters is 3 dots duration.\n"),
                )),
                WidgetSpan(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text("4. Space between words is 7 dots duration.\n"),
                )),
                WidgetSpan(
                    child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                      "5. The most frequently occurring letter has shorter expression than others. "),
                )),
                TextSpan(
                    text: "(E has only one dot)",
                    style: TextStyle(color: Colors.pinkAccent, fontSize: 18.0)),
              ]),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Done")),
      ],
    );
  }
}
