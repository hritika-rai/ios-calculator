import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _displayText = '';
  String _prevValue='';
  String _exp = '';

  void _appendToDisplay(String value) {
    setState(() {
      if (value == '=') {
        _displayText = _evaluateExpression(_exp).toString();
        _exp = '';
        _prevValue='';

      } else if (value == '+' || value == '-' || value == '*' || value == '/') {
        if (_exp.isNotEmpty && (_exp.substring(_exp.length - 1) == '+' || _exp.substring(_exp.length - 1) == '-' || _exp.substring(_exp.length - 1) == '*' || _exp.substring(_exp.length - 1) == '/')) {
          _exp = _exp.substring(0, _exp.length - 1) + value;

        } else {
          _exp += value;
        }
        
      } else if (value=='%') {
        String numbersAfterLastOperator = getStringAfterLastOperator(_exp);
        double? doubleValue = double.tryParse(numbersAfterLastOperator)!/100;
        int lastOperatorIndex = findLastOperator(_exp);

        _exp = _exp.substring(0, lastOperatorIndex+1) + doubleValue.toString();

        _displayText = doubleValue.toString();
        
      } else if (value=='+/-') {
        _exp=_exp.substring(0, _exp.length-_prevValue.length)+"(-"+_prevValue+")";
        _displayText="-"+_prevValue;

      } else if (value=='.') {
        if (countDots(_displayText)==0) {
          _exp += value;
          _displayText+= value;
        }
        else {}

      } else {
        _exp += value;

        String stringAfterLastOperator = getStringAfterLastOperator(_exp);
        _displayText=stringAfterLastOperator;
        
        _prevValue =_displayText;
      }
    });
  }

  String getStringAfterLastOperator(String expression) {
    List<String> operators = ["+", "-", "*", "/"];
    
    int lastOperatorIndex = -1;
    for (int i = expression.length - 1; i >= 0; i--) {
      if (operators.contains(expression[i])) {
        lastOperatorIndex = i;
        break;
      }
    }
    
    if (lastOperatorIndex == -1) {
      return expression;
    }
    
    String exp = expression.substring(lastOperatorIndex + 1);
    return exp;
  }

  int findLastOperator(String expression) {
    List<String> operators = ["+", "-", "*", "/"];
    
    for (int i = expression.length - 1; i >= 0; i--) {
      if (operators.contains(expression[i])) {
        return i;
      }
    }
    
    return -1;
  }

  int countDots(String inputString) {
    int dotCount = 0;
    
    for (int i = 0; i < inputString.length; i++) {
      if (inputString[i] == '.') {
        dotCount++;
      }
    }
    
    return dotCount;
  }

  void _clearDisplay() {
    setState(() {
      _displayText = '';
      _exp = '';
      _prevValue='';
    });
  }

  double _evaluateExpression(String expression) {
    Parser parser = Parser();
    Expression exp = parser.parse(expression);
    ContextModel contextModel = ContextModel();
    double result = exp.evaluate(EvaluationType.REAL, contextModel);
    return double.parse(result.toStringAsFixed(10));  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 24.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _displayText.isEmpty ? '0' : _displayText,
                    style: TextStyle(fontSize: 84.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                  CalculatorButton(text: 'AC', onPressed: _clearDisplay, color: Colors.grey,),
                  CalculatorButton(text: '+/-', onPressed: () => _appendToDisplay('+/-'), color: Colors.grey),
                  CalculatorButton(text: '%', onPressed: () => _appendToDisplay('%'), color: Colors.grey),
                  CalculatorButton(text: '÷', onPressed: () => _appendToDisplay('/'), color: Colors.orange),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CalculatorButton(text: '7', onPressed: () => _appendToDisplay('7'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '8', onPressed: () => _appendToDisplay('8'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '9', onPressed: () => _appendToDisplay('9'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: 'x', onPressed: () => _appendToDisplay('*'),color: Colors.orange),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CalculatorButton(text: '4', onPressed: () => _appendToDisplay('4'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '5', onPressed: () => _appendToDisplay('5'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '6', onPressed: () => _appendToDisplay('6'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '-', onPressed: () => _appendToDisplay('-'),color: Colors.orange),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CalculatorButton(text: '1', onPressed: () => _appendToDisplay('1'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '2', onPressed: () => _appendToDisplay('2'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '3', onPressed: () => _appendToDisplay('3'),color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '+', onPressed: () => _appendToDisplay('+'),color: Colors.orange),
              ],
            ),

            Row(


              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 200.0,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      onPressed: () => _appendToDisplay('0'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(98, 100, 100, 100),
                        padding: EdgeInsets.fromLTRB(20.0, 23.0, 20.0, 23.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0), 
                          child: Text( 
                            '0',
                            style: TextStyle(fontSize: 30.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                CalculatorButton(text: '.', onPressed: () => _appendToDisplay('.'), color: Color.fromARGB(98, 100, 100, 100)),
                CalculatorButton(text: '=', onPressed: () => _appendToDisplay('='), color: Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double widthFactor;
  final Color color;

  const CalculatorButton({Key? key, required this.text, required this.onPressed, this.widthFactor = 1.0, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 80.0 * widthFactor,
        height: 80.0,
        child: FloatingActionButton(
          onPressed: onPressed,
          tooltip: text,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          backgroundColor: color,
        ),
      ),
    );
  }
}
