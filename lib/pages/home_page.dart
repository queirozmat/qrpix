import 'dart:developer';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixmp/pages/pix_page.dart';

import '../functions/pix_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _chavePix = TextEditingController();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _cidade = TextEditingController();
  final TextEditingController _valor = TextEditingController();
  String? selectedPixKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedPixKey,
                hint: const Text('Selecione o tipo de chave Pix'),
                onChanged: (String? newValue) {
                  _chavePix.clear();
                  setState(() {
                    selectedPixKey = newValue!;
                  });
                },
                items: <String>['Telefone', 'Email', 'CPF/CNPJ', 'Outro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (selectedPixKey == 'Telefone')
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Chave Pix',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter(),
                  ],
                  controller: _chavePix,
                ),
              if (selectedPixKey == 'Email')
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Chave Pix',
                  ),
                  controller: _chavePix,
                ),
              if (selectedPixKey == 'CPF/CNPJ')
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Chave Pix',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    CpfOuCnpjFormatter(),
                  ],
                  controller: _chavePix,
                ),
              if (selectedPixKey == 'Outro')
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Chave Pix',
                  ),
                  controller: _chavePix,
                ),
              TextFormField(
                maxLength: 25,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                controller: _nome,
              ),
              TextFormField(
                maxLength: 15,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                ),
                controller: _cidade,
              ),
              TextFormField(
                maxLength: 13,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                ),
                controller: _valor,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
              ),
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_chavePix.text.isEmpty ||
                          _nome.text.isEmpty ||
                          _cidade.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Preencha todos os campos'),
                          duration: Duration(seconds: 2),
                        ));
                        return;
                      }

                      String chavepixatt = _chavePix.text;

                      if (selectedPixKey == 'Telefone') {
                        chavepixatt =
                            '+55${UtilBrasilFields.obterTelefone(chavepixatt, mascara: false)}';
                      }

                      if (selectedPixKey == 'CPF/CNPJ') {
                        if (chavepixatt.contains('/')) {
                          chavepixatt = chavepixatt.replaceAll('.', '');
                          chavepixatt = chavepixatt.replaceAll('-', '');
                          chavepixatt = chavepixatt.replaceAll('/', '');
                        } else {
                          chavepixatt = chavepixatt.replaceAll('.', '');
                          chavepixatt = chavepixatt.replaceAll('-', '');
                        }
                      }

                      num? valor;

                      if (_valor.text.isNotEmpty) {
                        valor = num.parse(_valor.text.replaceAll(',', '.'));
                      }

                      log(chavepixatt);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PixPage(
                              pix: payLoadEstatico(
                                  chavepixatt, _nome.text, _cidade.text, '***',
                                  pValue: valor)),
                        ),
                      );
                    },
                    child: const Text('PIX'),
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
