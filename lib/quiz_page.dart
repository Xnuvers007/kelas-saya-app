import 'package:flutter/material.dart';

class HalamanQuiz extends StatefulWidget {
  final String judulMateri;
  const HalamanQuiz({super.key, required this.judulMateri});

  @override
  State<HalamanQuiz> createState() => _HalamanQuizState();
}

class _HalamanQuizState extends State<HalamanQuiz> {
  // Variabel untuk menampung soal yang sedang aktif
  List<Map<String, Object>> _questions = [];

  // --- DATABASE SOAL ---
  
  // 1. Soal untuk Materi Pancasila
  final List<Map<String, Object>> _soalPancasila = [
    {
      'question': 'Pancasila terdiri dari berapa sila?',
      'answers': [
        {'text': '3 Sila', 'score': 0},
        {'text': '4 Sila', 'score': 0},
        {'text': '5 Sila', 'score': 1},
        {'text': '6 Sila', 'score': 0},
      ],
    },
    {
      'question': 'Sila pertama berbunyi?',
      'answers': [
        {'text': 'Kemanusiaan yang adil', 'score': 0},
        {'text': 'Ketuhanan Yang Maha Esa', 'score': 1},
        {'text': 'Persatuan Indonesia', 'score': 0},
        {'text': 'Keadilan Sosial', 'score': 0},
      ],
    },
  ];

  // 2. Soal untuk Materi Hak dan Kewajiban
  final List<Map<String, Object>> _soalHakKewajiban = [
    {
      'question': 'Membayar pajak adalah contoh dari?',
      'answers': [
        {'text': 'Hak Warga Negara', 'score': 0},
        {'text': 'Kewajiban Warga Negara', 'score': 1},
        {'text': 'Hukuman', 'score': 0},
        {'text': 'Hadiah', 'score': 0},
      ],
    },
    {
      'question': 'Mendapatkan pendidikan adalah contoh dari?',
      'answers': [
        {'text': 'Hak Warga Negara', 'score': 1},
        {'text': 'Kewajiban Warga Negara', 'score': 0},
        {'text': 'Paksaan', 'score': 0},
        {'text': 'Larangan', 'score': 0},
      ],
    },
  ];

  // 3. Soal untuk Materi Sistem Operasi
  final List<Map<String, Object>> _soalSistemOperasi = [
    {
      'question': 'Manakah yang termasuk Sistem Operasi?',
      'answers': [
        {'text': 'Microsoft Word', 'score': 0},
        {'text': 'Windows 10', 'score': 1},
        {'text': 'Google Chrome', 'score': 0},
        {'text': 'Adobe Photoshop', 'score': 0},
      ],
    },
    {
      'question': 'Fungsi utama OS adalah?',
      'answers': [
        {'text': 'Mengedit Video', 'score': 0},
        {'text': 'Menjembatani Hardware & User', 'score': 1},
        {'text': 'Membuat Presentasi', 'score': 0},
        {'text': 'Bermain Game', 'score': 0},
      ],
    },
  ];

  // Soal Default jika materi belum ada soalnya
  final List<Map<String, Object>> _soalUmum = [
    {
      'question': 'Materi ini belum memiliki soal khusus.',
      'answers': [
        {'text': 'Kembali', 'score': 0},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  // LOGIKA: Pilih soal berdasarkan Judul Materi
  void _loadQuestions() {
    if (widget.judulMateri.contains("Pancasila")) {
      _questions = _soalPancasila;
    } else if (widget.judulMateri.contains("Hak dan Kewajiban")) {
      _questions = _soalHakKewajiban;
    } else if (widget.judulMateri.contains("Sistem Operasi") || widget.judulMateri.contains("Manajemen")) {
      _questions = _soalSistemOperasi;
    } else {
      _questions = _soalUmum;
    }
  }

  int _questionIndex = 0;
  int _totalScore = 0;
  bool _isFinished = false;

  void _answerQuestion(int score) {
    setState(() {
      _totalScore += score;
      if (_questionIndex < _questions.length - 1) {
        _questionIndex++;
      } else {
        _isFinished = true;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
      _isFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz: ${widget.judulMateri}", style: const TextStyle(fontSize: 16)),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _questions.isEmpty
            ? const Center(child: Text("Soal tidak ditemukan"))
            : (_isFinished ? _buildResult() : _buildQuiz()),
      ),
    );
  }

  Widget _buildQuiz() {
    // Cek jika soal dummy
    if (_questions[0]['question'] == 'Materi ini belum memiliki soal khusus.') {
       return Center(child: Text(_questions[0]['question'] as String));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Soal ${_questionIndex + 1}/${_questions.length}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
          ),
          child: Text(
            _questions[_questionIndex]['question'] as String,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        ...(_questions[_questionIndex]['answers'] as List<Map<String, Object>>).map((answer) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => _answerQuestion(answer['score'] as int),
              child: Text(answer['text'] as String, style: const TextStyle(fontSize: 16)),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: Colors.orange),
          const SizedBox(height: 20),
          const Text("Quiz Selesai!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Skor Kamu: $_totalScore / ${_questions.length}", style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _resetQuiz,
            child: const Text("Ulangi Quiz"),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kembali ke Materi"),
          ),
        ],
      ),
    );
  }
}
