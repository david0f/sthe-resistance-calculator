import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: new MyTextInput(),
    );
  }
}

class DiameterResistanceModel {
  double diameter;
  double resistance;

  DiameterResistanceModel({this.diameter, this.resistance});
}

class MyTextInput extends StatefulWidget {
  @override
  MyTextInputState createState() => new MyTextInputState();
}

class MyTextInputState extends State<MyTextInput> {
  double power;
  double voltage;
  double resistance;
  String resistanceText = "";

  String desiredDiameterResistance;
  double desiredDiameter;
  String desiredPhiDorn;
  double wireLength;
  double spireLength;
  double numOfSpires;
  double coilLength;
  double roundedCoilLength;

  double desiredWireGap;

  double roundFactor;

  var _powerController = TextEditingController();
  var _voltageController = TextEditingController();

  List<DiameterResistanceModel> _diameterResitanceList = [
    DiameterResistanceModel(diameter: 0.5, resistance: 6.88),
    DiameterResistanceModel(diameter: 0.6, resistance: 4.77),
    DiameterResistanceModel(diameter: 0.7, resistance: 3.51),
    DiameterResistanceModel(diameter: 0.8, resistance: 2.69),
    DiameterResistanceModel(diameter: 0.9, resistance: 2.12),
    DiameterResistanceModel(diameter: 1.0, resistance: 1.72),
    DiameterResistanceModel(diameter: 1.1, resistance: 1.42),
    DiameterResistanceModel(diameter: 1.2, resistance: 1.19),
    DiameterResistanceModel(diameter: 1.3, resistance: 1.02),
    DiameterResistanceModel(diameter: 1.4, resistance: 0.877),
    DiameterResistanceModel(diameter: 1.5, resistance: 0.764),
    DiameterResistanceModel(diameter: 1.6, resistance: 0.671),
    DiameterResistanceModel(diameter: 1.7, resistance: 0.595),
    DiameterResistanceModel(diameter: 1.8, resistance: 0.531),
    DiameterResistanceModel(diameter: 1.9, resistance: 0.430),
    DiameterResistanceModel(diameter: 2.0, resistance: 0.340),
  ];

  @override
  void dispose() {
    _powerController.dispose();
    _voltageController.dispose();
    super.dispose();
  }

  void calculate() {
    voltage = double.parse(_voltageController.text);
    power = double.parse(_powerController.text);

    if (!voltage.isNaN && !power.isNaN && voltage > 200 && power > 200) {
      resistance = (pow(voltage, 2) / power);
      resistanceText = "R = " + resistance.toStringAsFixed(1) + " Ω";
    } else {
      resistanceText = "Please input valid values";
    }
  }

  String calculateWireLength() {
    if (desiredDiameterResistance != null && resistance != null) {
      wireLength = resistance / (double.parse(desiredDiameterResistance));
      desiredDiameter = _diameterResitanceList
          .firstWhere((data) =>
              data.resistance == double.parse(desiredDiameterResistance))
          .diameter;
      return "L\u209b = " + wireLength.toStringAsFixed(1) + " m";
    } else {
      wireLength = null;
      desiredDiameter = null;
      return "";
    }
  }

  String calcSpireLength() {
    if (desiredDiameter != null && desiredPhiDorn != null) {
      spireLength = (double.parse(desiredPhiDorn) + desiredDiameter) * math.pi;
      return "L\u209b\u209a = " + spireLength.toStringAsFixed(1) + " mm/sp";
    } else {
      return "";
    }
  }

  String calcNumOfSpires() {
    if (wireLength != null && spireLength != null) {
      numOfSpires = (wireLength * 1000) / spireLength;
      return "N\u209b\u209a = " + numOfSpires.toStringAsFixed(1) + " sp";
    } else {
      return "";
    }
  }

  String calcNumOfCoils() {
    if (numOfSpires != null && desiredDiameter != null) {
      coilLength = numOfSpires * desiredDiameter;
      debugPrint(coilLength.toString());
      return "L = " + coilLength.toStringAsFixed(1) + " mm";
    } else {
      return "";
    }
  }

