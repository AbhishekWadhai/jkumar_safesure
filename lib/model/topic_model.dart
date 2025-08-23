class Topic {
  String? sId;
  String? topicTypes;
  int? iV;

  Topic({this.sId, this.topicTypes, this.iV});

  Topic.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    topicTypes = json['topicTypes'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['topicTypes'] = this.topicTypes;
    data['__v'] = this.iV;
    return data;
  }
}
