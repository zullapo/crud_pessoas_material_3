import 'package:crud_pessoas_material_3/screens/descricao_form.dart';
import 'package:crud_pessoas_material_3/screens/pessoa_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

const pessoaFormRoute = '/';
const descricaoFormRoute = '/descricao';

class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  RouteFactory _routes() {
    return (settings) {
      Widget screen;
      switch (settings.name) {
        case pessoaFormRoute:
          screen = const PessoaForm();
          break;
        case descricaoFormRoute:
          screen = const DescricaoForm();
          break;
        default:
          return null;
      }
      return MaterialPageRoute(builder: (BuildContext context) => screen);
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD Pessoas',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CRUD Pessoas'),
        ),
        body: const PessoaForm(),
      ),
      onGenerateRoute: _routes(),
    );
  }
}
