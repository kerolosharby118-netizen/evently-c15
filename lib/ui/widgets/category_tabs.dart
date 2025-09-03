import 'package:evently_c15/model/category_dm.dart';
import 'package:flutter/material.dart';

class CategoryTabs extends StatefulWidget {
  final List<CategoryDM> categories;
  final Function(CategoryDM) onTabSelected;
  final Color selectedTabBg;
  final Color unselectedTabBg;
  final Color selectedTabTextColor;
  final Color unselectedTabTextColor;

  const CategoryTabs(
      {super.key,
      required this.categories,
      required this.selectedTabBg,
      required this.selectedTabTextColor,
      required this.unselectedTabBg,
      required this.unselectedTabTextColor,
      required this.onTabSelected});

  @override
  State<CategoryTabs> createState() => _CategoryTabsState();
}

class _CategoryTabsState extends State<CategoryTabs> {
  late CategoryDM selectedCategory;
  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.categories.length,
      child: TabBar(
        isScrollable: true,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        onTap: (index){
          selectedCategory = widget.categories[index];
          widget.onTabSelected(selectedCategory);
          setState(() {});
        },
        tabs: widget.categories
            .map((category) => mapCategoryDMToTab(category, category == selectedCategory))
            .toList(),
      ),
    );
  }

  Widget mapCategoryDMToTab(CategoryDM category, bool isSelected) {
    return Tab(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(46),
            color: isSelected ? widget.selectedTabBg : widget.unselectedTabBg,
            border: Border.all(color: widget.selectedTabBg, width: 1)),
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              color: isSelected ? widget.selectedTabTextColor : widget.unselectedTabTextColor,
            ),
            SizedBox(width: 8,),
            Text(
              category.title,
              style: TextStyle(
                  color: isSelected
                      ? widget.selectedTabTextColor
                      : widget.unselectedTabTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
