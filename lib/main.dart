import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      home: const SwipeableCards(),
    );
  }
}

class SwipeableCards extends StatefulWidget {
  const SwipeableCards({super.key});

  @override
  State<SwipeableCards> createState() => _SwipeableCardsState();
}

class _SwipeableCardsState extends State<SwipeableCards> {
  List<int> cardOrder = [0, 1, 2, 3, 4, 5];

  List<String> imageData = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.png',
    'assets/6.png',
  ];

  void changeCardOrder(int sCard, int index) {
    setState(() {
      String imageToInsert = imageData[index];
      cardOrder.remove(sCard);
      imageData.remove(imageData[index]);
      imageData.insert(0, imageToInsert);

      cardOrder.insert(0, sCard);
    });
  }

  @override
  void initState() {
    super.initState();
    cardOrder = cardOrder.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/background.jpg',
                ),
                fit: BoxFit.cover)),
        child: Center(
          child: Stack(
            children: [
              for (int i = 0; i < cardOrder.length; i++)
                SCard(
                  // color: Colors.amber,
                  imageData: imageData[i],
                  index: i,
                  key: ValueKey(cardOrder[i]),
                  value: cardOrder[i],
                  onDragged: () => changeCardOrder(cardOrder[i], i),
                )
            ],
          ),
        ),
      ),
    );
  }
}

class SCard extends StatefulWidget {
  final int index;
  final int value;
  final Function onDragged;
  // final LinearGradient color;
  final String imageData;
  const SCard({
    super.key,
    required this.index,
    required this.onDragged,
    required this.value,
    required this.imageData,
  });

  @override
  State<SCard> createState() => _SCardState();
}

class _SCardState extends State<SCard> with TickerProviderStateMixin {
  Offset _position = const Offset(0, 0);
  double height = 200;
  List<double> cardSizes = [180, 188, 196, 204, 212, 220];
  late double width = 220;

  Curve _myCurve = Curves.linear;
  Duration _duration = const Duration(milliseconds: 0);

  @override
  void initState() {
    // width = cardSizes[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: ((MediaQuery.of(context).size.width / 2) - (width / 2)) +
          _position.dx,
      top: ((MediaQuery.of(context).size.height / 2) -
              (height / 40 * -20) +
              (widget.index > 3 ? widget.index * -10 : -30)) +
          _position.dy,

      // (_position.dy - (widget.index * 15)),
      duration: _duration,
      curve: _myCurve,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (widget.index == 5) {
            _myCurve = Curves.linear;
            _duration = const Duration(milliseconds: 0);
            if (width >= 100 || height >= 100) {
              width -= 4;
              height -= 1;
            }

            _position += details.delta;
            setState(() {});
          }
        },
        onPanEnd: (details) {
          if (widget.index == 5) {
            _myCurve = Curves.easeIn;
            _duration = const Duration(milliseconds: 300);
            setState(() {
              if (_position.dx <= -(width / 2) || _position.dx >= (width / 2)) {
                // If so, move the card to the back (0th index)
                widget.onDragged();

                _position = Offset.zero;
              } else {
                _position = Offset.zero;
              }
              print(width);
              width = 220;
              height = 200;
            });
          }
        },
        child: AnimatedContainer(
          width: width,
          height: height,
          duration: const Duration(milliseconds: 200),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                // gradient: widget.color,
                image: DecorationImage(
                    // alignment: Alignment.center,
                    image: AssetImage(widget.imageData),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text("Item ${widget.value}")),
          ),
        ),
      ),
    );
  }

  void _animateCardBack() {
    // _animationController.forward();
  }

  @override
  void dispose() {
    // _animationController.dispose();
    super.dispose();
  }
}
