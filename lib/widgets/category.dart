import 'package:flutter/material.dart';

// * renders a category widget
class Category extends StatelessWidget {
  final index;
  final categoryName;
  final categoryIcon;
  final categoryColor;

  const Category({
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
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Image.asset(
                        categoryIcon,
                        width: 40,
                        height: 40,
                      ),
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
