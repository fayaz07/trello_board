import 'package:flutter/material.dart';
import 'package:trello_board/models/card.dart';

class TCard extends StatelessWidget {
  final TCardModel data;

  const TCard({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = TCardContent(
      data: data,
    );
    return TCardDraggable(
      child: child,
      data: data,
    );
  }
}

class TCardDraggable extends StatelessWidget {
  final Widget child;
  final TCardModel data;

  const TCardDraggable({Key key, this.child, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Draggable<TCardModel>(
      data: data,
      maxSimultaneousDrags: 1,
      feedback: child,
      child: child,
      childWhenDragging: SizedBox(),
      axis: Axis.horizontal,
    );
  }
}

class TCardContent extends StatelessWidget {
  final TCardModel data;

  const TCardContent({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Card(
      clipBehavior: Clip.none,
      margin:
          const EdgeInsets.only(left: 8.0, right: 32.0, top: 8.0, bottom: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 8.0,
      child: SizedBox(
        width: 200.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data.task,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 4.0),
              Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.thumb_up,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        print("inc likes of ${data.id}");
                      }),
                  Text("${data.likes}",
                      style: Theme.of(context).textTheme.bodyText2),
                  SizedBox(width: 16.0),
                  Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "${data.views}",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
