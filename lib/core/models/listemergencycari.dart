class Listemergencycari {
  final int id;
  final String iduser;
  final String nama;
  final String laporan;
  final String foto;

  Listemergencycari({this.id,this.iduser,this.nama, this.laporan, this.foto});

  factory Listemergencycari.fromJson(Map<String, dynamic> json) {
    return new Listemergencycari(
      id: json['id'],
      nama: json['nama'],
      laporan:json['laporan'],
      foto: json['foto'],
    );
  }
}
