import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const ComicSpoilerApp());
}

class ComicSpoilerApp extends StatelessWidget {
  const ComicSpoilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comic Spoiler Detector',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? _webImageBytes;
  File? _imageFile;
  Map<String, dynamic>? _result;
  bool _loading = false;

  Future<void> pickImage() async {
    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _webImageBytes = result.files.single.bytes;
          _imageFile = null;
          _result = null;
        });
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _webImageBytes = null;
          _result = null;
        });
      }
    }
  }

  Future<void> analyzeImage() async {
    if (_webImageBytes == null && _imageFile == null) return;

    setState(() {
      _loading = true;
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'http://192.168.0.154:5000/analyze',
        ), // Replace with your backend IP
      );

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            _webImageBytes!,
            filename: 'upload.jpg',
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        setState(() {
          _result = json.decode(response.body);
        });
      } else {
        setState(() {
          _result = {'error': 'Server error ${response.statusCode}'};
        });
      }
    } catch (e) {
      setState(() {
        _result = {'error': e.toString()};
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget buildImagePreview() {
    if (kIsWeb && _webImageBytes != null) {
      return Image.memory(_webImageBytes!, height: 200);
    } else if (!kIsWeb && _imageFile != null) {
      return Image.file(_imageFile!, height: 200);
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildResult() {
    if (_result == null) return const SizedBox.shrink();

    if (_result!.containsKey('error')) {
      return Text(_result!['error'], style: const TextStyle(color: Colors.red));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          '📝 Extracted Text:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(_result!['extracted_text'] ?? 'N/A'),
        const SizedBox(height: 16),

        const Text(
          '🧠 Generated Caption:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(_result!['caption'] ?? 'N/A'),
        const SizedBox(height: 16),

        const Text(
          '🧩 Predicted Genre:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(_result!['genre'] ?? 'N/A'),
        const SizedBox(height: 16),

        const Text(
          '🧍 Characters Detected:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text('${_result!['character_count'] ?? 'N/A'}'),
        const SizedBox(height: 16),

        const Text(
          '🚫 Spoiler Prediction:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(_result!['spoiler_result'] ?? 'N/A'),
      ],
    );
  }

  void reset() {
    setState(() {
      _webImageBytes = null;
      _imageFile = null;
      _result = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comic Spoiler Detector'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
              ),
              const SizedBox(height: 20),
              buildImagePreview(),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed:
                    (_webImageBytes != null || _imageFile != null) && !_loading
                    ? analyzeImage
                    : null,
                icon: const Icon(Icons.check),
                label: const Text('Analyze'),
              ),

              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(height: 20),
              buildResult(),
              const SizedBox(height: 30),
              if (_result != null)
                ElevatedButton.icon(
                  onPressed: reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try another panel'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
