import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

double result = 0;

class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
 

  final TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading=false;

  Future<double> getExchangeRate() async {
  final response = await http.get(
    Uri.parse('https://api.exchangerate.host/convert?from=USD&to=INR&amount=1&access_key=7d030b66dc77d2f964df4725f14c4adc'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['result'] != null && data['result'] is num) {
      return (data['result'] as num).toDouble();
    } else {
      throw Exception('Invalid response format');
    }
  } else {
    throw Exception('Failed to fetch exchange rate');
  }
}

  void convertCurrency() async {
    setState(() {
      isLoading=true;
    });
    double inrRate = await getExchangeRate(); // live rate
    final inputUSD=double.parse(textEditingController.text);
    setState(() {
      result = inputUSD * inrRate;
      isLoading=false;
    });
    
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black26,
        width: 2.0,
        style: BorderStyle.solid,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.yellow.shade800,
            Colors.yellow.shade700,
            Colors.yellow.shade600,
            Colors.yellow.shade400,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 100,
          shape: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          elevation: 3,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 3,
                  blurRadius: 3,
                  blurStyle: BlurStyle.normal,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(20)),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 249, 168, 37),
                  Color.fromARGB(255, 253, 192, 45),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Image.asset(
              "assets/images/ChatGPT Image Jun 1, 2025, 10_14_52 PM.png",
              scale: 25,
            ),
          ),
          titleSpacing: 2,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              "Currency Converter",
              style: TextStyle(
                letterSpacing: 2,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "",
                foreground:
                    Paint()
                      ..shader = ui.Gradient.linear(
                        const Offset(0, 20),
                        const Offset(210, 20),
                        <Color>[
                          const Color.fromARGB(255, 255, 255, 255),
                          const Color.fromARGB(255, 36, 36, 35),
                        ],
                      ),
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₹${result.toString()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter an Amount";
                          }
                          return null;
                        },
                        controller: textEditingController,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: "Please enter the amount in USD",
                          hintStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: Colors.black,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: border,
                          enabledBorder: border,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                          convertCurrency();
                            
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.black),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                          minimumSize: WidgetStatePropertyAll(
                            Size(double.infinity, 50),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                           isLoading? "Converting..." : "Convert",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
