import 'package:flutter/material.dart';
import 'package:kroner_app/styles.dart';

class ButtonList extends StatefulWidget {

  final ValueChanged<String> onPointsUpdated;
  ButtonList({required this.onPointsUpdated, Key? key}) : super(key: key);

  @override
  _ButtonListState createState() => _ButtonListState();
}

class _ButtonListState extends State<ButtonList> {
  bool _elimPressed = false;
  String penaltyPoints = "0";
  List<String> _previousPenaltyPoints = ["0"];
 
  void on4PointsPressed() {
    addPenaltyPoints("4");
  }

  void on1PointsPressed() {
    addPenaltyPoints("1");
  }

  void elimPressed() {
      _elimPressed = true;
      addPenaltyPoints("ELIM");
    }

  void addPenaltyPoints(String points) {
    _previousPenaltyPoints.add(penaltyPoints);
      
      if (points == "ELIM") {
        penaltyPoints = "ELIM";
      } else {
        int currentPoints = int.tryParse(penaltyPoints) ?? 0;
        int newPoints = int.tryParse(points) ?? 0;
        penaltyPoints = (currentPoints + newPoints).toString();
      }

      setState(() {
        widget.onPointsUpdated(penaltyPoints);
      });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ElevatedButton( key: const Key('4Points'),
          onPressed: _elimPressed ? null : on4PointsPressed,
          child: Text('+4'),
          style: myButtonStyle(context)
        ),
        mySizedBox(context),
        ElevatedButton( key: const Key('1Point'),
          onPressed: _elimPressed ? null : on1PointsPressed,
          child: Text('+1'),
          style: myButtonStyle(context)
        ),
        mySizedBox(context),
        ElevatedButton( key: const Key('elimButton'),
          onPressed: _elimPressed ? null : (){
            elimPressed();
          },
          child: Text('ELIM'),
          style: elimButtonStyle(context)
        ),
        mySizedBox(context),
        ElevatedButton(
          key: const Key('reverse'),
          onPressed: () {
            if (_previousPenaltyPoints.length > 1) {
              penaltyPoints = _previousPenaltyPoints.removeLast();
              _elimPressed = false;
              setState(() {
                widget.onPointsUpdated(penaltyPoints);
              });
            }
          },
          child: Center(
            child: IconTheme(
              data: iconTheme(context),
              child: Icon(Icons.arrow_back),
            ),
          ),
          style: myButtonStyle(context),
        ),
        SizedBox(width: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Icon(Icons.delete),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all(CircleBorder()),
                padding: MaterialStateProperty.all(EdgeInsets.all(6)),
              ),
            ),
            SizedBox(width: 20), // Ajusta este valor para cambiar el espacio entre los botones
            ElevatedButton(
              onPressed: () {},
              child: Icon(Icons.save),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                shape: MaterialStateProperty.all(CircleBorder()),
                padding: MaterialStateProperty.all(EdgeInsets.all(6)),
              ),
            ),
          ],
        )
      ],
    );
  
    

  }
}