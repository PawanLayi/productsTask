class ModelDashBoard{
  int id = 0;
  String title = "";
  dynamic price = 0;
  String description ="";
  String category ="";
  String image ="";
  ModelDashBoardRating ratingList = ModelDashBoardRating();
  ModelDashBoard();

  factory ModelDashBoard.fromJson(Map<String,dynamic>json){
    ModelDashBoard mdb = ModelDashBoard();
    mdb.id = json['id']??0;
    mdb.title = json['title']??"";
    mdb.price = json['price']??0;
    mdb.description = json['description']??"";
    mdb.category = json['category']??"";
    mdb.image = json['image']??"";
    mdb.ratingList = (json["rating"]??{}).length>0?ModelDashBoardRating.fromJson(json['rating']):ModelDashBoardRating();

    return mdb;
  }
}

class ModelDashBoardRating{
  dynamic rate = 0;
  int count = 0;

  ModelDashBoardRating();

  factory ModelDashBoardRating.fromJson(Map<String,dynamic>json){
    ModelDashBoardRating mdbr = ModelDashBoardRating();

    mdbr.rate = json['rate']??0;
    mdbr.count = json['count']??0;

    return mdbr;
  }

}