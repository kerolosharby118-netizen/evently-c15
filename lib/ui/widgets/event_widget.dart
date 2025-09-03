
import 'package:evently_c15/data/firestore_utils.dart';
import 'package:evently_c15/model/category_dm.dart';
import 'package:evently_c15/model/event_dm.dart';
import 'package:evently_c15/model/user_dm.dart';
import 'package:evently_c15/ui/utils/app_assets.dart';
import 'package:evently_c15/ui/utils/app_colors.dart';
import 'package:flutter/material.dart';

class EventWidget extends StatefulWidget {
  final EventDM eventDM;
  final Function? onFavClick;

  const EventWidget({super.key, required this.eventDM, this.onFavClick});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  @override
  Widget build(BuildContext context) {
    CategoryDM categoryDM = CategoryDM.fromTitle(widget.eventDM.categoryId);
    return Container(
      margin: const EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(image: AssetImage(categoryDM.image)),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildDate(),
          Spacer(),
          buildTitle(),
        ],
      ),
    );
  }

  buildDate() => Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(
              widget.eventDM.date.day.toString(),
              style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              getMonthName(widget.eventDM.date.month),
              style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  String getMonthName(int month) {
    const List<String> months = [
      'jan',
      'feb',
      'mar',
      'apr',
      'may',
      'jun',
      'jul',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    return months[month - 1];
  }

  buildTitle() => Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Text(widget.eventDM.title,
                style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Spacer(),
            buildFavIcon(),
          ],
        ),
      );

  Widget buildFavIcon() {
    var isFavorite =
        UserDM.currentUser!.favoriteEvents.contains(widget.eventDM.id);
    return InkWell(
      onTap: () async {
        widget.onFavClick?.call();
        isFavorite
            ? await removeEventFromFavorite(widget.eventDM.id)
            : await addEventToFavorite(widget.eventDM.id);
        setState(() {});
      },
      child: ImageIcon(
        AssetImage(
          isFavorite ? AppAssets.loveActive : AppAssets.icFavorite,
        ),
        color: AppColors.blue,
      ),
    );
  }
}
