import 'package:flutter/material.dart';
import 'package:squeaker/widgets/rotary_wrapper.dart';
import 'package:squeaker/widgets/rotary_scroll_bar.dart';
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
      home: const WatchScreenList(),
    );
  }
}

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WatchShape(
        builder: (BuildContext context, WearShape shape, Widget? child) {
          return AmbientMode(
            builder: (context, mode, child) {
              return RotaryScrollWrapper(
                rotaryScrollBar: RotaryScrollBar(
                  controller: pageController,
                ),
                child: PageView(
                  scrollDirection: Axis.vertical,
                  controller: pageController,
                  children: const [
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WatchScreenList extends StatefulWidget {
  const WatchScreenList({super.key});

  @override
  State<WatchScreenList> createState() => _WatchScreenListState();
}

class _WatchScreenListState extends State<WatchScreenList> {
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WatchShape(
        builder: (BuildContext context, WearShape shape, Widget? child) {
          return AmbientMode(
            builder: (context, mode, child) {
              return RotaryScrollWrapper(
                rotaryScrollBar: RotaryScrollBar(
                  controller: scrollController,
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Container(
                        color:
                            Colors.blue.withRed(((255 / 29) * index).toInt()),
                        width: 50,
                        height: 50,
                        child: Center(child: Text('box $index')),
                      ),
                    );
                  },
                  itemCount: 30,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
