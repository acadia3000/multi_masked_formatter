import 'package:flutter/material.dart';
import 'package:multi_masked_formatter/multi_masked_formatter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('MultMaskedFormatter'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                inputFormatters: [
                  MultiMaskedTextInputFormatter(
                      masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')
                ],
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(
                      labelText: 'PhoneNumber',
                      hintText: '010-123-4567 or 010-1234-5678'),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                inputFormatters: [
                  MultiMaskedTextInputFormatter(
                      masks: ['xx.xx.xx', 'xxxx.xx.xx'], separator: '.')
                ],
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Date of birth', hintText: '99.02.20 or 1999.02.20'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
