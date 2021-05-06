import 'package:flutter/material.dart';

// * renders a category widget
class CategoryMain extends StatelessWidget {
  final index;
  final categoryName;
  final categoryIcon;
  final categoryColor;

  const CategoryMain({
    @required this.index,
    @required this.categoryName,
    @required this.categoryIcon,
    @required this.categoryColor,
  })  : assert(index != null),
        assert(categoryName != null),
        assert(categoryIcon != null),
        assert(categoryColor != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        height: 80,
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            highlightColor: categoryColor[400],
            splashColor: categoryColor,
            onTap: () => Navigator.pop(context, index),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Image.asset(
                      categoryIcon,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    categoryName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
