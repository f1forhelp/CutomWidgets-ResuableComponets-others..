import 'package:flutter/material.dart';
import 'package:uiHomeCraft/constants.dart';
import 'package:uiHomeCraft/dimensions.dart';
import 'dart:math' as math;

class CustomDropDown extends StatefulWidget {
  final List<String> dropDownItems;
  final Function(String) getSelected;
  final String startingItem;
  CustomDropDown({this.dropDownItems, this.getSelected, this.startingItem});
  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown>
    with SingleTickerProviderStateMixin {
  GlobalKey key = LabeledGlobalKey("container");
  Offset offset;
  Size buttonSize;
  Offset buttonPosition;
  OverlayEntry overlayEntry;
  bool isOpen = false;
  AnimationController animationController;
  List<OverlayEntry> overlayList = [];
  int heightManager = 0;
  String selectedItem;

  OverlayEntry overlayEntryBuilder(String label) {
    return OverlayEntry(
      builder: (context) {
        heightManager++;
        return Positioned(
          left: buttonPosition.dx,
          top: buttonPosition.dy + buttonSize.height * heightManager,
          child: DropDownItems(
            label: label,
            getLabel: (val) {
              closeMenu();
              selectedItem = val;
              widget.getSelected(val);
              setState(() {});
            },
          ),
        );
      },
    );
  }

  findButton() {
    RenderBox renderBox = key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  openMenu() {
    for (var item in widget.dropDownItems) {
      if (item != selectedItem) overlayList.add(overlayEntryBuilder(item));
    }
    findButton();
    // overlayList.remove(selectedItem);
    Overlay.of(context).insertAll(overlayList);
    isOpen = true;
  }

  closeMenu() {
    animationController.reverse();
    overlayList.forEach((element) {
      element.remove();
    });
    overlayList.clear();
    setState(() {});
    heightManager = 0;
    isOpen = false;
  }

  @override
  void initState() {
    selectedItem = widget.startingItem;

    animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 200),
        lowerBound: 0,
        upperBound: math.pi / 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isOpen) {
          animationController.reverse();
          closeMenu();
        } else {
          animationController.forward();
          openMenu();
        }
      },
      child: Stack(
        alignment: Alignment(1, 0),
        children: [
          DropDownItems(
            isAbsorbing: true,
            key: key,
            label: selectedItem,
          ),
          AnimatedBuilder(
            child: Icon(
              Icons.keyboard_arrow_down,
              size: Dimensions.boxHeight * 4,
            ),
            animation: animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -animationController.value,
                child: child,
              );
            },
          )
        ],
      ),
    );
  }
}

class DropDownItems extends StatelessWidget {
  final bool isAbsorbing;
  final String label;
  final Function(String) getLabel;
  const DropDownItems({
    this.isAbsorbing = false,
    this.getLabel,
    this.label,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isAbsorbing,
      child: GestureDetector(
        onTap: () {
          return getLabel(label);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1),
          child: Material(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white,
            child: Container(
              alignment: Alignment(-0.7, 0),
              width: Dimensions.boxWidth * 35,
              height: Dimensions.boxHeight * 3.2,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.boxHeight * 2.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
