import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

const List<String> instructionOptions = <String>['N/A', 'Take with food', 'Take with water', 'Take on empty stomach'];
typedef MenuEntry = DropdownMenuEntry<String>;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dropdownValue = instructionOptions.first;
  static final List<MenuEntry> menuEntries = UnmodifiableListView<MenuEntry>(
    instructionOptions.map<MenuEntry>((String name) => MenuEntry(value: name, label: name)),
  );

  Widget _promptName() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Medication Name')
    );
  }

  Widget _promptInstructions() {
    return Row(
      children: <Widget>[
        const Text('Instructions:'),
        Spacer(),
        DropdownMenu<String>(
          initialSelection: instructionOptions.first,
          onSelected: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            }
            );
          },
          dropdownMenuEntries: menuEntries,
        )
      ]
    );
  }

  Widget _promptPerDose() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Recommended Dose'),
      keyboardType: TextInputType.number
    );
  }

  Widget _promptFrequency() {
    bool on = true;

    return Switch(
      // This bool value toggles the switch.
      value: on,
      activeThumbColor: Colors.red,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          on = value;
        });
      },
    );
  }

  void _addAlarm() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          color: const Color.fromARGB(255, 255, 189, 189),
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: .center,
              mainAxisSize: .min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Navigator.pop(context),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: .start,
                    children: <Widget>[
                      _promptName(),
                      const SizedBox(height: 20),
                      _promptInstructions(),
                      const SizedBox(height: 20),
                      _promptPerDose(),
                      const SizedBox(height: 20),
                      _promptFrequency()
                    ]
                  )
                )
              ],
            ),
          ),
        );
      }
    );
  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
