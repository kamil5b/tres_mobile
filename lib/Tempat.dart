

import 'dart:convert';

import 'API.dart';

class Tempat {
  String id;
  String nama;
  String deskripsi;
  int kapasitas;
  String fasilitas;

  Tempat(
      this.id,
      this.nama,
      this.deskripsi,
      this.kapasitas,
      this.fasilitas,
      );

}
Future<List<Tempat>> getAllTempat() async{
  var res = await Network().getData('/place/view');
  var body = jsonDecode(res.body);
  List<Tempat> tempat = [];
  if(body['success']){
    var datas = body['data'];
    datas.forEach( (data) =>
        tempat.add(
            Tempat(
                data['_id'],
                data['nama'],
                data['deskripsi'],
                data['kapasitas'],
                data['fasilitas']
            )
        )
    );
  }
  return tempat;
}