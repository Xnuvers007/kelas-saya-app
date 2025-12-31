import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

// --- IMPORT FILE QUIZ DISINI ---
import 'quiz_page.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kelas Saya',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Warna background abu muda
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD32F2F), // Merah sesuai gambar
          foregroundColor: Colors.white,
        ),
      ),
      home: const HalamanKelasSaya(),
    );
  }
}

// --- Model Data Sederhana ---
class Pertemuan {
  final String labelPertemuan; // Contoh: "Pertemuan 1"
  final String judul;          // Contoh: "Pancasila dan Nilai Bangsa"
  final bool isCompleted;      // Status centang hijau
  final String pdfAssetPath;   // Path ke file PDF (assets/pdfs/...)

  Pertemuan({
    required this.labelPertemuan,
    required this.judul,
    required this.isCompleted,
    required this.pdfAssetPath,
  });
}

// --- Halaman Utama (Sesuai Gambar) ---
class HalamanKelasSaya extends StatefulWidget {
  const HalamanKelasSaya({super.key});

  @override
  State<HalamanKelasSaya> createState() => _HalamanKelasSayaState();
}

class _HalamanKelasSayaState extends State<HalamanKelasSaya> {
  int _selectedIndex = 1; // Default ke tab "Kelas Saya"

  // Data Dummy 
  final List<Pertemuan> listKewarganegaraan = [
    Pertemuan(labelPertemuan: "Pertemuan 1", judul: "Pancasila dan Nilai Bangsa", isCompleted: true, pdfAssetPath: "assets/pdfs/materi1.pdf"),
    Pertemuan(labelPertemuan: "Pertemuan 2", judul: "Hak dan Kewajiban Warga Negara", isCompleted: false, pdfAssetPath: "assets/pdfs/materi1.pdf"),
    Pertemuan(labelPertemuan: "Pertemuan 3", judul: "Demokrasi di Indonesia", isCompleted: false, pdfAssetPath: "assets/pdfs/materi1.pdf"),
  ];

  final List<Pertemuan> listSistemOperasi = [
    Pertemuan(labelPertemuan: "Pertemuan 1", judul: "Pengantar Sistem Operasi", isCompleted: true, pdfAssetPath: "assets/pdfs/materi1.pdf"),
    Pertemuan(labelPertemuan: "Pertemuan 2", judul: "Manajemen Proses", isCompleted: false, pdfAssetPath: "assets/pdfs/materi1.pdf"),
    Pertemuan(labelPertemuan: "Pertemuan 3", judul: "Manajemen Memori", isCompleted: false, pdfAssetPath: "assets/pdfs/materi1.pdf"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelas Saya", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: KEWARGANEGARAAN
            _buildSectionHeader("KEWARGANEGARAAN"),
            ...listKewarganegaraan.map((data) => _buildMeetingCard(context, data)),

            const SizedBox(height: 20),

            // Section 2: SISTEM OPERASI
            _buildSectionHeader("SISTEM OPERASI"),
            ...listSistemOperasi.map((data) => _buildMeetingCard(context, data)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A233A), // Warna biru gelap footer
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Kelas Saya'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
        ],
      ),
    );
  }

  // Widget Header Text
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Widget Card Pertemuan
  Widget _buildMeetingCard(BuildContext context, Pertemuan data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Navigasi ke Halaman Detail
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HalamanDetailMateri(data: data)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 1. Tag Biru
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.labelPertemuan,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 15),

              // 2. Judul & Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.judul,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Materi & Quiz",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),

              // 3. Icon Checkmark
              Icon(
                data.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: data.isCompleted ? Colors.green : Colors.grey,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Halaman Detail (Materi PDF & Quiz) ---
class HalamanDetailMateri extends StatefulWidget {
  final Pertemuan data;
  const HalamanDetailMateri({super.key, required this.data});

  @override
  State<HalamanDetailMateri> createState() => _HalamanDetailMateriState();
}

class _HalamanDetailMateriState extends State<HalamanDetailMateri> {
  String localPath = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Gunakan nama file asli agar tidak bentrok
    String fileName = widget.data.pdfAssetPath.split('/').last;

    fromAsset(widget.data.pdfAssetPath, fileName).then((f) {
      if (!mounted) return; 
      
      setState(() {
        localPath = f.path;
        isLoading = false;
      });
    });
  }

  // Fungsi helper load asset
  Future<File> fromAsset(String asset, String filename) async {
    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      return file;
    } catch (e) {
      throw Exception("Error parsing asset file!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.data.judul)),
      body: Column(
        children: [
          // Area PDF Viewer
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : PDFView(
                    filePath: localPath,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                  ),
          ),

          // Area Tombol Quiz (Sticky di bawah)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, -3))],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // --- NAVIGASI KE HALAMAN QUIZ DISINI ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HalamanQuiz(judulMateri: widget.data.judul),
                    ),
                  );
                },
                child: const Text("Mulai Quiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
