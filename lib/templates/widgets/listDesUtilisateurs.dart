import 'package:belafrikapp/models/utilisateur.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListUtil extends StatefulWidget {
  @override
  _ListUtilState createState() => _ListUtilState();
}

class _ListUtilState extends State<ListUtil> {
  @override
  Widget build(BuildContext context) {

    final listUtil = Provider.of<List<DonnEesUtil>>(context) ?? [];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: listUtil.length,
      itemBuilder: (context, index){
        return GestureDetector(
          child: Container(
            height: 100,
            width: 100,
            child: Container(
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(
                    '${listUtil[index].lastImgPost}',),
                    fit: BoxFit.cover
                )
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.9),
                      Colors.black.withOpacity(.1),
                    ]
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width:2.0),
                        image: DecorationImage(
                          image: NetworkImage('${listUtil[index].photoUrl}'),
                          fit: BoxFit.cover
                        )
                      )
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(listUtil[index].nomUtil, maxLines: 1, style: TextStyle(color: Colors.white),),
                        Text('${listUtil[index].nbrePost} dilemme(s)', maxLines: 1,
                        style: TextStyle(
                          color: Colors.white, fontSize: 10.0
                        ),)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
