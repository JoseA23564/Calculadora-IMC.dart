import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Calcular IMC por Gustavo e José'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedGender = "Masculino 1431432312026 e 1431432312003"; 

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: "Masculino",
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
              },
            ),
            Text('Masculino'),
            Radio(
              value: "Feminino",
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value!;
                });
              },
            ),
            Text('Feminino'),
          ],
        ),
        selectedGender == "Masculino"
            ? MaleIMCCalculator()
            : FemaleIMCCalculator(),
      ],
    );
  }
}

abstract class IMCCalculator extends StatefulWidget {
  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();

  String getTitle();

  double getUnderweightThreshold();

  double getNormalWeightThreshold();

  double getOverweightThreshold();

  double getObesityThreshold();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  TextEditingController _weightController = TextEditingController();

  TextEditingController _heightController = TextEditingController();

  TextEditingController _resultController = TextEditingController();

  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.getTitle(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text('Seu peso'),
          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Exemplo: para 80k e 300g, digite 80.300',
            ),
            onChanged: (value) => validateInput(value),
          ),
          SizedBox(height: 10),
          Text('Sua altura'),
          TextFormField(
            controller: _heightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Exemplo: para 1m e 70cm, digite 1.70',
            ),
            onChanged: (value) => validateInput(value),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              calculateIMC();
            },
            child: Text('Calcular IMC'),
          ),
          SizedBox(height: 10),
          Text('Seu IMC é:'),
          TextFormField(
            controller: _resultController,
            readOnly: true,
          ),
          SizedBox(height: 10),
          Text('Situação:'),
          TextFormField(
            controller: _commentController,
            readOnly: true,
          ),
          SizedBox(height: 20),
          Text('Tabela de resultados'),
          Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Text('IMC'),
                  ),
                  TableCell(
                    child: Text('Categoria'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                        'Abaixo de ${widget.getUnderweightThreshold().toStringAsFixed(1)}'),
                  ),
                  TableCell(
                    child: Text('Abaixo do peso'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                        '${widget.getUnderweightThreshold().toStringAsFixed(1)} a ${widget.getNormalWeightThreshold().toStringAsFixed(1)}'),
                  ),
                  TableCell(
                    child: Text('Peso ideal'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                        '${widget.getNormalWeightThreshold().toStringAsFixed(1)} a ${widget.getOverweightThreshold().toStringAsFixed(1)}'),
                  ),
                  TableCell(
                    child: Text('Pouco acima do peso'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                        '${widget.getOverweightThreshold().toStringAsFixed(1)} a ${widget.getObesityThreshold().toStringAsFixed(1)}'),
                  ),
                  TableCell(
                    child: Text('Acima do peso'),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Text(
                        '${widget.getObesityThreshold().toStringAsFixed(1)} e acima'),
                  ),
                  TableCell(
                    child: Text('Obesidade'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void calculateIMC() {
    double weight = double.tryParse(_weightController.text) ?? 0.0;

    double height = double.tryParse(_heightController.text) ?? 1.0;

    double imc = weight / (height * height);

    _resultController.text = imc.toStringAsFixed(2);

    if (imc < widget.getUnderweightThreshold())
      _commentController.text = 'Abaixo do peso';
    else if (imc >= widget.getUnderweightThreshold() &&
        imc < widget.getNormalWeightThreshold())
      _commentController.text = 'Peso ideal';
    else if (imc >= widget.getNormalWeightThreshold() &&
        imc < widget.getOverweightThreshold())
      _commentController.text = 'Pouco acima do peso';
    else if (imc >= widget.getOverweightThreshold() &&
        imc < widget.getObesityThreshold())
      _commentController.text = 'Acima do peso';
    else if (imc >= widget.getObesityThreshold())
      _commentController.text = 'Obesidade';
  }

  void validateInput(String value) {
    if (value.isNotEmpty && double.tryParse(value) == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Atenção'),
            content: Text(
                'Utilize apenas números, separando com ponto (não utilize vírgula)'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class MaleIMCCalculator extends IMCCalculator {
  @override
  String getTitle() {
    return 'Calcular IMC masculino';
  }

  @override
  double getUnderweightThreshold() {
    return 20.7;
  }

  @override
  double getNormalWeightThreshold() {
    return 26.4;
  }

  @override
  double getOverweightThreshold() {
    return 27.8;
  }

  @override
  double getObesityThreshold() {
    return 31.1;
  }
}

class FemaleIMCCalculator extends IMCCalculator {
  @override
  String getTitle() {
    return 'Calcular IMC feminino';
  }

  @override
  double getUnderweightThreshold() {
    return 19.1;
  }

  @override
  double getNormalWeightThreshold() {
    return 25.8;
  }

  @override
  double getOverweightThreshold() {
    return 27.3;
  }

  @override
  double getObesityThreshold() {
    return 32.3;
  }
}
