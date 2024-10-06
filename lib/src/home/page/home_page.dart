import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cepController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fast Location',
        ),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.green,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(1),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.navigation,
                    size: 60,
                    color: Colors.green,
                  ),
                  Text(
                    'Faça uma busca para localizar seu destino',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.green,
                textStyle: const TextStyle(color: Colors.white),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Localizar endereço',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return DraggableScrollableSheet(
                      expand: true,
                      builder: (
                        BuildContext context,
                        ScrollController scrollController,
                      ) {
                        return SingleChildScrollView(
                          controller: scrollController,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: cepController,
                                  decoration: const InputDecoration(
                                    labelText: 'Digite o CEP',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.green,
                                    textStyle:
                                        const TextStyle(color: Colors.white),
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                  ),
                                  child: const Text(
                                    'Localizar endereço',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    String cep = cepController.text;
                                    String address = await locateAddress(cep);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Endereço encontrado'),
                                          content: Text(address),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Fechar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.green),
                Text(
                  'Últimos endereços localizados',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, color: Colors.green, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Não há locais recentes',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Colors.green,
                textStyle: const TextStyle(color: Colors.white),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Histórico de endereços',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {},
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.directions,
          color: Colors.white,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
      ),
    );
  }

  Future<String> locateAddress(String cep) async {
    if (cep.isEmpty || cep.length != 9) {
      return 'Por favor, insira um CEP válido.';
    }

    var result = await buscarCep(cep);
    if (result is Map<String, dynamic>) {
      String logradouro = result['logradouro'] ?? '';
      String bairro = result['bairro'] ?? '';
      String localidade = result['localidade'] ?? '';
      String uf = result['uf'] ?? '';

      return 'Endereço: $logradouro, $bairro, $localidade - $uf';
    } else {
      return result;
    }
  }

  Future<dynamic> buscarCep(String cep) async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return 'Erro ao buscar CEP: ${response.statusCode}';
    }
  }
}
