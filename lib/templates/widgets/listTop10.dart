import 'dart:math';

import 'package:belafrikapp/models/top10.dart';
import 'package:belafrikapp/templates/widgets/cardSccr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
            Container(
              height: 420,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Swiper(
                itemCount: top10List.length,
                itemWidth: 250,
                layout: SwiperLayout.STACK,
                pagination: SwiperPagination(
                  builder:
                  DotSwiperPaginationBuilder(
                      activeSize: 20,
                      color: Colors.black,
                      space: 8,
                  ),
                ),
                itemBuilder: (context, index) {
                  int nbreVot = index +1;
                  return Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Container(
                            height: 350,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(
                                  top10List[index].imgBella,
                                ),
                                fit: BoxFit.cover,
                              ),
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
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            )
          ]
      ),
    );
  }
}
