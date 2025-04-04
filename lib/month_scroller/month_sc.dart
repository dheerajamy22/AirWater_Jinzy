import 'package:flutter/material.dart';



class MonthYearScroller extends StatefulWidget {
  @override
  _MonthYearScrollerState createState() => _MonthYearScrollerState();
}

class _MonthYearScrollerState extends State<MonthYearScroller> {
  int selectedMonthIndex = DateTime.now().month - 1; // Current month
  int selectedYear = DateTime.now().year; // Current year

  List<String> months = [
    '01 January', '02 February', '03 March', '04 April', '05 May', '06 June', 
    '07 July', '08 August', '09 September', '10 October', '11 November', '12 December' 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous Month Button
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                setState(() {
                  if (selectedMonthIndex == 0) {
                    selectedMonthIndex = months.length - 1;
                    selectedYear -= 1;
                  } else {
                    selectedMonthIndex -= 1;
                  }
                });
              },
            ),
            // Month Selector
            Text(
              months[selectedMonthIndex],
              style: TextStyle(fontSize: 20.0),
            ),
            // Next Month Button
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  if (selectedMonthIndex == months.length - 1) {
                    selectedMonthIndex = 0;
                    selectedYear += 1;
                    print('object month '+months[selectedMonthIndex],);
                  } else {
                    selectedMonthIndex += 1;
                  }
                });
              },
            ),
          ],
        ),
        // Year Selector
        GestureDetector(
          onTap: () {
            // Show dialog for selecting year
            _showYearPicker(context);
          },
          child: Text(
            selectedYear.toString(),
            style: TextStyle(fontSize: 20.0),
          ),
        ),
      ],
    ),
    );
     }

  void _showYearPicker(BuildContext context) {
    // Assuming you want to show years from 2000 to 2050
    int startYear = 2000;
    int endYear = 2050;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Year'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: endYear - startYear + 1,
              itemBuilder: (BuildContext context, int index) {
                int year = startYear + index;
                return ListTile(
                  title: Text(year.toString()),
                  onTap: () {
                    setState(() {
                      selectedYear = year;
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
