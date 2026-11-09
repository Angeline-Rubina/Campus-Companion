
import 'package:flutter/material.dart';

class CyberSafetyScreen extends StatefulWidget {
  const CyberSafetyScreen({super.key});

  @override
  State<CyberSafetyScreen> createState() =>
      _CyberSafetyScreenState();
}

class _CyberSafetyScreenState
    extends State<CyberSafetyScreen> {
  final List<Map<String, dynamic>> questions = [
    {
      'question': 'What should you do with an unknown link?',
      'options': [
        'Click immediately',
        'Check before opening',
        'Share with everyone',
        'Enter your password',
      ],
      'answer': 1,
    },
    {
      'question': 'Which password is safer?',
      'options': [
        '123456',
        'password',
        'MyName123',
        'A long unique password',
      ],
      'answer': 3,
    },
    {
      'question': 'What is phishing?',
      'options': [
        'A computer game',
        'A fake message to steal information',
        'A programming language',
        'A phone setting',
      ],
      'answer': 1,
    },
    {
      'question': 'Should you share an OTP with strangers?',
      'options': [
        'Yes',
        'Always',
        'No',
        'Only on social media',
      ],
      'answer': 2,
    },
    {
      'question': 'What should you do if an account is hacked?',
      'options': [
        'Ignore it',
        'Tell nobody',
        'Secure the account and report it',
        'Share more passwords',
      ],
      'answer': 2,
    },
  ];

  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  bool finished = false;

  void selectAnswer(int selected) {
    if (answered) return;

    setState(() {
      answered = true;

      if (selected ==
          questions[currentQuestion]['answer']) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestion < questions.length - 1) {
        currentQuestion++;
        answered = false;
      } else {
        finished = true;
      }
    });
  }

  void restartQuiz() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      answered = false;
      finished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8F1),

      appBar: AppBar(
        title: const Text('Cyber Safety Quiz'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: finished
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    const Icon(
                      Icons.shield,
                      size: 70,
                      color: Colors.green,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      'Your Score: $score / ${questions.length}',
                      style: const TextStyle(
                        fontSize: 22,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: restartQuiz,
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
              )

            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    'Question ${currentQuestion + 1} '
                    'of ${questions.length}',

                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    questions[currentQuestion]['question'],

                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  ...List.generate(
                    questions[currentQuestion]['options'].length,

                    (index) {
                      final option =
                          questions[currentQuestion]['options'][index];

                      final correct =
                          questions[currentQuestion]['answer'];

                      Color? tileColor;

                      if (answered && index == correct) {
                        tileColor = Colors.green.shade100;
                      } else if (answered &&
                          index != correct) {
                        tileColor = Colors.grey.shade200;
                      }

                      return Card(
                        color: tileColor,

                        child: ListTile(
                          title: Text(option),

                          onTap: () {
                            selectAnswer(index);
                          },
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  if (answered)
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: nextQuestion,

                        child: Text(
                          currentQuestion ==
                                  questions.length - 1
                              ? 'Finish Quiz'
                              : 'Next Question',
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
