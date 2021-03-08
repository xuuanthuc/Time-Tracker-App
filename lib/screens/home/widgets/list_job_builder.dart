import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'empty_job_list.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder itemBuilder;

  const ListItemBuilder(
      {Key key, @required this.snapshot, @required this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _builderList(items);
      }
      return EmptyJobList();
    }
    if (snapshot.hasError) {
      return Text('Some error occurred');
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _builderList(List<T> items) {
    return ListView.builder(
      itemBuilder: (context, index) => itemBuilder(context, items[index],),
      itemCount: items.length,);
  }
}

