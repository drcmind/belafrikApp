import 'package:belafrikapp/models/bellaVotEe.dart';
import 'package:belafrikapp/models/utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MesBellasVotEs extends StatefulWidget {
  @override
  _MesBellasVotEsState createState() => _MesBellasVotEsState();
}

class _MesBellasVotEsState extends State<MesBellasVotEs> {
  @override
  Widget build(BuildContext context) {

    final bellaVotEe = Provider.of<List<BellaVotEe>>(context) ?? [];
    final util = Provider.of<Utilisateur>(context);

    return  SliverList(
      delegate: SliverChildBuilderDelegate((context, index){
        return bellaVotEe[index].idUser == util.idUtil ? Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 4),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(
                  bellaVotEe[index].imgBella,
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
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
                              '${bellaVotEe[index].nomBella}',
                              maxLines: 1,
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                                'la ${bellaVotEe[index].nationalitBella}',
                                maxLines: 1,
                                style: TextStyle(color: Colors.white, fontSize: 14)
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 23,
                        width: 23,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                        ),
                        child: Text(
                            '${bellaVotEe[index].nbreVoteBela}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ))
                    ),
                  )
                ],
              ),
            ),
          ),
        ):Container();
      }, childCount: bellaVotEe.length),
    );
  }
}
