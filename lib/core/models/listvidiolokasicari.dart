class Listvidiocari {
  final int id;
  final String namalokasi;
  final String vidio;

  Listvidiocari({this.id, this.namalokasi, this.vidio});

  factory Listvidiocari.fromJson(Map<String, dynamic> json) {
    return new Listvidiocari(
      id: json['id'],
      namalokasi: json['namalokasi'],
      
      vidio: json['vidio'],
    );
  }
}
