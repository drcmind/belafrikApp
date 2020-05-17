import 'dart:math';

import 'package:belafrikapp/models/top10.dart';
import 'package:belafrikapp/templates/widgets/cardSccr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListTop10 extends StatefulWidget {
  @override
  _ListTop10State createState() => _ListTop10State();
}

class _ListTop10State extends State<ListTop10> {

  PageController pageController;
  double viewPortFraction = 0.8;
  double pageOffset = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, viewportFraction: viewPortFraction)
    ..addListener((){
      setState(() {
        pageOffset = pageController.page;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    final top10List = Provider.of<List<Top10>>(context) ?? [];

    return SliverList(
      delegate: SliverChildListDelegate(
          [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                height: 400,
                child: PageView.builder(
                  itemCount: top10List.length,
                  controller: pageController,
                  itemBuilder: (context, index) {
                    double scale =
                        max(viewPortFraction,(pageOffset - index).abs())
                        + viewPortFraction;
                    int nbreVot = index +1;

                    var delta = index - (top10List.length - 1.0);
                    bool isOnRight = delta > 0;

                    var start = 20.0 +
                        max(10 * -delta * (isOnRight ? 200 : 150), 0.0);
                    return Container(
                      padding: EdgeInsets.only(
                        right: 20,

                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(.9),
                                Colors.black.withOpacity(.1)
                              ],
                              begin: Alignment.bottomRight,
                            )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'N°$nbreVot ${top10List[index].nomBella}',
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                      'la ${top10List[index].nationalitBella}',
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 14)
                                  ),
                                  Text(
                                      'Avec ${top10List[index].nbreVoteBela} vote(s)',
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white, fontSize: 14)
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ]
      ),
    );
  }
}
