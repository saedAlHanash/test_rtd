
import 'kayanee_widget.dart';

class KayaneeParms {
  static final Map<String, dynamic> mapDefault = {
    "color_start": "#7B6154",
    "color_end": "#D5B19E",
    "title_ar": "ارتقي بمستواكِ مع كياني",
    "title_en": "Level Up With Kayanee",
    "description_ar": "تحركي، ارتدي، استعيدي، تغذي، ازدهري، وتعلمي لبناء أفضل عادات حياتك",
    "description_en":
        "Move, Wear, Restore, Nourish, Thrive, and Learn to build the best habits of your life",
    "btn_ar": "زيارة كياني",
    "btn_en": "Visit Kayanee",
    "text_ar": "ادخلي عالمًا حيث تتناغم الموضة، الحركة، والعافية في تجربة فريدة",
    "text_en": "Enter a World Where Fashion, Movement & Well-being Combine",
    "image":
        "https://firebasestorage.googleapis.com/v0/b/fitness-strom-1.appspot.com/o/fitness_files%2Fkayanee_person.png?alt=media&token=b9351d1d-e3f3-4544-8281-e237f622985c",
    "logo":
        "https://firebasestorage.googleapis.com/v0/b/fitness-strom-1.appspot.com/o/fitness_images%2Fkayanee_logo.svg?alt=media&token=2f7bf9f4-54cc-47a1-b2c2-49f06b481b51",
    "link": "https://kayanee.com"
  };

  KayaneeParms({
    required this.colorStart,
    required this.colorEnd,
    required String titleAr,
    required String titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required String btnAr,
    required String btnEn,
    required String textAr,
    required String textEn,
    required this.image,
    required this.logo,
    required this.link,
    required this.eventName,
  }) : _textEn = textEn, _textAr = textAr, _btnEn = btnEn, _btnAr = btnAr, _titleEn = titleEn, _titleAr = titleAr;

  final String colorStart;
  final String colorEnd;
  final String _titleAr;
  final String _titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String _btnAr;
  final String _btnEn;
  final String _textAr;
  final String _textEn;
  final String image;
  final String logo;
  final String link;
  final String eventName;



  bool get _isAr => isAr;

  String get title => _isAr ? _titleAr : _titleEn;

  String get description => _isAr ? descriptionAr : descriptionEn;

  String get btn => _isAr ? _btnAr : _btnEn;

  String get text => _isAr ? _textAr : _textEn;


  factory KayaneeParms.fromJson(Map<String, dynamic> json) {
    return KayaneeParms(
      colorStart: json["color_start"] ?? "",
      colorEnd: json["color_end"] ?? "",
      titleAr: json["title_ar"] ?? "",
      titleEn: json["title_en"] ?? "",
      descriptionAr: json["description_ar"] ?? "",
      descriptionEn: json["description_en"] ?? "",
      btnAr: json["btn_ar"] ?? "",
      btnEn: json["btn_en"] ?? "",
      textAr: json["text_ar"] ?? "",
      textEn: json["text_en"] ?? "",
      image: json["image"] ?? "",
      logo: json["logo"] ?? "",
      link: json["link"] ?? "",
      eventName: json["event_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "color_start": colorStart,
        "color_end": colorEnd,
        "title_ar": _titleAr,
        "title_en": _titleEn,
        "description_ar": descriptionAr,
        "description_en": descriptionEn,
        "btn_ar": _btnAr,
        "btn_en": _btnEn,
        "text_ar": _textAr,
        "text_en": _textEn,
        "image": image,
        "logo": logo,
        "link": link,
        "event_name": eventName,
      };
}
