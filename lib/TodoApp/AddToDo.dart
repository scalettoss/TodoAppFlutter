import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({super.key});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ]
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              IconButton(
                  onPressed: () {
              }, icon: Icon(
                CupertinoIcons.arrow_left,
                     color:  Colors.white,
                     size: 28,
              )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 5
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Task",
                        style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25,),
                      Text(
                        "Title",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xff2a2e3d),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Input Your Task",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                            contentPadding: EdgeInsets.only(left: 20, right: 20)
                          ),
                        ),
                      ),
                      SizedBox(height: 25,),
                      Text(
                        "Descreption",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Container(
                        height: 155,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xff2a2e3d),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17
                          ),
                          maxLines: null,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Input Your Descreption",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                              contentPadding: EdgeInsets.only(left: 20, right: 20)
                          ),
                        ),
                      ),
                      /// Thêm nút chọn ngày giờ
                      SizedBox(height: 55,),
                      Container(
                        height: 56,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff8a32f1),
                              Color(0xffad32f9)
                            ],
                          )
                        ),
                        child: Center(child: Text("Add Todo",
                          style: TextStyle(color: Colors.white),
                        ),),
                      )
                    ],
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
