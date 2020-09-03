class TCardModel {
  int id;
  String task;
  String columnId;
  int views;
  int likes;

  TCardModel({


    this.id,
    this.task, this.columnId, this.views, this.likes}) {
    assert(id != null);
    assert(columnId != null);
    if (this.task == null) this.task = "Card ${this.id}";
  }

  factory TCardModel.fromJSON(Map<String, dynamic> data) {
    return TCardModel(
      id: data["id"],
      task: data["task"],
      columnId: data["columnId"],
      likes: data["likes"],
      views: data["views"],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id": this.id,
      "task": this.task,
      "columnId": this.columnId,
      "likes": this.likes,
      "views": this.views,
    };
  }

  static List<TCardModel> parseJSONList(List<dynamic> json) {
    List<TCardModel> list = [];
    print(json);
    if(json==null) return list;
    for (var j in json) {
      list.add(TCardModel.fromJSON(j));
    }
    return list;
  }

  static List<Map<String, dynamic>> toJSONList(List<TCardModel> list) {
    List<Map<String,dynamic>> jsonList = [];

    for(var l in list){
      jsonList.add(l.toJSON());
    }
    return jsonList;
  }
}
