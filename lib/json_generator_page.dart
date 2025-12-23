import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'kayanee_model.dart';
import 'kayanee_widget.dart';

class JsonGeneratorPage extends StatefulWidget {
  const JsonGeneratorPage({super.key});

  @override
  State<JsonGeneratorPage> createState() => _JsonGeneratorPageState();
}

class _JsonGeneratorPageState extends State<JsonGeneratorPage> {
  // Controllers
  final _colorStartCtrl = TextEditingController(text: '#6340D6');
  final _colorEndCtrl = TextEditingController(text: '#10D1BD');

  final _titleArCtrl = TextEditingController(text: 'تدرب بملابس رياضية');
  final _titleEnCtrl = TextEditingController(text: 'Train in sportswear.');

  final _descArCtrl = TextEditingController(text: 'تحرك، ارتدي، استعيد, سهل الحركة وراحة لا توصف');
  final _descEnCtrl = TextEditingController(text: 'Move, wear, recover, easy movement and unparalleled comfort.');

  final _btnArCtrl = TextEditingController(text: 'زيارة فتنس');
  final _btnEnCtrl = TextEditingController(text: 'Visit Fitness');

  final _textArCtrl = TextEditingController(text: 'فتنس ستورم للملابس, عالم من الاناقة الفاخرة');
  final _textEnCtrl = TextEditingController(text: 'Fitness Storm Clothing, a world of luxurious style.');

  final _imageCtrl = TextEditingController(
    text:
        'https://firebasestorage.googleapis.com/v0/b/fitness-strom-1.appspot.com/o/fitness_images%2F52-1-683x1024.png?alt=media&token=ecb71a1c-4057-40ee-83bd-1cc95b5bb013',
  );
  final _logoCtrl = TextEditingController(
    text:
        'https://firebasestorage.googleapis.com/v0/b/fitness-strom-1.appspot.com/o/fitness_images%2Fnew_logo.png?alt=media&token=ab23d8c1-4378-44b6-ac76-75171c0e6c87',
  );

  final _linkCtrl = TextEditingController(text: 'https://fitnessstorm.org/en/shop/');
  final _eventNameCtrl = TextEditingController(text: 'visite_fitness_shop');

  // Preview Object
  KayaneeParms get _currentParams => KayaneeParms.fromJson({
    "color_start": _colorStartCtrl.text,
    "color_end": _colorEndCtrl.text,
    "title_ar": _titleArCtrl.text,
    "title_en": _titleEnCtrl.text,
    "description_ar": _descArCtrl.text,
    "description_en": _descEnCtrl.text,
    "btn_ar": _btnArCtrl.text,
    "btn_en": _btnEnCtrl.text,
    "text_ar": _textArCtrl.text,
    "text_en": _textEnCtrl.text,
    "image": _imageCtrl.text,
    "logo": _logoCtrl.text,
    "link": _linkCtrl.text,
    "event_name": _eventNameCtrl.text,
  });

  String _generatedJson = '';

  @override
  void initState() {
    super.initState();
    // Rebuild on any change to update preview
    _colorStartCtrl.addListener(_update);
    _colorEndCtrl.addListener(_update);
    _titleArCtrl.addListener(_update);
    _descArCtrl.addListener(_update);
    _btnArCtrl.addListener(_update);
    _textArCtrl.addListener(_update);
    _imageCtrl.addListener(_update);
    _logoCtrl.addListener(_update);
  }

  void _update() => setState(() {});

  void _generateJson() {
    final params = {
      "color_start": _colorStartCtrl.text,
      "color_end": _colorEndCtrl.text,
      "title_ar": _titleArCtrl.text,
      "title_en": _titleEnCtrl.text,
      "description_ar": _descArCtrl.text,
      "description_en": _descEnCtrl.text,
      "btn_ar": _btnArCtrl.text,
      "btn_en": _btnEnCtrl.text,
      "text_ar": _textArCtrl.text,
      "text_en": _textEnCtrl.text,
      "image": _imageCtrl.text,
      "logo": _logoCtrl.text,
      "link": _linkCtrl.text,
      "event_name": _eventNameCtrl.text,
    };

    setState(() {
      _generatedJson = const JsonEncoder.withIndent('  ').convert(params);
    });
  }

