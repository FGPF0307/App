import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fitarena/Pages/SessionPages/session_models.dart';

// =====================================================================
// Palet warna bersama untuk seluruh alur Host Session
// =====================================================================
const Color _cream = Color(0xFFE1E2D6);
const Color _darkGreen = Color(0xFF00342B);
const Color _lightGreen = Color(0xFFCFE99F);
const Color _black = Color(0xFF111111);

// =====================================================================
// LANGKAH 1 — PICK YOUR CATEGORY
// =====================================================================
class HostCategoryPage extends StatefulWidget {
  const HostCategoryPage({super.key});

  @override
  State<HostCategoryPage> createState() => _HostCategoryPageState();
}

class _HostCategoryPageState extends State<HostCategoryPage> {
  int? _selected;

  void _next() {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori dulu')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HostPhotoPage(category: hostCategories[_selected!]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            const _HostHeader(subtitle: 'PICK YOUR CATEGORY'),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.82,
                ),
                itemCount: hostCategories.length,
                itemBuilder: (context, i) {
                  final cat = hostCategories[i];
                  final selected = _selected == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected ? _darkGreen : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: selected ? _lightGreen : Colors.black,
                            offset: const Offset(5, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 56)),
                          const SizedBox(height: 16),
                          Text(
                            cat.name,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              letterSpacing: 1.0,
                              color: selected ? _lightGreen : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _StepButton(label: 'NEXT STEP', onTap: _next),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// LANGKAH 2 — SELECT PHOTO
// =====================================================================
class HostPhotoPage extends StatefulWidget {
  final SportCategory category;
  const HostPhotoPage({super.key, required this.category});

  @override
  State<HostPhotoPage> createState() => _HostPhotoPageState();
}

class _HostPhotoPageState extends State<HostPhotoPage> {
  int? _selected;

  void _next() {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih foto dulu')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HostDetailsPage(
          category: widget.category.name,
          photoUrl: widget.category.photos[_selected!],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photos = widget.category.photos;
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            const _HostHeader(subtitle: 'SELECT PHOTO'),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.9,
                ),
                itemCount: photos.length,
                itemBuilder: (context, i) {
                  final selected = _selected == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _RetryImage(
                            url: photos[i],
                            placeholder: ColoredBox(
                              color: const Color(0xFFDCDDDB),
                              child: Center(
                                child: Text(
                                  widget.category.emoji,
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                          ),
                          if (selected)
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: _darkGreen, width: 4),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _StepButton(label: 'NEXT STEP', onTap: _next),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// LANGKAH 3 — DETAIL SESSION (form)
// =====================================================================
class HostDetailsPage extends StatefulWidget {
  final String category;
  final String photoUrl;
  const HostDetailsPage({
    super.key,
    required this.category,
    required this.photoUrl,
  });

  @override
  State<HostDetailsPage> createState() => _HostDetailsPageState();
}

class _HostDetailsPageState extends State<HostDetailsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  int _selectedDay = DateTime.now().day;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  int _startHour = 15;
  int _startMinute = 0;

  int _maxParticipants = 6;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int _getMaxDays(int month, int year) => DateTime(year, month + 1, 0).day;

  void _clampDay() {
    final maxDays = _getMaxDays(_selectedMonth, _selectedYear);
    if (_selectedDay > maxDays) _selectedDay = maxDays;
  }

  Future<void> _finish() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session Title tidak boleh kosong!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Hitung waktu mulai & selesai
    final duration = int.tryParse(_durationController.text.trim()) ?? 60;
    final startTotal = _startHour * 60 + _startMinute;
    final endTotal = startTotal + duration;
    final startTime =
        '${_startHour.toString().padLeft(2, '0')}.${_startMinute.toString().padLeft(2, '0')}';
    final endTime =
        '${((endTotal ~/ 60) % 24).toString().padLeft(2, '0')}.${(endTotal % 60).toString().padLeft(2, '0')}';

    // Label hari ("Today" jika tanggal hari ini)
    final date = DateTime(_selectedYear, _selectedMonth, _selectedDay);
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    final dayLabel = isToday
        ? 'Today'
        : '${_selectedDay.toString().padLeft(2, '0')}/${_selectedMonth.toString().padLeft(2, '0')}';

    final location = _locationController.text.trim().isEmpty
        ? widget.category
        : _locationController.text.trim();

    final newSession = SessionData(
      title: _titleController.text.trim().toUpperCase(),
      location: location,
      day: dayLabel,
      startTime: startTime,
      endTime: endTime,
      image: widget.photoUrl,
      isNetwork: true,
      spotsFilled: 1,
      spotsTotal: _maxParticipants,
      rewardPoints: 200,
      xp: 300,
    );

    // Simpan ke Supabase (best-effort — tidak menghalangi alur lokal)
    try {
      final formattedDate =
          '${_selectedDay.toString().padLeft(2, '0')}/${_selectedMonth.toString().padLeft(2, '0')}/$_selectedYear';
      await Supabase.instance.client.from('HostNewSessions').insert({
        'Title': newSession.title,
        'Sport_Category': widget.category,
        'Location': location,
        'Date': formattedDate,
        'Start_Time': startTime,
        'Duration': _durationController.text.trim(),
        'Max_Participant': _maxParticipants,
        'Notes': _notesController.text.trim(),
      });
    } catch (_) {
      // Abaikan kegagalan jaringan; sesi tetap muncul di My Schedule.
    }

    if (!mounted) return;

    // Tambahkan ke My Schedule, lalu kembali ke halaman utama.
    SessionStore.instance.join(newSession);
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: _darkGreen,
        content: Text(
          'Session "${newSession.title}" berhasil dibuat! 🎉',
          style: const TextStyle(fontFamily: 'JetBrainsMono'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                          child: const Icon(Icons.arrow_back_ios_new,
                              size: 24, color: Colors.black),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'HOST SESSION',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontSize: 32,
                              letterSpacing: 1.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Foto + kategori terpilih
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _RetryImage(
                            url: widget.photoUrl,
                            placeholder: const ColoredBox(
                              color: Color(0xFFDCDDDB),
                              child: Center(
                                child: Icon(Icons.image,
                                    color: Colors.white, size: 40),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              color: _darkGreen,
                              child: Text(
                                widget.category,
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  color: _lightGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form
                    _buildLabel('Session Title'),
                    _buildTextField(controller: _titleController),

                    _buildLabel('Location'),
                    _buildTextField(controller: _locationController),

                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Date'),
                                Expanded(child: _buildDateSelector()),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Start At'),
                                Expanded(child: _buildTimeSelector()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Center(
                      child: Column(
                        children: [
                          _buildLabel('Durations (mins)'),
                          _buildTextField(
                              width: 150, controller: _durationController),
                        ],
                      ),
                    ),

                    _buildLabel('Max Participants'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (_maxParticipants > 1) {
                                setState(() => _maxParticipants--);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Icon(Icons.remove, color: _darkGreen),
                            ),
                          ),
                          Text(_maxParticipants.toString().padLeft(2, '0'),
                              style: const TextStyle(
                                  fontFamily: 'BebasNeue', fontSize: 32)),
                          GestureDetector(
                            onTap: () => setState(() => _maxParticipants++),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(4)),
                              child: const Icon(Icons.add, color: _darkGreen),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildLabel('Notes'),
                    _buildTextField(maxLines: 5, controller: _notesController),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
            _StepButton(
                label: 'FINISH', onTap: _finish, loading: _isLoading),
          ],
        ),
      ),
    );
  }

  // ── Widget Date (spinner dd/mm/yyyy) ──
  Widget _buildDateSelector() {
    final maxDays = _getMaxDays(_selectedMonth, _selectedYear);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _spinner(
            value: _selectedDay.toString().padLeft(2, '0'),
            onUp: () =>
                setState(() => _selectedDay = (_selectedDay % maxDays) + 1),
            onDown: () => setState(() =>
                _selectedDay = (_selectedDay - 1) < 1 ? maxDays : _selectedDay - 1),
          ),
          const Text('/',
              style: TextStyle(
                  fontFamily: 'BebasNeue', fontSize: 20, color: Colors.grey)),
          _spinner(
            value: _selectedMonth.toString().padLeft(2, '0'),
            onUp: () => setState(() {
              _selectedMonth = (_selectedMonth % 12) + 1;
              _clampDay();
            }),
            onDown: () => setState(() {
              _selectedMonth = (_selectedMonth - 1) < 1 ? 12 : _selectedMonth - 1;
              _clampDay();
            }),
          ),
          const Text('/',
              style: TextStyle(
                  fontFamily: 'BebasNeue', fontSize: 20, color: Colors.grey)),
          _spinner(
            value: _selectedYear.toString(),
            onUp: () => setState(() {
              _selectedYear++;
              _clampDay();
            }),
            onDown: () => setState(() {
              if (_selectedYear > 2000) _selectedYear--;
              _clampDay();
            }),
          ),
        ],
      ),
    );
  }

  // ── Widget Start At (spinner HH:MM) ──
  Widget _buildTimeSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _spinner(
            value: _startHour.toString().padLeft(2, '0'),
            big: true,
            onUp: () => setState(() => _startHour = (_startHour + 1) % 24),
            onDown: () => setState(
                () => _startHour = (_startHour - 1) < 0 ? 23 : _startHour - 1),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(':',
                style: TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
          _spinner(
            value: _startMinute.toString().padLeft(2, '0'),
            big: true,
            onUp: () => setState(() => _startMinute = (_startMinute + 5) % 60),
            onDown: () => setState(() =>
                _startMinute = (_startMinute - 5) < 0 ? 55 : _startMinute - 5),
          ),
        ],
      ),
    );
  }

  Widget _spinner({
    required String value,
    required VoidCallback onUp,
    required VoidCallback onDown,
    bool big = false,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onUp,
          child: Icon(Icons.arrow_drop_up,
              size: big ? 28 : 24, color: _darkGreen),
        ),
        Text(value,
            style: TextStyle(fontFamily: 'BebasNeue', fontSize: big ? 24 : 20)),
        GestureDetector(
          onTap: onDown,
          child: Icon(Icons.arrow_drop_down,
              size: big ? 28 : 24, color: _darkGreen),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(text,
          style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.bold,
              fontSize: 14)),
    );
  }

  Widget _buildTextField(
      {int maxLines = 1, double? width, TextEditingController? controller}) {
    return Container(
      width: width ?? double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14),
      ),
    );
  }
}

