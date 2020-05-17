import 'package:belafrikapp/templates/widgets/bellaVotEeList.dart';
import 'package:belafrikapp/templates/widgets/listTop10.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageExplorer extends StatefulWidget {
  @override
  _PageExplorerState createState() => _PageExplorerState();
}

class _PageExplorerState extends State<PageExplorer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              title: Text(
                'Les bellas à l\'une ',
                style: TextStyle(color: Colors.black),
              ),
              actions: <Widget>[
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.search, color: Colors.black,),
                )
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.only(left:16.0, right: 16.0, top: 16.0),
                    child: Text(
                        'Top de 10 bellas les plus votées',
                      style: Theme.of(context).textTheme.display1.copyWith(
                        color: Colors.black
                      ),
                    ),
                  )
                ]
              ),
            ),
            ListTop10(),
            SliverList(
              delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(left:16.0, right: 16.0, bottom: 16.0),
                      child: Text(
                        'Trouvez ici toutes les bellas votés ',
                        style: Theme.of(context).textTheme.display1.copyWith(
                            color: Colors.black
                        ),
                      ),
                    )
                  ]
              ),
            ),
            ListDeBellasVotEes(),
          ],
        ),
      )
    );
  }
}
