import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:morse_code_app/encode/encode_viewmodel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../model/audio_morse.dart';
import '../model/encode.dart';

class EncodePage extends StatefulWidget {
  static Route<dynamic> route() =>
      MaterialPageRoute(builder: (_) => const EncodePage());
  const EncodePage({Key? key}) : super(key: key);

  @override
  State<EncodePage> createState() => _EncodePageState();
}

class _EncodePageState extends State<EncodePage> {
  final EncodeViewModel viewModel = EncodeViewModel();
  final textController = TextEditingController();
  Encode? encode;
  AudioMorse? audioMorse;
  late AudioPlayer player;

  late stt.SpeechToText _speech;
  bool isListening = false;

  static const int wordLimit = 30;
  int count = 0;
  bool validate = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    player = AudioPlayer();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int maxline = 3;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Encode",
          style: TextStyle(fontFamily: "CarterOne", fontSize: 40),
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
        //leading: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
      backgroundColor: const Color.fromARGB(255, 246, 255, 187),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            // Text Box
            Container(
              margin: const EdgeInsets.all(20.0),
              color: const Color.fromARGB(255, 131, 230, 204),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      "TEXT",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.0),
                    height: maxline * 30,
                    child: TextField(
                      controller: textController,
                      maxLines: maxline,
                      //inputFormatters: [],
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(fontSize: 22),
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 22),
                        hintText: "Please enter your text",
                        errorText: _errorText,
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        suffixIcon: GestureDetector(
                          child: AvatarGlow(
                            endRadius: 30.0,
                            animate: isListening,
                            glowColor: Colors.redAccent,
                            duration: const Duration(milliseconds: 2000),
                            repeatPauseDuration:
                                const Duration(milliseconds: 100),
                            repeat: true,
                            child: Icon(
                                isListening ? Icons.mic : Icons.mic_none,
                                color: isListening ? Colors.red : Colors.grey),
                          ),
                          onLongPress: () {
                            setState(() {
                              listen();
                            });
                          },
                          onLongPressUp: () {
                            setState(() {
                              isListening = false;
                            });
                            _speech.stop();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Morse code Box
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(20.0),
              color: const Color.fromARGB(255, 144, 198, 241),
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
                            if (encode?.encodedMessage != null ||
                                encode?.encodedMessage == "") {
                              morse = encode!.encodedMessage.toString();

                              audioMorse =
                                  await viewModel.playMorseSound(morse);

                              if (EncodeViewModel.encodeError) {
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
                                }
                              }
                            } else {
                              alert = AlertDialog(
                                title: const Text("Error!"),
                                content: const Text(
                                    "Plaese make sure you have encode the text."),
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
                      height: (encode != null) ? null : maxline * 30,
                      child: (encode != null)
                          ? Text(
                              encode!.changedMessage.toString(),
                              style: const TextStyle(fontSize: 30),
                              //maxLines: maxline,
                            )
                          : const Text(
                              "Morse code here",
                              style: TextStyle(fontSize: 22),
                              maxLines: maxline,
                            )),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: !validate
                    ? (() async {
                        encode =
                            await viewModel.getEncodedMes(textController.text);
                        if (EncodeViewModel.encodeError) {
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
                      })
                    : null,
                style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    fixedSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0))),
                child: const Text(
                  "ENCODE",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                )),
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

  void listen() async {
    if (!isListening) {
      bool avail = await _speech.initialize();
      if (avail) {
        setState(() {
          isListening = true;
        });
        _speech.listen(onResult: (value) {
          setState(() {
            textController.text = value.recognizedWords;
          });
        });
      }
    }
  }

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    if (!isListening) {
      final text = textController.value.text;
      // Note: you can do your own custom validation here
      // Move this logic this outside the widget for more testable code
      if (text.split(' ').length > wordLimit) {
        validate = true;
        return 'You have exceed $wordLimit words';
      }
    }

    // return null if the text is valid
    validate = false;
    return null;
  }
}
