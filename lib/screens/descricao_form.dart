import 'package:flutter/material.dart';

class DescricaoForm extends StatefulWidget {
  const DescricaoForm({super.key});

  @override
  DescricaoFormState createState() => DescricaoFormState();
}

class DescricaoFormState extends State<DescricaoForm> {
  final _formKey = GlobalKey<FormState>();
  static const _btnDivider = SizedBox(height: 15);
  TextEditingController descricaoInput = TextEditingController();
  String descricao = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Descrição - Pessoas'),
        ),
        body: Form(
            key: _formKey,
            child: Container(
                margin: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: descricaoInput,
                        decoration: const InputDecoration(
                            labelText: 'Descrição',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true),
                        onChanged: ((value) {
                          setState(() {
                            descricao = value;
                          });
                        }),
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Requirido';
                          }
                          return null;
                        },
                      ),
                      _btnDivider,
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          // Foreground color
                          // ignore: deprecated_member_use
                          onPrimary: Theme.of(context).colorScheme.onPrimary,
                          // Background color
                          // ignore: deprecated_member_use
                          primary: Theme.of(context).colorScheme.primary,
                        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Cadastrando...')));
                          }
                        },
                        label: const Text('Cadastrar'),
                        icon: const Icon(Icons.send),
                      ),
                    ]))));
  }
}
