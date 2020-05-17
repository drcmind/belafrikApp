import 'package:belafrikapp/models/bellaVotEe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ListDeBellasVotEes extends StatefulWidget {
  @override
  _ListDeBellasVotEesState createState() => _ListDeBellasVotEesState();
}

class _ListDeBellasVotEesState extends State<ListDeBellasVotEes> {
  @override
  Widget build(BuildContext context) {

    final top10List = Provider.of<List<BellaVotEe>>(context) ?? [];

    return  SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverStaggeredGrid.countBuilder(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        staggeredTileBuilder: (int index) =>
            StaggeredTile.count(1, index.isEven ? 1.5 : 1.8),
        itemCount: top10List.length,
        itemBuilder: (context, index){

          int nbreVot = index +1;

          return Container(
            height: 200,
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
          );
        },
      ),
    );
  }
}

