import 'package:flutter/material.dart';

List<FAQ> faqs = [
  FAQ(
    question: "Question 1",
    answer: "Answer 1",
  ),
  FAQ(
    question: "Question 2",
    answer: "Answer 2",
  ),
  FAQ(
    question: "Question 3",
    answer: "Answer 3",
  ),
  FAQ(
    question: "Question 4",
    answer: "Answer 4",
  ),
];

class AnswerTextContainer extends StatelessWidget {
  final String answer;
  final TextStyle textStyle;
  final double maxWidth;

  const AnswerTextContainer({
    super.key,
    required this.answer,
    required this.textStyle,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the actual height of the text
    final textPainter = TextPainter(
      text: TextSpan(text: answer, style: textStyle),
      maxLines: null, // Allow unlimited lines
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final textHeight = textPainter.height;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8),
      width: maxWidth,
      height: textHeight + 20, // Add padding/margins
      child: Text(
        answer,
        style: textStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align logo to the right
          children: <Widget>[
            const Align(
              alignment: Alignment.topLeft,
              child: FlutterLogo(size: 80), // Replace with your logo widget
            ),
            const SizedBox(height: 20),
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text('Email: contact@example.com'),
            const Text('Phone: +1 123 456 7890'),
            const Text('Address: 123 Main St, City, Country'),
            // Add other contact information as needed
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement your contact form submission logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact form submitted')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQ {
  final String question, answer;
  FAQ({
    required this.question,
    required this.answer,
  });
}

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTh = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        centerTitle: true,
        shadowColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) => ExpansionTile(
          title: Text(faqs[index].question),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AnswerTextContainer(
                answer: faqs[index].answer,
                textStyle: textTh.bodyLarge!,
                maxWidth: size.width * 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
