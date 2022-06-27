class Listimagecari {
  final int id;
  final String namalokasi;
  final String vidio;

  Listimagecari({this.id, this.namalokasi, this.vidio});

  factory Listimagecari.fromJson(Map<String, dynamic> json) {
    return new Listimagecari(
      id: json['id'],
      namalokasi: json['namalokasi'],
      
     // vidio: json['vidio'],
    );
  }
}
