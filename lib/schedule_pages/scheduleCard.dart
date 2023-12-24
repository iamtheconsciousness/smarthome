import 'package:flutter/material.dart';
import 'schedule_database.dart';
import 'schedule_model.dart';

class ItemCard extends StatefulWidget {
  S_Model? model;
  TextEditingController? input1;
  TextEditingController? input2;
  VoidCallback? onDeletePress;
  VoidCallback? onEditPress;

  ItemCard(
      {this.model,
        this.input1,
        this.input2,
        this.onDeletePress,
        this.onEditPress});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final DbManagerSc dbManager = new DbManagerSc();
  String? selectedRoom;
  // ignore: deprecated_member_use


  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name: ${widget.model!.scheduleName!}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    'Item: ${widget.model!.name}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: widget.onEditPress,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      onPressed: widget.onDeletePress,
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
