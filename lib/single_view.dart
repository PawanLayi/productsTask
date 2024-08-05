import 'package:flutter/material.dart';
import 'global.dart';
import 'models/m_dashboard.dart';
import 'dart:convert';


class SingleView extends StatefulWidget {
  const SingleView({Key? key, required this.id}) : super(key: key);
  final int id;
  @override
  State<SingleView> createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> {

  ModelDashBoard? modelDashSingleCollection;
  int dataState = 0;


  @override
  void initState() {
    super.initState();
    getDasBoard();
  }

  Future<void> getDasBoard() async {
    try {
      print(AppSettings.api['DASHBOARD_GET']+"/"+widget.id.toString());
      var output = await AppSettings.callRemoteGETAPI(AppSettings.api['DASHBOARD_GET']+"/"+ widget.id.toString());
      if(output.isNotEmpty){
        modelDashSingleCollection = ModelDashBoard.fromJson(json.decode(output));
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
      return SizedBox(
        height: MediaQuery.of(context).size.height*.60,
        width: MediaQuery.of(context).size.width*.99,
        child: dashboardUi(context, modelDashSingleCollection!,""),
      );
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
        centerTitle: true,
        title:  Text('${messages['DASHBOARD']}',style: AppSettings.singleText),
      ),
      body: buildUI(),
    );
  }
}