// =====================================================================
// Komponen bersama
// =====================================================================

/// Header "< HOST SESSION" + subjudul (PICK YOUR CATEGORY / SELECT PHOTO).
class _HostHeader extends StatelessWidget {
  final String subtitle;
  const _HostHeader({required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 24, color: Colors.black),
              ),
              const SizedBox(width: 12),
              const Text(
                'HOST SESSION',
                style: TextStyle(
                    fontFamily: 'BebasNeue', fontSize: 32, letterSpacing: 1.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 3.0,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

/// Tombol hitam lebar di bawah (NEXT STEP / FINISH).
class _StepButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;
  const _StepButton(
      {required this.label, required this.onTap, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: GestureDetector(
        onTap: loading ? null : onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 22),
          color: _black,
          child: loading
              ? const Center(
                  child: SizedBox(
                    height: 26,
                    width: 26,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 3),
                  ),
                )
              : Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    color: Colors.white,
                    fontSize: 30,
                    letterSpacing: 1.5,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Gambar jaringan yang otomatis mencoba ulang saat gagal (mis. LoremFlickr
/// kadang balas 500). Memuat ulang URL yang sama beberapa kali sebelum
/// menyerah dan menampilkan [placeholder]. Harus dipakai di dalam parent
/// dengan ukuran pasti (mis. Stack berukuran tetap / StackFit.expand).
class _RetryImage extends StatefulWidget {
  final String url;
  final Widget placeholder;
  const _RetryImage({required this.url, required this.placeholder});

  @override
  State<_RetryImage> createState() => _RetryImageState();
}

class _RetryImageState extends State<_RetryImage> {
  int _attempt = 0;
  bool _pending = false;
  static const int _maxAttempts = 6;

  @override
  void didUpdateWidget(covariant _RetryImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _attempt = 0;
      _pending = false;
    }
  }

  void _scheduleRetry() {
    if (_attempt >= _maxAttempts || _pending) return;
    _pending = true;
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _attempt++;
          _pending = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.url,
      // Key berubah tiap percobaan agar Image me-resolve ulang (fetch ulang).
      key: ValueKey<int>(_attempt),
      fit: BoxFit.cover,
      gaplessPlayback: true,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _loadingBox(),
      errorBuilder: (context, error, stack) {
        if (_attempt < _maxAttempts) {
          _scheduleRetry();
          return _loadingBox();
        }
        return widget.placeholder;
      },
    );
  }

  Widget _loadingBox() => const ColoredBox(
        color: Color(0xFFDCDDDB),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: _darkGreen),
          ),
        ),
      );
}
