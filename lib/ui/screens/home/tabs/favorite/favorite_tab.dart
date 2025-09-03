import 'package:evently_c15/data/firestore_utils.dart';
import 'package:evently_c15/ui/widgets/event_widget.dart';
import 'package:flutter/material.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: buildEventsList())],
    );
  }

  buildEventsList() => FutureBuilder(
      future: getFavoriteEvents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          var events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return EventWidget(eventDM: events[index], onFavClick: (){
                setState(() {});
              },);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      });
}
