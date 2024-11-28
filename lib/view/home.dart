// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galaxy_planets/controller/animate_pro.dart';
import 'package:galaxy_planets/view/all.dart';
import 'package:galaxy_planets/view/messier.dart';
import 'package:galaxy_planets/view/planet.dart';
import 'package:galaxy_planets/view/star.dart';
import 'package:provider/provider.dart';

import '../model/planet_model.dart';

class Home extends StatefulWidget {
  final Planet? pm;

  const Home({super.key, this.pm});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<String> typeList = [
    "All",
    "Planets",
    "Stars",
    "Messier",
    "More",
  ];

  late final animationController = AnimationController(
    vsync: this,
    upperBound: 2 * pi,
    lowerBound: 0,
    animationBehavior: AnimationBehavior.preserve,
    duration: Duration(seconds: 10),
  );
  late final curvedAnimation = CurvedAnimation(
      parent: animationController, curve: FlippedCurve(Curves.linear));

  void initState() {
    animationController.repeat();
    var planet = Provider.of<AnimatePro>(context, listen: false);
    planet.getdata();
    planet.foundList = planet.planetList;
    planet.getData();
    Future.microtask(() {
      Provider.of<AnimatePro>(context, listen: false).getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dark = Provider.of<AnimatePro>(context, listen: false).isDark;
    return Scaffold(
      backgroundColor: dark ? Colors.white : Colors.transparent,
      appBar: AppBar(
        title: Text(
          "Our Galaxy ",
          style: TextStyle(
              color: dark ? Colors.black : Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700),
        ),
        backgroundColor: dark ? Colors.white : Colors.transparent,
        actions: [
          Consumer<AnimatePro>(
            builder: (BuildContext context, value, Widget? child) {
              return Center(
                child: IconButton(
                    onPressed: () {
                      value.theme();
                    },
                    icon: Icon(
                      (value.isDark)
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      size: 30,
                      color: dark ? Colors.black : Colors.white,
                    )),
              );
            },
          ),
          Hero(
            tag: "mylike",
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "LikePage");
              },
              icon: Icon(
                Icons.favorite,
                size: 30,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Let's ",
                    style: TextStyle(
                        color: dark ? Colors.black : Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "Explore!",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            Consumer<AnimatePro>(
              builder: (context, value, child) {
                return Container(
                  height: 50,
                  color: Colors.grey.withOpacity(0.2),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: typeList.length,
                    itemBuilder: (context, index) {
                      String type = typeList[index];
                      return InkWell(
                        onTap: () {
                          value.changeIndex(index);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            type,
                            style: TextStyle(
                              color: (index == value.typeIndex)
                                  ? Colors.blue
                                  : Colors.grey,
                              fontSize: 18,
                              fontWeight: (index == value.typeIndex)
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            Consumer<AnimatePro>(
              builder: (context, value, child) {
                return IndexedStack(
                  index: value.typeIndex,
                  children: [
                    All(
                      pm: value.planetList,
                    ),
                    Planets(pm: value.planetList),
                    Star(),
                    Messier(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
