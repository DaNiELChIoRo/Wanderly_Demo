class Candidate {
  int? id;
  String? full_name;
  String? image;
  String? photo;
  String? first_name;
  String? last_name;
  String? firstname;
  String? lastname;

  Candidate(
      {this.id,
      this.full_name,
      this.image,
      this.photo,
      this.first_name,
      this.last_name,
      this.firstname,
      this.lastname});

  factory Candidate.fromJSON(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'],
      full_name: json['full_name'],
      image: json['image'],
      photo: json['photo'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
