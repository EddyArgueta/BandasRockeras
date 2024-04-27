import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bandasrockeras/Pantallas/pantalla_listado.dart';

class PantallaCreaBandas extends StatefulWidget {
  const PantallaCreaBandas({Key? key}) : super(key: key);

  @override
  _PantallaCreaBandasState createState() => _PantallaCreaBandasState();
}

class _PantallaCreaBandasState extends State<PantallaCreaBandas> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController albumController = TextEditingController();
  TextEditingController yearController = TextEditingController();

   Future<String?> subirFoto(String path) async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final imagen = File(path);
    final referenciaFotoPerfil = storageRef.child("ImagenesDeBandas/mi_foto.jpg");
    final uploadTask = await referenciaFotoPerfil.putFile(imagen);
    final url = await uploadTask.ref.getDownloadURL();
    return url;
  } catch (e) {
    print("Error al subir la foto: $e");
    return null; 
  }
}


      void _guardarBanda(BuildContext context) async {
      String nombre = nombreController.text;
      String album = albumController.text;
      String year = yearController.text;

      FirebaseFirestore.instance.collection('colecciones').add({
        'NombreBanda': nombre,
        'NombreAlbum': album,
        'AñoLanzamiento': year,
        'CantidadVotos': 0,
      }).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PantallaListadoBandas()),
        );
      }).catchError((error) => print("Error al añadir banda: $error"));
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Banda de Rock'),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nombreController,
                maxLength: 30,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Banda',
                  prefixIcon: Icon(Icons.group_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: albumController,
                maxLength: 30,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Album',
                  prefixIcon: Icon(Icons.queue_music),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: yearController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año de Lanzamiento',
                  prefixIcon: Icon(Icons.calendar_month_rounded),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();

                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);

                    if (image == null) return;

                    final url = await subirFoto(image.path);

                    print(url);
                    // image.path
                  },
                  child: const Text('Subir foto de Banda')),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _guardarBanda(context),
                child: const Text('Guardar Banda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