  String calcRoundedNumOfCoils() {
    if (coilLength != null) {
      roundFactor = 1.01;
      roundedCoilLength = coilLength * roundFactor;
      debugPrint(roundedCoilLength.toString());
      if (roundedCoilLength % 10 > 3) {
        double diff = 10 - roundedCoilLength % 10;
        roundedCoilLength += diff;
      } else {
        double diff = 5 - roundedCoilLength % 10;
        roundedCoilLength += diff;
      }
      return "L = " + roundedCoilLength.toStringAsFixed(0) + " mm";
    } else {
      return "";
    }
  }

  String calcStep(){
      return "123";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text("Resistance Calculator"),
            backgroundColor: Colors.deepOrange),
        body: new Container(
            child: new Padding(
                padding: EdgeInsets.all(24.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Image(
                        image: new AssetImage('assets/heating_element.png'),
                        width: 180,
                      ),
                    ),
                    new Text(
                      'Please complete the following fields:',
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                    new SizedBox(height: 16),
                    new Row(
                      children: <Widget>[
                        
                        new Expanded(
                            child: new Padding(
                                padding: EdgeInsets.all(4),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins"),
                                    decoration: new InputDecoration(
                                        labelText: "Power [W]",
                                        border: new OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        hasFloatingPlaceholder: true),
                                    keyboardType: TextInputType.number,
                                    controller: _powerController,
                                    onChanged: (String str) {
                                      setState(() {
                                        calculate();
                                      });
                                    }))),
                        new Expanded(
                            child: new Padding(
                                padding: EdgeInsets.all(0.0),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins"),
                                  decoration: new InputDecoration(
                                        labelText: "Voltage [V]",
                                        border: new OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        hasFloatingPlaceholder: true),
                                  enabled: true,
                                  keyboardType: TextInputType.number,
                                  controller: _voltageController,
                                  onChanged: (String str) {
                                    setState(() {
                                      calculate();
                                    });
                                  },
                                ))),
                        new Row(children: <Widget>[],),
                        new Expanded(
                            flex: 1,
                            child: new DropdownButton<String>(
                              value: desiredDiameterResistance,
                              onChanged: (String newValue) {
                                setState(() {
                                  desiredDiameterResistance = newValue;
                                });
                              },
                              items: _diameterResitanceList
                                  .map((data) => DropdownMenuItem<String>(
                                        child: Text(data.diameter.toString()),
                                        value: data.resistance.toString(),
                                      ))
                                  .toList(),
                              hint: Text("\u2300 Wire"),
                              isExpanded: false,
                              isDense: true,
                            )),
                        new Divider(height: 2, indent: 8, color: Colors.blue),
                        new Expanded(
                          flex: 1,
                          child: new DropdownButton<String>(
                            value: desiredPhiDorn,
                            onChanged: (String newValue) {
                              setState(() {
                                desiredPhiDorn = newValue;
                              });
                            },
                            items: new List<int>.generate(10, (i) => i + 1)
                                .map((data) => DropdownMenuItem<String>(
                                      child: Text(data.toString()),
                                      value: data.toString(),
                                    ))
                                .toList(),
                            hint: Text("\u03C6 dorn"),
                            isExpanded: false,
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                    new Divider(
                      height: 42,
                      indent: 10,
                      color: Colors.deepOrange,
                      endIndent: 10,
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 3,
                            child: new SizedBox(
                              child: new Text(
                                resistanceText,
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 24),
                              ),
                            )),
                      ],
                    ),
                    new SizedBox(
                      height: 12,
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            flex: 3,
                            child: new SizedBox(
                              child: new Text(
                                calculateWireLength().toString(),
                                style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w300,
                                    fontSize: 24),
                              ),
                            )),
                      ],
                    ),
                    new SizedBox(
                      height: 12,
                    ),
                    new Text(
                      (calcSpireLength()),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
                    ),
                    new SizedBox(
                      height: 12,
                    ),
                    new Text((calcNumOfSpires()),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w300)),
                    new SizedBox(
                      height: 12,
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text((calcNumOfCoils()),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w300)),
                        new Text(calcRoundedNumOfCoils(),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w300))
                      ],
                    ),
                    new SizedBox(
                      height: 12,
                    ),
                    new Text(calcStep(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w300)),
                            new SizedBox(
                      height: 12,
                    ),
                    new Text(calcStep(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w300)),
                  ],
                ))));
  }
}