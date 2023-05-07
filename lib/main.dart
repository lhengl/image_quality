import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Testing image qualities'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//path=/storage/emulated/0/Download/yoav-aziz--yqiYu9xRBU-unsplash.jpg
class _MyHomePageState extends State<MyHomePage> {
  static const url =
      'https://unsplash.com/photos/-yqiYu9xRBU/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8M3x8Zml0bmVzc3xlbnwwfHx8fDE2ODM0MDkxMjE&force=true&w=1920';

  File? file;
  Uint8List? bytes;
  File? compressedFile;

  @override
  Widget build(BuildContext context) {
    // final downloadPath = downloadsDir?.path;
    // debugPrint('downloadPath = $downloadPath');
    // final file = File('/storage/emulated/0/Download/yoav-aziz--yqiYu9xRBU-unsplash.jpg');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        cacheExtent: 9999,
        children: <Widget>[
          const ListTile(
            title: Text('Image.network:'),
          ),
          Image.network(
            url,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          const ListTile(
            title: Text('Image.asset:'),
          ),
          Image.asset(
            'assets/yoav-aziz--yqiYu9xRBU-unsplash.jpg',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
          ListTile(
            title: const Text('Image.file:'),
            trailing: _pickFile(),
          ),
          file == null
              ? const Icon(Icons.image, size: 300)
              : Image.file(
                  file!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
          ListTile(
            title: const Text('Image.memory:'),
            trailing: _pickFile(),
          ),
          bytes == null
              ? const Icon(Icons.image, size: 300)
              : Image.memory(
                  bytes!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
          ListTile(
            title: const Text('Compressed Image:'),
            trailing: _compressFile(),
          ),
          compressedFile == null
              ? const Icon(Icons.image, size: 300)
              : Image.file(
                  compressedFile!,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
        ],
      ),
    );
  }

  Widget _pickFile() {
    return TextButton(
      onPressed: () async {
        debugPrint('_pickFile started');
        final ImagePicker picker = ImagePicker();
        final XFile? file = await picker.pickImage(
          source: ImageSource.gallery,
        );
        final pickedPath = file?.path;
        debugPrint('_pickFile: pickedPath=$pickedPath');
        this.file = pickedPath == null ? null : File(pickedPath);
        bytes = await file?.readAsBytes();
        setState(() {});
        debugPrint('_pickFile done');
      },
      child: const Text('Pick Image'),
    );
  }

  Widget _compressFile() {
    return TextButton(
      onPressed: () async {
        debugPrint('_compressFile started');
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1200,
          maxHeight: 1200,
          imageQuality: 80,
        );

        final pickedPath = image?.path;
        debugPrint('_compressFile: pickedPath=$pickedPath');
        compressedFile = pickedPath == null ? null : File(pickedPath);

        setState(() {});
        debugPrint('_compressFile done');
      },
      child: const Text('Compress Image'),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
