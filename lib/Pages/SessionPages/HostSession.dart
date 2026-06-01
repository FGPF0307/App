import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HostSessionPage extends StatefulWidget {
  const HostSessionPage({super.key});

  @override
  State<HostSessionPage> createState() => _HostSessionPageState();
}

class _HostSessionPageState extends State<HostSessionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  int _selectedDay = DateTime.now().day;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  int _startHour = 15; 
  int _startMinute = 0; 
  
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int _maxParticipants = 6;
  int _sportIndex = 0;
  bool _isLoading = false; 
  
  final List<String> _sports = [
    'Running', 'Basketball', 'Tennis', 'Yoga', 
    'Cycling', 'Pingpong', 'Badminton', 'Swimming',
    'Football', 'Calisthenics', 'Pilates', 'Padel'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int _getMaxDays(int month, int year) {
    return DateTime(year, month + 1, 0).day;
  }

  // Fungsi untuk memastikan tanggal tidak melebihi batas maksimum bulan saat berganti bulan/tahun
  void _clampDay() {
    int maxDays = _getMaxDays(_selectedMonth, _selectedYear);
    if (_selectedDay > maxDays) {
      _selectedDay = maxDays;
    }
  }

  Future<void> _launchSession() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session Title tidak boleh kosong!')),
      );
      return;
    }

    setState(() {
      _isLoading = true; 
    });

    try {
      // 1Format date dan start at(dd/mm/yyyy & HH:MM)
      final formattedDate = '${_selectedDay.toString().padLeft(2, '0')}/${_selectedMonth.toString().padLeft(2, '0')}/$_selectedYear';
      final formattedTime = '${_startHour.toString().padLeft(2, '0')}:${_startMinute.toString().padLeft(2, '0')}';

      // ZInsert ke Supabase
      await Supabase.instance.client.from('HostNewSessions').insert({
        'Title': _titleController.text.trim(),
        'Sport_Category': _sports[_sportIndex],
        'Location': _locationController.text.trim(),
        'Date': formattedDate,
        'Start_Time': formattedTime, 
        'Duration': _durationController.text.trim(),
        'Max_Participant': _maxParticipants, 
        'Notes': _notesController.text.trim(),
      });

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session berhasil dibuat! 🎉'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1E2D6), 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.black),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'HOST SESSION',
                    style: TextStyle(fontFamily: 'BebasNeue', fontSize: 32, letterSpacing: 1.0),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Image
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, size: 60, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text('Add Image', style: TextStyle(fontFamily: 'JetBrainsMono', color: Colors.grey[400], fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Form
              _buildLabel('Session Title'),
              _buildTextField(controller: _titleController),

              _buildLabel('Sport Category'),
              _buildSportCategorySelector(), 

              _buildLabel('Location'),
              _buildTextField(controller: _locationController), 

              // date & Start At
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Date'),
                          Expanded(
                            child: _buildDateSelector(), // <-- Widget baru Spinner Tanggal
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Start At'),
                          Expanded(
                            child: _buildTimeSelector(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Center(
                child: Column(
                  children: [
                    _buildLabel('Durations(mins)'),
                    _buildTextField(width: 150, controller: _durationController),
                  ],
                ),
              ),

              _buildLabel('Max Participants'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_maxParticipants > 1) setState(() => _maxParticipants--);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        child: const Icon(Icons.remove, color: Color(0xFF00342B)),
                      ),
                    ),
                    Text(_maxParticipants.toString().padLeft(2, '0'), style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 32)),
                    GestureDetector(
                      onTap: () => setState(() => _maxParticipants++),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(4)),
                        child: const Icon(Icons.add, color: Color(0xFF00342B)),
                      ),
                    ),
                  ],
                ),
              ),

              _buildLabel('Notes'),
              _buildTextField(maxLines: 5, controller: _notesController),
              
              const SizedBox(height: 30),

              // Launch Button
              GestureDetector(
                onTap: _isLoading ? null : _launchSession, 
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: _isLoading ? Colors.grey : const Color(0xFF1A1A1A), 
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Center(
                    child: _isLoading 
                        ? const SizedBox(
                            height: 24, 
                            width: 24, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                          )
                        : const Text('LAUNCH SESSION', style: TextStyle(fontFamily: 'BebasNeue', color: Colors.white, fontSize: 24, letterSpacing: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Date dengan Spinner untuk Day, Month, Year
  Widget _buildDateSelector() {
    int maxDays = _getMaxDays(_selectedMonth, _selectedYear);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SPINNER HARI (dd)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => _selectedDay = (_selectedDay % maxDays) + 1),
                child: const Icon(Icons.arrow_drop_up, size: 24, color: Color(0xFF00342B)),
              ),
              Text(_selectedDay.toString().padLeft(2, '0'), style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 20)),
              GestureDetector(
                onTap: () => setState(() => _selectedDay = (_selectedDay - 1) < 1 ? maxDays : (_selectedDay - 1)),
                child: const Icon(Icons.arrow_drop_down, size: 24, color: Color(0xFF00342B)),
              ),
            ],
          ),
          const Text('/', style: TextStyle(fontFamily: 'BebasNeue', fontSize: 20, color: Colors.grey)),

          // SPINNER BULAN (mm)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _selectedMonth = (_selectedMonth % 12) + 1;
                  _clampDay(); // Jaga agar tanggal tidak overflow
                }),
                child: const Icon(Icons.arrow_drop_up, size: 24, color: Color(0xFF00342B)),
              ),
              Text(_selectedMonth.toString().padLeft(2, '0'), style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 20)),
              GestureDetector(
                onTap: () => setState(() {
                  _selectedMonth = (_selectedMonth - 1) < 1 ? 12 : (_selectedMonth - 1);
                  _clampDay();
                }),
                child: const Icon(Icons.arrow_drop_down, size: 24, color: Color(0xFF00342B)),
              ),
            ],
          ),
          const Text('/', style: TextStyle(fontFamily: 'BebasNeue', fontSize: 20, color: Colors.grey)),

          // SPINNER TAHUN (yyyy)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _selectedYear++;
                  _clampDay();
                }),
                child: const Icon(Icons.arrow_drop_up, size: 24, color: Color(0xFF00342B)),
              ),
              Text(_selectedYear.toString(), style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 20)),
              GestureDetector(
                onTap: () => setState(() {
                  if (_selectedYear > 2000) _selectedYear--;
                  _clampDay();
                }),
                child: const Icon(Icons.arrow_drop_down, size: 24, color: Color(0xFF00342B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // WWiudget Spinner Jam dan Menit untuk Start At (HH:MM)
  Widget _buildTimeSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => _startHour = (_startHour + 1) % 24),
                child: const Icon(Icons.arrow_drop_up, size: 28, color: Color(0xFF00342B)),
              ),
              Text(_startHour.toString().padLeft(2, '0'), style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 24)),
              GestureDetector(
                onTap: () => setState(() => _startHour = (_startHour - 1) < 0 ? 23 : (_startHour - 1)),
                child: const Icon(Icons.arrow_drop_down, size: 28, color: Color(0xFF00342B)),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(':', style: TextStyle(fontFamily: 'BebasNeue', fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => setState(() => _startMinute = (_startMinute + 5) % 60), 
                child: const Icon(Icons.arrow_drop_up, size: 28, color: Color(0xFF00342B)),
              ),
              Text(_startMinute.toString().padLeft(2, '0'), style: const TextStyle(fontFamily: 'BebasNeue', fontSize: 24)),
              GestureDetector(
                onTap: () => setState(() => _startMinute = (_startMinute - 5) < 0 ? 55 : (_startMinute - 5)),
                child: const Icon(Icons.arrow_drop_down, size: 28, color: Color(0xFF00342B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Kategori Olahraga dengan Selector (Spinner)
  Widget _buildSportCategorySelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (_sportIndex > 0) {
                  _sportIndex--;
                } else {
                  _sportIndex = _sports.length - 1;
                }
              });
            },
            child: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF00342B)),
          ),
          Text(
            _sports[_sportIndex],
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00342B),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (_sportIndex < _sports.length - 1) {
                  _sportIndex++;
                } else {
                  _sportIndex = 0;
                }
              });
            },
            child: const Icon(Icons.arrow_forward_ios, size: 18, color: Color(0xFF00342B)),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(text, style: const TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildTextField({int maxLines = 1, double? width, TextEditingController? controller}) {
    return Container(
      width: width ?? double.infinity,
      alignment: Alignment.center, 
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: controller, 
        maxLines: maxLines,
        decoration: const InputDecoration(
          border: InputBorder.none, 
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14),
      ),
    );
  }
}