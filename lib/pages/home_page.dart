import 'package:bmi_calculator/widgets/circular_progress_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController weightController = TextEditingController();

  TextEditingController heightController = TextEditingController();

  AnimationController _circleController;

  AnimationController _colorController;

  Animation<double> circleAnimation;

  Animation<Color> colorAnimation;

  double percent = 0;

  Color weightColor = Colors.grey[700];

  String _infoText = "Informe seus dados!";

  @override
  void initState() {
    super.initState();
    _circleController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    circleAnimation =
        Tween<double>(begin: 0, end: percent).animate(_circleController)
          ..addListener(() {
            setState(() {
              percent = circleAnimation.value;
              _circleController.forward();
            });
          });

    _colorController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    colorAnimation = ColorTween(begin: Colors.grey[700], end: weightColor)
        .animate(_colorController)
          ..addListener(() {
            setState(() {
              weightColor = colorAnimation.value;
              _colorController.forward();
            });
          });
  }

  @override
  void dispose() {
    _circleController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _infoText = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
      weightColor = Colors.grey[700];
      percent = 0;
      _circleController.reverse();
      _colorController.reverse();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      if (imc < 18.6) {
        _infoText = "Abaixo do Peso (${imc.toStringAsPrecision(3)})";
        percent = imc;
        weightColor = Colors.red[400];
      } else if (imc >= 18.6 && imc < 24.9) {
        _infoText = "Peso Ideal (${imc.toStringAsPrecision(3)})";
        percent = imc;
        weightColor = Colors.green;
      } else if (imc >= 24.9 && imc < 29.9) {
        _infoText = "Sobrepeso (${imc.toStringAsPrecision(3)})";
        percent = imc;
        weightColor = Colors.orange;
      } else if (imc >= 29.9 && imc < 34.9) {
        _infoText = "Obesidade Grau I (${imc.toStringAsPrecision(3)})";
        percent = imc;
        weightColor = Colors.red;
      } else if (imc >= 34.9 && imc < 39.9) {
        _infoText = "Obesidade Grau II (${imc.toStringAsPrecision(3)})";
        percent = imc;
        weightColor = Colors.red[700];
      } else if (imc >= 40) {
        _infoText = "Obesidade Grau III (${imc.toStringAsPrecision(3)})";
        percent = imc;
        weightColor = Colors.red[900];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IMC Calculadora"),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, left: 60, right: 60),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Peso (kg)",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                  controller: weightController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira seu Peso!";
                    } else if (value.isNotEmpty && int.parse(value) <= 10) {
                      return "Insira um peso maior que 10 kg";
                    } else if (value.isNotEmpty && int.parse(value) >= 400) {
                      return "Insira um peso menor que 400 kg";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 60, right: 60),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Altura (cm)",
                    labelStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                  controller: heightController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira sua Altura!";
                    } else if (value.isNotEmpty && int.parse(value) <= 50) {
                      return "Insira uma altura maior que 50 cm";
                    } else if (value.isNotEmpty && int.parse(value) >= 250) {
                      return "Insira uma altura menor que 250 cm";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(105, 20, 105, 20),
                child: Container(
                  height: MediaQuery.of(context).size.height / 12,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: Text(
                      "Calcular",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.grey[700],
                  ),
                ),
              ),
              CustomPaint(
                foregroundPainter: CircularProgress(percent, weightColor),
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: MediaQuery.of(context).size.height / 3,
                  child: Center(
                    child: Text(
                      _infoText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}