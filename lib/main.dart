import 'package:flutter/material.dart';

void main() {
  runApp(BMICalculator());
}

class BMICalculator extends StatefulWidget {
  @override
  State<BMICalculator> createState() => _BMICalculatorState();
}

class _BMICalculatorState extends State<BMICalculator> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
        ),
      ),
      home: BMICalculatorScreen(),
    );
  }
}

class BMICalculatorScreen extends StatefulWidget {
  @override
  _BMICalculatorScreenState createState() => _BMICalculatorScreenState();
}

class _BMICalculatorScreenState extends State<BMICalculatorScreen>
    with SingleTickerProviderStateMixin {
  double _height = 150; // Initial height value in cm
  double _weight = 50; // Initial weight value in kg
  double? _bmiResult;

  void calculateBMI() {
    double heightInMeters = _height / 100;
    double bmi = _weight / (heightInMeters * heightInMeters);
    setState(() {
      _bmiResult = bmi;
    });
    print('BMI: $_bmiResult');
  }

  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));

    _topAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _bottomAlignmentAnimation = TweenSequence<Alignment>(
      [
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomRight, end: Alignment.bottomLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.bottomLeft, end: Alignment.topLeft),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topLeft, end: Alignment.topRight),
          weight: 1,
        ),
        TweenSequenceItem<Alignment>(
          tween: Tween<Alignment>(
              begin: Alignment.topRight, end: Alignment.bottomRight),
          weight: 1,
        ),
      ],
    ).animate(_controller);

    _controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: const [
                Color(0xffF99E43),
                Color(0xFFDA2323),
              ],
              begin: _topAlignmentAnimation.value,
              end: _bottomAlignmentAnimation.value,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Calculate your BMI',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Height: ${_height.toStringAsFixed(0)} cm',
                  style: TextStyle(fontSize: 18.0),
                ),
                Slider(
                  value: _height,
                  min: 100,
                  max: 250,
                  divisions: 150,
                  onChanged: (value) {
                    setState(() {
                      _height = value;
                    });
                  },
                ),
                Text(
                  'Weight: ${_weight.toStringAsFixed(0)} kg',
                  style: TextStyle(fontSize: 18.0),
                ),
                Slider(
                  value: _weight,
                  min: 20,
                  max: 200,
                  divisions: 180,
                  onChanged: (value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    calculateBMI();
                  },
                  child: Text('Calculate'),
                ),
                SizedBox(height: 20.0),
                _bmiResult != null
                    ? Text(
                        'Your BMI: ${_bmiResult!.toStringAsFixed(1)}',
                        style: TextStyle(fontSize: 18.0),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}
