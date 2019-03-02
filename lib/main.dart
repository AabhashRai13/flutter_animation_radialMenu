import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians, Vector3;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox.expand(
          child: RadialMenu(),
        ),
      ),
    );
  }
}

class RadialMenu extends StatefulWidget {
  @override
   createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(controller: controller);
  }
}

class RadialAnimation extends StatelessWidget {
  RadialAnimation({Key key, this.controller})
      : scale = Tween<double>(
          begin: 1.5,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
        ),
        translation = Tween<double>(begin: 0.0, end: 100.0).animate(
          CurvedAnimation(parent: controller, curve: Curves.elasticOut),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.7, curve: Curves.decelerate))),
        super(key: key);

  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;

  build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: controller,
      builder: (context, builder) {
        return Transform.rotate(angle: radians(rotation.value), child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildButton(0,
                color: Colors.red, icon: FontAwesomeIcons.thumbtack),
            _buildButton(45,
                color: Colors.green, icon: FontAwesomeIcons.sprayCan),
            _buildButton(90, color: Colors.orange, icon: FontAwesomeIcons.fire),
            _buildButton(180,
                color: Colors.transparent, icon: FontAwesomeIcons.calculator),
            _buildButton(135,
                color: Colors.lightGreenAccent,
                icon: FontAwesomeIcons.sprayCan),
            _buildButton(225,
                color: Colors.deepPurpleAccent, icon: FontAwesomeIcons.paw),
            _buildButton(270, color: Colors.blue, icon: FontAwesomeIcons.bong),
            _buildButton(315, color: Colors.pink, icon: FontAwesomeIcons.bolt),
            Transform.scale(
              scale: scale.value - 1.2,
              child: FloatingActionButton(
                child: Icon(FontAwesomeIcons.timesCircle),
                onPressed: _close,
                backgroundColor: Colors.red,
              ),
            ),
            Transform.scale(
              scale: scale.value,
              child: FloatingActionButton(
                child: Icon(FontAwesomeIcons.solidDotCircle),
                onPressed: _open,
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ));
        },
    );
  }

  _buildButton(double angle, {Color color, IconData icon}) {
    final double rad = radians(angle);
    return Transform(
      transform: Matrix4.identity()
        ..translate(
          (translation.value) * cos(rad),
          (translation.value) * sin(rad),
        ),
      child: FloatingActionButton(
        child: Icon(icon),
        backgroundColor: color,
        onPressed: _close,
      ),
    );
  }

  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }
}
