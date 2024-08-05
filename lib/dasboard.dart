import 'package:flutter/material.dart';
import 'dart:convert';
import 'global.dart';
import 'models/m_dashboard.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);
  @override
  State<DashBoard> createState() => _DashBoardState();
}

int dataState = 0;

List<ModelDashBoard> modelDashBoardCollection = [];

class _DashBoardState extends State<DashBoard> {

  Future<void> getDasBoard({String? order}) async {
    if(mounted){
      setState(() {
        dataState = 0 ;
      });
    }
    String? url;
    try {
      if(order!=null){
         url = AppSettings.api['DASHBOARD_GET']+"?"+order;
      }
      else{
         url = AppSettings.api['DASHBOARD_GET'];
      }
      print(url);
      var output = await AppSettings.callRemoteGETAPI(url);
     if(output.isNotEmpty){
       modelDashBoardCollection = (json.decode(output) as List).map((dynamic model){
         return ModelDashBoard.fromJson(model);
       }).toList();
       if(mounted){
         setState(() {
           dataState = 1;
         });
       }
     }
     else{
       if(mounted){
         setState(() {
           dataState = 3;
         });
       }
     }
    } on Exception catch (e) {
      // TODO
      print(e);
      if(mounted){
        setState(() {
          dataState = 4;
        });
      }
    }
  }

  @override
  void initState() {
    getDasBoard();
    super.initState();
  }

  Widget buildUI() {
    if (dataState == 0) {
      return Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              child: Center(
                child: loadPreLoader(),
              ),
            ),
          ),
        ],
      );
    }
    else if (dataState == 1) {
      return ListView.builder(
          itemCount: modelDashBoardCollection.length,
          itemBuilder: (context,index){
            return dashboardUi(context,modelDashBoardCollection[index],"DashBoard");
      });
    }
    else if(dataState == 3){
      return Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage('images/noData.jpg'),
                    width: 120,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('${messages['No_DATA']}',
                    style: const TextStyle(fontSize: 15, fontFamily: 'Bold'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    else {
      return Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Image(
                    image: AssetImage('images/serverError.jpg'),
                    width: 120,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text('${messages['SERVER_ERROR']}',
                    style: const TextStyle(fontSize: 15, fontFamily: 'Bold'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: (){
                getDasBoard(order: "");
              },
              child: Text('${messages['DASHBOARD']}',style: AppSettings.appBarText),
            ),
            GestureDetector(
              onTap: (){
                getDasBoard(order: "sort=asce");
              },
              child: Text('${messages['ASCENDING']}',style: AppSettings.appBarText),
            ),
            GestureDetector(
              onTap: (){
                getDasBoard(order: "sort=desc");
              },
              child: Text('${messages['DESCENDING']}',style: AppSettings.appBarText),
            )
          ],
        ),
      ),
      body: buildUI(),
    );
  }
}
