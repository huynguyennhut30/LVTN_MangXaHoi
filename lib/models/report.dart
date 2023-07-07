import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  late String idPost;
  late String idUser;
  late String idReport;
  late String time;
  late String description;
  late String photoUrlPost;

  Report({
    required this.idPost,
    required this.idUser,
    required this.idReport,
    required this.time,
    required this.description,
    required this.photoUrlPost,
  });
  static Report fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Report(
      description: snapshot["description"],
      idPost: snapshot["idPost"],
      idUser: snapshot["idUser"],
      time: snapshot["time"],
      photoUrlPost: snapshot["photoUrlPost"],
      idReport: snapshot["idReport"],
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "idPost": idPost,
        "idUser": idUser,
        "idReport": idReport,
        "time": time,
        "photoUrlPost": photoUrlPost,
      };
  Report.fromJson(Map<String, dynamic> json) {
    description = json['description'] ?? '';
    idPost = json['idPost'] ?? '';
    idUser = json['idUser'] ?? '';
    idReport = json['idReport'] ?? '';
    time = json['time'] ?? '';
    photoUrlPost = json['photoUrlPost'] ?? '';
  }
}
