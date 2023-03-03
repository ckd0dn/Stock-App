import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:practice/data/source/local/company_listing_entity.dart';
import 'package:practice/data/source/remote/stock_api.dart';
import 'package:practice/data/repository/stock_repository_impl.dart';
import 'package:practice/domain/repository/stock_repository.dart';
import 'package:practice/presentation/company_listings/company_listings_screen.dart';
import 'package:practice/presentation/company_listings/company_listings_view_model.dart';
import 'package:practice/util/color_schemes.g.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart%20';

import 'data/source/local/stock_dao.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(CompanyListingEntityAdapter());

  final repository = StockRepositoryImpl(
    StockApi(),
    StockDao(),
  );

  GetIt.instance.registerSingleton<StockRepository>(repository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CompanyListingsViewModel(
            StockRepositoryImpl(
              StockApi(),
              StockDao(),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
      ),
      themeMode: ThemeMode.system,
      home: const CompanyListingsScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
