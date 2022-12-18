import 'package:flutter/material.dart';
import 'package:squeaker/widgets/rotary_page_view.dart';
import 'package:squeaker/widgets/tweet_screen.dart';
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

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WatchShape(
        builder: (BuildContext context, WearShape shape, Widget? child) {
          return AmbientMode(
            builder: (context, mode, child) {
              return const RotaryPageView(
                children: [
                  TweetScreen(
                    user: 'squeaker',
                    content: 'test',
                    controller: null,
                  ),
                  TweetScreen(
                    user: 'squeaker',
                    content: 'test',
                    controller: null,
                  ),
                  TweetScreen(
                    user: 'squeaker',
                    content:
                        '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tincidunt commodo erat non tincidunt. Nullam iaculis enim nulla. Ut ut lectus non odio pellentesque ultrices. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum facilisis arcu vitae nibh lobortis vestibulum. Morbi sodales vehicula dolor a pellentesque. Duis sagittis nisi felis, ut suscipit tellus accumsan vitae. Aliquam ex nisl, ullamcorper id iaculis in, consequat sit amet elit. Vestibulum mattis semper nisl, ac suscipit arcu maximu''',
                    controller: null,
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
