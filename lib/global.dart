import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_task/single_view.dart';
import 'models/m_dashboard.dart';


enum RestResponse { failed,noDataFound,authFail,NODATARETRIEVEDFROMAPI,SERVERNOTRESPONDING }

Widget loadPreLoader({double size=25,String message=""}){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: size,
        width: size,
        child: const CircularProgressIndicator(
          backgroundColor: Colors.blue,
          valueColor:AlwaysStoppedAnimation<Color>(Colors.blue),
          strokeWidth: 3,
        ),
      ),
      const Padding(
        padding:EdgeInsets.only(top:8),
        child: Text("loading",style:TextStyle(fontSize: 11)),
      ),
      Visibility(
        visible: message!= "",
        child: Padding(
          padding:const EdgeInsets.only(top:8),
          child: Text(message,style:const TextStyle(fontSize: 14,color: Colors.white)),
        ),
      ),
    ],
  );
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key,{String? message}) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        loadPreLoader(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Please Wait ",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                        (message)!=null?Visibility(
                          visible:message != null,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                message,
                                style: const TextStyle(color: Colors.green),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ):const SizedBox(),
                      ]),
                    )
                  ]));
        });
  }
}

final GlobalKey<State> preloaderWindowKey =  GlobalKey<State>();

Future<void> preloaderWindow(BuildContext context,{String? message}) async {
  try {
    Dialogs.showLoadingDialog(context, preloaderWindowKey,message: message??"");
  } catch (error) {}
}

Map<String, String> messages = {
"SERVER_ERROR" : 'Server Error',
"No_DATA" : 'No Data Found',
"ASCENDING":"Ascending",
"DESCENDING":"Descending",
"DASHBOARD":"Dashboard",
"SINGLE_ITEM":"Single Item",
};




class AppSettings{
  static Map<String,dynamic> api = {
    'DASHBOARD_GET': 'https://fakestoreapi.com/products',
    'DASHBOARD_SINGLE': 'https://fakestoreapi.com/products',
    'DASHBOARD_SORT': 'https://fakestoreapi.com/products',
  };

  static Future<String> callRemoteGETAPI(String? url) async {
    try {
      Map<String,String> customHeaders = {};
      http.Response response;
      response = await http.get(Uri.parse(url!),headers: customHeaders);
      if (response.statusCode == 200) {
        return response.body;
      }
      else {
        return RestResponse.failed.toString();
      }
    } catch (e) {
      return RestResponse.failed.toString();
    }
  }

  static const singleText = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white);
  static const appBarText = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white,decoration: TextDecoration.underline);
  static const headingText = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey);
  static const bodyText = TextStyle(fontSize: 15,   color: Colors.black);
  static const countText = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue);
  static const ratingText = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.green);
  static const mrpText = TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red);
}

Widget dashboardUi(context, ModelDashBoard modelDashSingleCollection, type){
  return Container(
      padding:const EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width*.99,
      child:InkWell(
        onTap: (){
          if(type == "DashBoard"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SingleView(id:modelDashSingleCollection.id,)));
          }
        },
        child:Card(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*.20,
                        child:  Text("(${modelDashSingleCollection.id})"" Title",style: AppSettings.headingText),
                      ),
                      const SizedBox(width: 10),
                      const Text(":"),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*.65,
                        child: Text(modelDashSingleCollection.title,overflow: TextOverflow.visible,style: AppSettings.bodyText),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width*.20,
                        child: const Text("Category",style: AppSettings.headingText),
                      ),
                      const SizedBox(width: 10),
                      const Text(":"),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*.65,
                        child: Text(modelDashSingleCollection.category,overflow: TextOverflow.visible,style: AppSettings.bodyText),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      (modelDashSingleCollection.image!="")?Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Container(
                          height: MediaQuery.of(context).size.height*.12,
                          width:  MediaQuery.of(context).size.width*.25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 1,color: Colors.grey.shade500,),
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            image: DecorationImage(
                              image: NetworkImage(modelDashSingleCollection.image), // NetworkImage(,upComingAppointment[1].doctorImage),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ):const SizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width*.64,
                            child: Text(modelDashSingleCollection.description,overflow: TextOverflow.visible,style: AppSettings.bodyText),
                          ),
                          const SizedBox(height: 2)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    color: Colors.green.shade200,
                    padding: const EdgeInsets.all(3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              child: Text("MRP",style: AppSettings.headingText),
                            ),
                            const SizedBox(width: 3),
                            const Text(":"),
                            const SizedBox(width: 3),
                            SizedBox(
                              child: Text(modelDashSingleCollection.price.toString(),overflow: TextOverflow.visible,style: AppSettings.mrpText),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        /// rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              child: Text("Rating",style: AppSettings.headingText),
                            ),
                            const SizedBox(width: 3),
                            const Text(":"),
                            const SizedBox(width: 3),
                            SizedBox(
                              child: Text(modelDashSingleCollection.ratingList.rate.toString(),overflow: TextOverflow.visible,style: AppSettings.ratingText),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                        /// cont
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              child: Text("Count",style: AppSettings.headingText),
                            ),
                            const SizedBox(width: 3),
                            const Text(":"),
                            const SizedBox(width: 3),
                            SizedBox(
                              child: Text(modelDashSingleCollection.ratingList.count.toString(),overflow: TextOverflow.visible,style: AppSettings.countText),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
        ),
      )
  );
}