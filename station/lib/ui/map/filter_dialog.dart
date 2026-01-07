import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Filter currentFilter;
  final ValueChanged<Filter> onSubmit;
  final VoidCallback onCancel;

  const FilterDialog({
    required this.currentFilter,
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends State<FilterDialog> {
  late String _gas;

  @override
  void initState() {
    _gas = widget.currentFilter.gas;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          widget.onCancel();
        },
        child: Scaffold(
            body: SafeArea(
                top: false,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    widget.onCancel();
                                  });
                                },
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                      child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(tr('station.gas.label'),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 8),
                                                    child: Wrap(
                                                      spacing: 8,
                                                      children: <Widget>[
                                                        FilterChip(
                                                            label: Text(
                                                                tr(
                                                                    'station.gas.e5'),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                            avatar: CircleAvatar(
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                            selected:
                                                                _gas == "e5",
                                                            onSelected:
                                                                (bool value) {
                                                              setState(() {
                                                                _gas = "e5";
                                                              });
                                                            }),
                                                        FilterChip(
                                                            label: Text(
                                                                tr(
                                                                    'station.gas.e10'),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                            avatar: CircleAvatar(
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                            selected:
                                                                _gas == "e10",
                                                            onSelected:
                                                                (bool value) {
                                                              setState(() {
                                                                _gas = "e10";
                                                              });
                                                            }),
                                                        FilterChip(
                                                            label: Text(
                                                                tr(
                                                                    'station.gas.diesel'),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16)),
                                                            avatar: CircleAvatar(
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor),
                                                            selected: _gas ==
                                                                "diesel",
                                                            onSelected:
                                                                (bool value) {
                                                              setState(() {
                                                                _gas = "diesel";
                                                              });
                                                            }),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 32),
                                                    child: SizedBox(
                                                        width: double.infinity,
                                                        child: Row(children: [
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 8.0),
                                                            child: Container(),
                                                          )),
                                                          Expanded(
                                                              child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8.0),
                                                            child:
                                                                ElevatedButton(
                                                              onPressed: () {
                                                                final filter =
                                                                    Filter(
                                                                  _gas,
                                                                );
                                                                widget.onSubmit(
                                                                    filter);
                                                              },
                                                              child: Text(tr(
                                                                  'generic.save')),
                                                            ),
                                                          ))
                                                        ])))
                                              ]))))
                            ]))))));
  }
}

class Filter {
  final String gas;

  Filter(this.gas);

  @override
  String toString() {
    return 'Filter{gas: $gas}';
  }
}
