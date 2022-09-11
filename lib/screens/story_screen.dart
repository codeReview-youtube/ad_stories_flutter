import 'dart:async';

import 'package:ad_stories/products.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StoryScreenArgs {
  final String id;
  final List<Product> products;

  const StoryScreenArgs({required this.id, required this.products});
}

class StoryScreen extends StatefulWidget {
  late String groupId;
  late List<Product> products;
  StoryScreen({required this.groupId, required this.products, super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int currentIndex = 0;
  List<double> precentagesProgress = [];

  @override
  void initState() {
    super.initState();
    for (var _ in widget.products) {
      precentagesProgress.add(0.0);
    }
    _watchingProgress();
  }

  void _watchingProgress() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (precentagesProgress[currentIndex] + 0.01 < 1) {
          precentagesProgress[currentIndex] += 0.01;
        } else {
          precentagesProgress[currentIndex] = 1;
          timer.cancel();

          if (currentIndex < widget.products.length - 1) {
            currentIndex++;
            _watchingProgress();
          } else {
            _goBack();
          }
        }
      });
    });
  }

  void _goBack() {
    Navigator.pop(context);
  }

  void _onTap(TapDownDetails details) {
    final double dx = details.globalPosition.dx;
    final double width = MediaQuery.of(context).size.width;
    if (dx < width / 2) {
      setState(() {
        if (currentIndex > 0) {
          precentagesProgress[currentIndex - 1] = 0;
          precentagesProgress[currentIndex] = 0;
          currentIndex--;
        }
      });
    } else {
      setState(() {
        if (currentIndex < widget.products.length - 1) {
          precentagesProgress[currentIndex] = 1;
          currentIndex++;
        } else {
          precentagesProgress[currentIndex] = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.products;
    return GestureDetector(
      onTapDown: _onTap,
      child: Scaffold(
        body: Stack(
          children: [
            _buildNavBar(),
            _buildBars(products.length, precentagesProgress),
            Container(
              margin: const EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(products[currentIndex].image),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 20,
              right: 20,
              child: Text(
                products[currentIndex].title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 20,
              child: Row(
                children: [
                  const Text('Only', style: TextStyle(fontSize: 20)),
                  Text(
                    '${products[currentIndex].price}€',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              left: (MediaQuery.of(context).size.width / 2) - 35,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  children: const [
                    Icon(Icons.keyboard_arrow_up),
                    Text('See more'),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 15,
              child: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 15, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.products[currentIndex].image),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  widget.products[currentIndex].category,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: _goBack,
            icon: const Icon(
              Icons.close,
              size: 40,
              color: Color.fromARGB(255, 104, 101, 108),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBars(int count, List<double> precents) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 40,
        left: 4,
        right: 4,
        bottom: 10,
      ),
      child: Row(
        children: [
          for (int i = 0; i < count; i++)
            Expanded(
              child: LinearPercentIndicator(
                progressColor: Colors.deepPurple,
                backgroundColor: const Color.fromARGB(255, 226, 226, 226),
                lineHeight: 7.5,
                percent: precents[i],
                barRadius: const Radius.circular(10.0),
              ),
            )
        ],
      ),
    );
  }
}
