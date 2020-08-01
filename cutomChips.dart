import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test4/dimensions.dart';
import 'package:test4/widgets/constants.dart';

class CustomChips extends StatefulWidget {
  final double width;
  final double height;
  final Map<String, int> list;
  final Function(String) onSelect;
  final Color initialColor;
  final Color selectedColor;
  final Color disabledColor;
  final Axis direction;
  final EdgeInsetsGeometry padding;
  final TextStyle textStyle;
  final EdgeInsetsGeometry margin;
  final int PersonLimit;

  CustomChips({
    Key key,
    @required this.list,
    @required this.onSelect,
    @required this.initialColor,
    @required this.selectedColor,
    @required this.disabledColor,
    @required this.direction,
    @required this.padding,
    @required this.textStyle,
    @required this.margin,
    @required this.width,
    @required this.height,
    @required this.PersonLimit
  });

  @override
  _CustomChipsState createState() => _CustomChipsState();
}

class _CustomChipsState extends State<CustomChips> {
  String _id;
  bool isAbsorbing = true;

   List<Map<String, bool>> timeSlots = [
    {"9": true},
    {"10": true},
    {"11": true},
    {"12": true},
    {"13": true},
    {"14": true},
    {"15": true},
    {"16": true},
    {"17": true},
    {"18": true},
    {"19": true},
    {"20": true},

  ];



  getData() {
    Map<String, bool> temp = {};
    widget.list.forEach((key, value) {
      if (value > widget.PersonLimit)  { //
        temp[key] = false;
      }
    });
    temp.forEach(
          (key, value) {
        for (int i = 0; i < timeSlots.length; i++) {
          if (timeSlots[i].containsKey(key)) {
            timeSlots[i] = {key: value};
            break;
          }
        }
      },
    );
    // timeSlots.forEach((element) {
    //   print(element.toString());
    // });
  }

  Widget falseContainer(String id) => AbsorbPointer(
    absorbing: this.isAbsorbing,
    child: GestureDetector(
      onTap: () => Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Color(kdark),
        content: Text("Sorry.. the slot is already filled.",style: TextStyle(fontFamily: 'gil',fontSize: Dimensions.boxHeight*2,color: Colors.white),),
      )),
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: widget.margin,
        padding: this.widget.padding,
        alignment: Alignment(0, 0),
        decoration: BoxDecoration(
            color: widget.disabledColor,

            borderRadius: BorderRadius.circular(Dimensions.boxHeight),
            ),
        child: Text(
          id,
          style: widget.textStyle,
        ),
      ),
    ),
  );

  Widget trueContainer(String id, Color colours,Color textColour) {
    return AbsorbPointer(
      absorbing: this.isAbsorbing,
      child: GestureDetector(
        onTap: () {
          this._id = id;
          setState(() {});
          return widget.onSelect(id);
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding: this.widget.padding,
          alignment: Alignment(0, 0),
          decoration: BoxDecoration(
            color: colours,
            borderRadius: BorderRadius.circular(Dimensions.boxHeight),


          ),
          child: Text(
            id,
            style: widget.textStyle.copyWith(color:textColour),
          ),
        ),
      ),
    );
  }

  List<Widget> generateWidget(String id) {
    List<Widget> widgetList = [];

    timeSlots.forEach((element) {
      if (element.containsValue(false)) {
        widgetList.add(falseContainer(element.keys.elementAt(0)));
      } else {
        if (id == null)
          widgetList.add(
              trueContainer(element.keys.elementAt(0), widget.initialColor,Colors.black));
        else if (id == element.keys.elementAt(0)) {
          widgetList.add(
              trueContainer(element.keys.elementAt(0), widget.selectedColor,Colors.white));
        } else {
          widgetList.add(
              trueContainer(element.keys.elementAt(0), widget.initialColor,Colors.black));
        }
        //else if()
      }
    });
    setState(() {});
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    timeSlots = [
      {"9": true},
      {"10": true},
      {"11": true},
      {"12": true},
      {"13": true},
      {"14": true},
      {"15": true},
      {"16": true},
      {"17": true},
      {"18": true},
      {"19": true},
      {"20": true},

    ];

    if (widget.list.isEmpty) {
      this.isAbsorbing = true;
    } else
      this.isAbsorbing = false;
    getData();
    return Wrap(
      direction: widget.direction,
      children: generateWidget(this._id),
    );
  }
}