  void _copyJson() {
    if (_generatedJson.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedJson));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ تم نسخ JSON بنجاح!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Fitness Storm JSON Generator'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: Inputs
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B).withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: ListView(
                children: [
                  _sectionTitle('🎨 الألوان'),
                  _buildPair(_colorStartCtrl, 'Color Start', _colorEndCtrl, 'Color End', isColor: true),

                  _sectionTitle('📝 العناوين والوصف'),
                  _buildPair(_titleArCtrl, 'العنوان (AR)', _titleEnCtrl, 'Title (EN)'),
                  _buildPair(_descArCtrl, 'الوصف (AR)', _descEnCtrl, 'Description (EN)', maxLines: 2),

                  _sectionTitle('🧩 النصوص الإضافية'),
                  _buildPair(_textArCtrl, 'نص البطاقة (AR)', _textEnCtrl, 'Card Text (EN)'),
                  _buildPair(_btnArCtrl, 'نص الزر (AR)', _btnEnCtrl, 'Button Text (EN)'),

                  _sectionTitle('🖼️ الروابط والصور'),
                  _buildInput(_imageCtrl, 'Image URL'),
                  const SizedBox(height: 10),
                  _buildInput(_logoCtrl, 'Logo URL'),
                  const SizedBox(height: 10),
                  _buildPair(_linkCtrl, 'Target Link', _eventNameCtrl, 'Event Name'),

                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _generateJson,
                    icon: const Icon(Icons.code),
                    label: const Text('توليد JSON'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      backgroundColor: const Color(0xFF6340D6),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Right: Preview & Output
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(top: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  // Widget Preview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        const Text('معاينة حية (Live Preview)', style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            20.0.horizontalSpace,
                            DrawableText(
                              text: isAr ? 'عربي' : 'English',
                              color: Colors.black,
                            ),
                            10.0.horizontalSpace,
                            Switch(
                              value: isAr,
                              onChanged: (value) {
                                setState(() {
                                  isAr = value;
                                });
                              },
                            ),
                            20.0.horizontalSpace,
                          ],
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: KayaneeWidget(kayanee: _currentParams),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // JSON Output
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B1120),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: SelectableText(
                              _generatedJson.isEmpty ? 'اضغط "توليد" لرؤية النتيجة هنا...' : _generatedJson,
                              style: const TextStyle(
                                fontFamily: 'Courier New',
                                color: Color(0xFFE2E8F0),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: _copyJson,
                              icon: const Icon(Icons.copy, color: Colors.white70),
                              tooltip: 'نسخ',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        style: TextStyle(color: const Color(0xFF10D1BD), fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPair(
    TextEditingController c1,
    String l1,
    TextEditingController c2,
    String l2, {
    bool isColor = false,
    int maxLines = 1,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildInput(c1, l1, isColor: isColor, maxLines: maxLines),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildInput(c2, l2, isColor: isColor, maxLines: maxLines),
        ),
      ],
    );
  }

  Widget _buildInput(TextEditingController controller, String label, {bool isColor = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A).withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: const Color(0xFF6340D6)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            suffixIcon: isColor
                ? GestureDetector(
                    onTap: () => _showPickColor(controller),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _tryParseColor(controller.text),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Color _tryParseColor(String hex) {
    try {
      if (hex.isEmpty) return Colors.transparent;
      return Color(int.parse('0xFF${hex.replaceAll('#', '')}'));
    } catch (_) {
      return Colors.transparent;
    }
  }

  void _showPickColor(TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _tryParseColor(controller.text),
              onColorChanged: (color) {
                // Formatting to #RRGGBB
                final hexCode = color.value.toRadixString(16).toUpperCase().padLeft(8, '0');
                // hexCode is AARRGGBB, we want RRGGBB if user uses that format, but keeping it simple:
                // If the user's input logic expects 6 chars + implied FF, we should give 6 chars.
                // Substring(2) gives RRGGBB.
                controller.text = '#${hexCode.substring(2)}';
              },
              // Disable alpha to keep it simple 6-hex #RRGGBB
              enableAlpha: false,
              displayThumbColor: true,
              labelTypes: const [],
              paletteType: PaletteType.hsvWithHue,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
