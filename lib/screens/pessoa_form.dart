import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class PessoaForm extends StatefulWidget {
  const PessoaForm({super.key});

  @override
  PessoaFormState createState() => PessoaFormState();
}

class PessoaFormState extends State<PessoaForm> {
  final _formKey = GlobalKey<FormState>();
  static const _colDivider = SizedBox(height: 20);
  static const _btnDivider = SizedBox(height: 15);
  TextEditingController nomeInput = TextEditingController();
  TextEditingController idadeInput = TextEditingController();
  TextEditingController sexoInput = TextEditingController();
  TextEditingController descricaoInput = TextEditingController();
  String nome = '';
  DateTime idade = DateTime.now();
  String sexo = '';
  String descricao = '';
  FileImage? imageFile;
  bool? cameraPermission;

  @override
  void initState() {
    nomeInput.text = '';
    idadeInput.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            margin: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () async {
                      // cameraPermission ??= await checkPermission(context);
                      // if (cameraPermission!) {
                        XFile? image = await ImagePicker().pickImage(
                            source: ImageSource.camera, imageQuality: 100);
                        setState(() {
                          if (image != null) {
                            imageFile = FileImage(File(image.path));
                          }
                        });
                      // }
                    },
                    child: imageFile != null
                        ? Center(
                            child: SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundImage: imageFile,
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: -25,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder()),
                                      onPressed: () {
                                        setState(() {
                                          imageFile = null;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                      ),
                                    )),
                              ],
                            ),
                          ))
                        : Center(
                            child: SizedBox(
                            height: 115,
                            width: 115,
                            child: Stack(
                              clipBehavior: Clip.none,
                              fit: StackFit.expand,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ))),
                _colDivider,
                TextFormField(
                  controller: nomeInput,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      nome = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requirido';
                    }
                    return null;
                  },
                ),
                _colDivider,
                TextFormField(
                  controller: idadeInput,
                  decoration: const InputDecoration(
                    labelText: 'Idade',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? data = await showDatePicker(
                        context: context,
                        initialDate: idade,
                        firstDate: DateTime(1923),
                        lastDate: DateTime.now());
                    if (data != null) {
                      String dataFormatada =
                          DateFormat('dd-MM-yyyy').format(data);
                      setState(() {
                        idadeInput.text = dataFormatada;
                        idade = data;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Requirido';
                    }
                    return null;
                  },
                ),
                _colDivider,
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sexo',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Masculino', 'Feminino', 'Não binário']
                      .map((value) => DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                      .toList(),
                  onChanged: ((value) => setState(() {
                        sexo = value!;
                      })),
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
                      String descricaoFormRoute = '/descricao';
                      Navigator.pushNamed(context, descricaoFormRoute);
                    },
                    label: const Text('Adicionar descrição'),
                    icon: const Icon(Icons.add)),
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
                          const SnackBar(content: Text('Cadastrando...')));
                    }
                  },
                  label: const Text('Cadastrar'),
                  icon: const Icon(Icons.send),
                ),
              ],
            )));
  }

  Future<bool> checkPermission(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statues = await [
      Permission.camera,
      Permission.storage,
      Permission.photos,
    ].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusCamera == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    return isGranted;
  }
}
