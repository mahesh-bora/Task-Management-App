import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/home_screen.dart';

import '../presentation/widgets/custom_animated_text.dart';

class StarterView extends StatelessWidget {
  const StarterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // const SizedBox(height: 40),
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: 240,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(200),
                        bottomRight: Radius.circular(200)),
                    image: DecorationImage(
                        image: AssetImage('assets/shade.jpg'),
                        fit: BoxFit.fitHeight)),
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: CustomAnimatedText(
                seconds: 1,
                text: 'Manage your Daily Tasks',
                fontColor: Colors.black,
                fontSize: 44,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft, // Aligns text to the left
                child: CustomAnimatedText(
                  seconds: 2,
                  text: 'Turning chaos into order, one task at a time 🚀',
                  fontColor: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft, // Aligns text to the left
                child: CustomAnimatedText(
                  seconds: 3,
                  text: 'Ready to conquer?',
                  fontColor: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomBouncingButton(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomeScreen()),
                ),
                text: 'Get Started',
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class CustomBouncingButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  const CustomBouncingButton(
      {super.key, required this.text, required this.onTap});

  @override
  State<CustomBouncingButton> createState() => _CustomBouncingButtonState();
}

class _CustomBouncingButtonState extends State<CustomBouncingButton>
    with SingleTickerProviderStateMixin {
  double _scale = 0;
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
        onTapDown: _tapDown,
        onTapUp: _tapUp,
        onTap: widget.onTap,
        child: Transform.scale(
            scale: _scale,
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.deepPurpleAccent,
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x80000000),
                    blurRadius: 12.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            )));
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
