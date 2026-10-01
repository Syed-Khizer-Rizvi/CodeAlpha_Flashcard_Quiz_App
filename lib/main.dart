import 'package:flutter/material.dart';

void main() {
  runApp(const FlashcardQuizApp());
}

class FlashcardQuizApp extends StatelessWidget {
  const FlashcardQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C63FF),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const FlashcardHome(),
    );
  }
}

class Flashcard {
  String question;
  String answer;

  Flashcard({required this.question, required this.answer});
}

class FlashcardHome extends StatefulWidget {
  const FlashcardHome({super.key});

  @override
  State<FlashcardHome> createState() => _FlashcardHomeState();
}

class _FlashcardHomeState extends State<FlashcardHome> {
  List<Flashcard> flashcards = [
    Flashcard(question: 'What is Flutter?', answer: 'A UI toolkit by Google for building cross-platform apps.'),
    Flashcard(question: 'What language does Flutter use?', answer: 'Dart'),
    Flashcard(question: 'What is a Widget in Flutter?', answer: 'Everything in Flutter is a widget. It describes the UI.'),
    Flashcard(question: 'What is Hot Reload?', answer: 'A feature that lets you see code changes instantly without restarting the app.'),
    Flashcard(question: 'What is pubspec.yaml?', answer: 'A file that manages Flutter project dependencies and metadata.'),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  void nextCard() {
    if (flashcards.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex + 1) % flashcards.length;
      showAnswer = false;
    });
  }

  void previousCard() {
    if (flashcards.isEmpty) return;
    setState(() {
      currentIndex = (currentIndex - 1 + flashcards.length) % flashcards.length;
      showAnswer = false;
    });
  }

  void toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  void addFlashcard() {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                setState(() {
                  flashcards.add(Flashcard(
                    question: questionController.text,
                    answer: answerController.text,
                  ));
                  currentIndex = flashcards.length - 1;
                  showAnswer = false;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void editFlashcard() {
    if (flashcards.isEmpty) return;
    final questionController = TextEditingController(text: flashcards[currentIndex].question);
    final answerController = TextEditingController(text: flashcards[currentIndex].answer);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (questionController.text.isNotEmpty && answerController.text.isNotEmpty) {
                setState(() {
                  flashcards[currentIndex].question = questionController.text;
                  flashcards[currentIndex].answer = answerController.text;
                  showAnswer = false;
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void deleteFlashcard() {
    if (flashcards.isEmpty) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flashcard'),
        content: const Text('Are you sure you want to delete this flashcard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                flashcards.removeAt(currentIndex);
                if (flashcards.isNotEmpty) {
                  currentIndex = currentIndex % flashcards.length;
                } else {
                  currentIndex = 0;
                }
                showAnswer = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcard Quiz',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: editFlashcard,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: deleteFlashcard,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addFlashcard,
        child: const Icon(Icons.add),
      ),
      body: flashcards.isEmpty
          ? const Center(
              child: Text(
                'No flashcards yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Progress indicator
                  Text(
                    'Card ${currentIndex + 1} of ${flashcards.length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (currentIndex + 1) / flashcards.length,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 30),

                  // Flashcard
                  Expanded(
                    child: GestureDetector(
                      onTap: toggleAnswer,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          key: ValueKey('${currentIndex}_$showAnswer'),
                          width: double.infinity,
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: showAnswer
                                ? const Color(0xFF6C63FF)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                showAnswer ? 'ANSWER' : 'QUESTION',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: showAnswer
                                      ? Colors.white70
                                      : Colors.grey[400],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                showAnswer
                                    ? flashcards[currentIndex].answer
                                    : flashcards[currentIndex].question,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: showAnswer ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 30),
                              if (!showAnswer)
                                OutlinedButton.icon(
                                  onPressed: toggleAnswer,
                                  icon: const Icon(Icons.visibility),
                                  label: const Text('Show Answer'),
                                ),
                              if (showAnswer)
                                OutlinedButton.icon(
                                  onPressed: toggleAnswer,
                                  icon: const Icon(Icons.visibility_off, color: Colors.white70),
                                  label: const Text(
                                    'Hide Answer',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.white70),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Navigation buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FilledButton.icon(
                        onPressed: previousCard,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: nextCard,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}