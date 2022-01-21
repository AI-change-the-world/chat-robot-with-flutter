class Questions {
  int? code;
  List<Data>? data;
  String? message;

  Questions({this.code, this.data, this.message});

  Questions.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? answer;
  String? comment;
  bool? isPrimary;
  int? qid;

  Data({this.answer, this.comment, this.qid, this.isPrimary});

  Data.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    comment = json['comment'];
    isPrimary = json['isPrimary'];
    qid = json['qid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['comment'] = this.comment;
    data['qid'] = this.qid;
    data['isPrimary'] = this.isPrimary;
    return data;
  }
}
