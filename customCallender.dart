import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test4/dimensions.dart';

class CustomCallender extends StatefulWidget {
  final List<DateTime> disabledDates;
  final Function(DateTime) getSelected;
  final Color disabledBgColour;
  final Color enabledBgColour;
  final Color selectedBgColour;
  final Color disabledTextColour;
  final Color enabledTextColour;
  final Color selectedTextColour;

  CustomCallender({
    this.disabledDates,
    this.getSelected,
    this.disabledBgColour,
    this.enabledBgColour,
    this.selectedBgColour,
    this.disabledTextColour,
    this.enabledTextColour,
    this.selectedTextColour,
  });

  @override
  _CustomCallenderState createState() => _CustomCallenderState();
}

class _CustomCallenderState extends State<CustomCallender> {
  DateTime globalId;
  int selectedMonth;
  ScrollController scrollController;
  List<DateTime> firstMonth = [];
  List<DateTime> secondMonth = [];
  List<Widget> firstWidet = [];
  List<Widget> secondWidget = [];

  @override
  void initState() {
    selectedMonth = 2;
    super.initState();
    scrollController = ScrollController();
  }

  String monthMapper(int month) {
    String strMonth = "";
    switch (month) {
      case 1:
        strMonth = "January";
        break;
      case 2:
        strMonth = "February";
        break;
      case 3:
        strMonth = "March";
        break;
      case 4:
        strMonth = "April";
        break;
      case 5:
        strMonth = "May";
        break;
      case 6:
        strMonth = "June";
        break;
      case 7:
        strMonth = "July";
        break;
      case 8:
        strMonth = "August";
        break;
      case 9:
        strMonth = "September";
        break;
      case 10:
        strMonth = "October";
        break;
      case 11:
        strMonth = "November";
        break;
      case 12:
        strMonth = "December";
        break;
    }
    return strMonth;
  }

  String weekMapper(int week) {
    String strWeek = "";
    switch (week) {
      case 1:
        strWeek = "Mon";
        break;
      case 2:
        strWeek = "Tue";
        break;
      case 3:
        strWeek = "Wed";
        break;
      case 4:
        strWeek = "Thu";
        break;
      case 5:
        strWeek = "Fri";
        break;
      case 6:
        strWeek = "Sat";
        break;
      case 7:
        strWeek = "Sun";
        break;
    }
    return strWeek;
  }

  getData() {
    firstMonth = [];
    secondMonth = [];
    firstWidet = [];
    secondWidget = [];

    int previousMonth = DateTime.now().month;

    for (int i = 0; i < 30; i++) {
      if (DateTime.now().add(Duration(days: i)).month == previousMonth) {
        firstMonth.add(DateTime.now().add(Duration(days: i)));
        previousMonth = DateTime.now().month;
      } else {
        secondMonth.add(
          DateTime.now().add(Duration(days: i)),
        );
      }
    }
  }

  datesMapper() {
    final DateFormat checkFormat = DateFormat('yyyy-MM-dd');
    for (int i = 0; i < firstMonth.length; i++) {
      firstMonth[i] = checkFormat.parse(firstMonth[i].toString());
    }
    for (int i = 0; i < secondMonth.length; i++) {
      secondMonth[i] = checkFormat.parse(secondMonth[i].toString());
    }
    for (int i = 0; i < widget.disabledDates.length; i++) {
      widget.disabledDates[i] =
          checkFormat.parse(widget.disabledDates[i].toString());
    }
  }

  Widget disabledWidget(
      DateTime dateTime, Color bgColour, Color textColour, double height) {

    return GestureDetector(
      onTap: () => Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Sorry this slot is already filled"),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height,
          ),
          Text(
            weekMapper(dateTime.weekday),
            style: TextStyle(color: Colors.white, fontSize: height * 2),
          ),
          SizedBox(
            height: height * 1,
          ),
          Container(
            height: height * 6,
            width: height * 6,
            alignment: Alignment(0, 0),
            decoration: BoxDecoration(color: bgColour, shape: BoxShape.circle),
            child: Text(
              dateTime.day.toString(),
              style: TextStyle(
                fontSize: height * 3,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget enabledWidget(
      DateTime dateTime, Color bgColour, Color textColour,double height) {

    return GestureDetector(
      onTap: () {
        this.globalId = dateTime;
        setState(() {});
        return widget.getSelected(globalId);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height,
          ),
          Text(
            weekMapper(dateTime.weekday),
            style: TextStyle(
              color: Colors.white,
              fontSize: height * 2,
            ),
          ),
          SizedBox(
            height: height * 1,
          ),
          Container(
            height: height * 6,
            width: height * 6,
            alignment: Alignment(0, 0),
            decoration: BoxDecoration(color: bgColour, shape: BoxShape.circle),
            child: Text(
              dateTime.day.toString(),
              style: TextStyle(fontSize: height * 3, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  generateWidgetList(int month) {
    double height = MediaQuery.of(context).size.height/100;
    if (month == 1)
      firstMonth.forEach((element) {
        if (widget.disabledDates.contains(element)) {
          firstWidet.add(disabledWidget(element, widget.disabledBgColour,
              widget.disabledTextColour,height));
        } else {
          if (globalId == null) {
            firstWidet.add(enabledWidget(element, widget.enabledBgColour,
                widget.enabledTextColour, height));
          } else if (globalId == element) {
            firstWidet.add(enabledWidget(element, widget.selectedBgColour,
                widget.selectedTextColour, height));
          } else {
            firstWidet.add(enabledWidget(element, widget.enabledBgColour,
                widget.enabledTextColour, height));
          }
        }
      });
    else
      secondMonth.forEach((element) {
        if (widget.disabledDates.contains(element)) {
          secondWidget.add(disabledWidget(element, widget.disabledBgColour,
              widget.disabledTextColour, height));
        } else {
          if (globalId == null) {
            secondWidget.add(enabledWidget(element, widget.enabledBgColour,
                widget.enabledTextColour, height));
          } else if (globalId == element) {
            secondWidget.add(enabledWidget(element, widget.selectedBgColour,
                widget.selectedTextColour, height));
          } else {
            secondWidget.add(enabledWidget(element, widget.enabledBgColour,
                widget.enabledTextColour, height));
          }
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double width = MediaQuery.of(context).size.width / 100;
    getData();
    datesMapper();
    generateWidgetList(selectedMonth);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(height * 2),
      ),
      child: Column(
        children: [
          SizedBox(
            height: height * 1.5,
          ),
          Text(
            "BOOK APPOINTMENT",
            style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.boxHeight * 3,
                fontWeight: FontWeight.w500),
          ),
          Stack(
            alignment: Alignment(0, 0),
            children: [
              Text(
                selectedMonth == 1
                    ? monthMapper(DateTime.now().month)
                    : monthMapper(DateTime.now().add(Duration(days: 30)).month),
                style: TextStyle(color: Colors.white, fontSize: height * 3),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.navigate_before,
                        size: height * 5,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        scrollController.jumpTo(0.0);
                        selectedMonth = 1;
                        setState(() {});
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.navigate_next,
                        size: height * 5,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        scrollController.jumpTo(0.0);
                        selectedMonth = 2;
                        setState(() {});
                      }),
                ],
              ),
            ],
          ),
          SizedBox(
            height: height * 12,
            child: ListView.builder(
              controller: scrollController,
              shrinkWrap: true,
              itemCount:
                  selectedMonth == 1 ? firstWidet.length : secondWidget.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 4),
                  child: selectedMonth == 1 ? firstWidet[i] : secondWidget[i],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}