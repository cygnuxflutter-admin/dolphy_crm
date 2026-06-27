import 'package:crm/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_page.dart';

SharedPreferences? pref;
Logger logger = Logger();
final GlobalKey<NavigatorState> navigatorKey = Get.key;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pref = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: GetMaterialApp(
        title: "Dolphy",
        navigatorKey: navigatorKey,
        builder: (context, child) {
          return Stack(children: [child!]);
        },
        color: context.theme.colorScheme.primary,
        debugShowCheckedModeBanner: false,
        getPages: getPages,
        initialRoute: AppRoutes.splashScreen,
      ),
    );
  }
}

class MCQScreen extends StatefulWidget {
  @override
  _MCQScreenState createState() => _MCQScreenState();
}

class _MCQScreenState extends State<MCQScreen> {
  int currentIndex = 0;
  int? selectedOption;

  List<Map<String, dynamic>> questions = [
    {
      "question": "What is Flutter?",
      "options": ["SDK", "Language", "IDE", "OS"],
      "answer": 0,
    },
    {
      "question": "Who developed Flutter?",
      "options": ["Google", "Facebook", "Apple", "Microsoft"],
      "answer": 0,
    },
    {
      "question": "Which language is used in Flutter?",
      "options": ["Java", "Kotlin", "Dart", "Swift"],
      "answer": 2,
    },
  ];

  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedOption = null;
      });
    } else {
      // End
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Completed 🎉"),
          content: Text("You finished all questions"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentIndex = 0;
                  selectedOption = null;
                });
              },
              child: Text("Restart"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentQ = questions[currentIndex];

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(title: Text("MCQ Quiz"), centerTitle: true),
      body: Center(
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,

          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(animation);

            final scale = Tween<double>(begin: 0.8, end: 1.0).animate(animation);

            return SlideTransition(
              position: slide,
              child: ScaleTransition(scale: scale, child: child),
            );
          },

          child: Container(
            key: ValueKey(currentIndex),
            width: double.infinity,
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Question ${currentIndex + 1}", style: TextStyle(fontSize: 18, color: Colors.grey)),
                SizedBox(height: 10),

                Text(currentQ["question"], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                SizedBox(height: 20),

                ...List.generate(currentQ["options"].length, (index) {
                  bool isSelected = selectedOption == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? Colors.blue : Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: Colors.blue),
                          SizedBox(width: 10),
                          Text(currentQ["options"][index], style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  );
                }),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: selectedOption == null ? null : nextQuestion,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Next"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
