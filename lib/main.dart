import 'package:flutter/material.dart';
import 'package:squeaker/widgets/watch_scaffold.dart';
import 'package:wear/wear.dart';

void main() {
  runApp(const SqueakerApp());
}

class SqueakerApp extends StatelessWidget {
  const SqueakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'squeaker',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const WatchScreen(),
    );
  }
}

class WatchScreen extends StatelessWidget {
  const WatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WatchShape(
        builder: (BuildContext context, WearShape shape, Widget? child) {
          return AmbientMode(
            builder: (context, mode, child) {
              return const WatchScaffold(
                title: Text(
                  'squeaker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                body: Center(
                  child: Text(
                    '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tincidunt commodo erat non tincidunt. Nullam iaculis enim nulla. Ut ut lectus non odio pellentesque ultrices. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum facilisis arcu vitae nibh lobortis vestibulum. Morbi sodales vehicula dolor a pellentesque. Duis sagittis nisi felis, ut suscipit tellus accumsan vitae. Aliquam ex nisl, ullamcorper id iaculis in, consequat sit amet elit. Vestibulum mattis semper nisl, ac suscipit arcu maximu''',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                actions: [
                  Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  Icon(
                    Icons.arrow_upward_sharp,
                    color: Colors.white,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
