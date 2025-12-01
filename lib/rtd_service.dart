import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

class RtdService {
  // نستخدم الـ instance الافتراضي لقاعدة البيانات
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  /// ==============================================================================
  /// 1. نظام التواجد (Presence System) - معرفة المتصلين
  /// ==============================================================================
  
  /// هذه الميزة هي "الجوهرة" في Realtime Database وتتفوق فيها على Firestore.
  /// تسمح لك بمعرفة ما إذا كان المستخدم متصلاً حالياً، وعندما يقطع الاتصال (يغلق التطبيق أو يفصل النت)
  /// يقوم السيرفر تلقائياً بتحديث حالته في قاعدة البيانات حتى لو لم يستطع الجهاز إرسال طلب.
  void setupPresenceSystem(String userId) {
    // مرجع لحالة اتصال الجهاز الحالي بالسيرفر
    // .info/connected هو موقع خاص في RTD يعطيك true اذا كان الجهاز متصل بـ Firebase
    final connectedRef = FirebaseDatabase.instance.ref(".info/connected");
    
    // مرجع لمكان تخزين حالة المستخدم في الداتا بيز
    final userStatusRef = _db.child("status/$userId");

    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      
      if (connected) {
        // 1. عند الاتصال، نسجل أن المستخدم "online"
        userStatusRef.set({
          "state": "online",
          "last_changed": ServerValue.timestamp,
        });

        // 2. onDisconnect: هذا هو السحر!
        // نقول للسيرفر: "يا سيرفر، إذا انقطع اتصالي بك لأي سبب (كراش، انترنت فصل)،
        // أرجوك قم بتنفيذ هذا الأمر نيابة عني".
        // هنا نقول له: حول حالتي إلى "offline".
        userStatusRef.onDisconnect().set({
          "state": "offline",
          "last_changed": ServerValue.timestamp,
        });
      }
    });
  }

  /// مراقبة عدد المستخدمين المتصلين في "غرفة" أو "index" معين
  /// هذا يعطيك Stream يحدث تلقائياً كلما دخل أو خرج شخص
  Stream<int> trackOnlineUsersCount() {
    // نفترض أننا نخزن المستخدمين المتصلين تحت 'status'
    // نقوم بفلترة المستخدمين الذين حالتهم 'online'
    return _db.child("status")
        .orderByChild("state")
        .equalTo("online")
        .onValue
        .map((event) {
          // نرجع عدد الأطفال (المستخدمين) الذين طابقوا الفلتر
          return event.snapshot.children.length;
        });
  }

  /// ==============================================================================
  /// 2. العمليات الأساسية (CRUD)
  /// ==============================================================================

  /// إضافة أو تعديل بيانات (Set/Update)
  /// Set: تقوم باستبدال البيانات الموجودة في المسار بالكامل.
  Future<void> setUserData(String userId, Map<String, dynamic> data) async {
    // مثال: users/123
    await _db.child("users").child(userId).set(data);
  }

  /// تعديل حقول محددة فقط دون حذف باقي البيانات (Update)
  Future<void> updateUserEmail(String userId, String newEmail) async {
    // سيتم تعديل email فقط وترك الاسم والعمر كما هم
    await _db.child("users").child(userId).update({
      "email": newEmail,
    });
  }

  /// إضافة عنصر جديد لقائمة (Push)
  /// هذه الميزة تنشئ مفتاحاً فريداً (Unique Key) تلقائياً يعتمد على الوقت.
  /// مفيدة جداً للمحادثات، الإشعارات، أو أي قائمة عناصر.
  Future<void> sendMessage(String chatId, String message) async {
    // النتيجة ستكون مثل: chats/chat_123/-Nxy7823jh23 (مفتاح عشوائي)
    await _db.child("chats").child(chatId).push().set({
      "text": message,
      "timestamp": ServerValue.timestamp, // وقت السيرفر الدقيق
    });
  }

  /// حذف البيانات (Remove)
  Future<void> deleteUser(String userId) async {
    await _db.child("users").child(userId).remove();
  }

  /// ==============================================================================
  /// 3. قراءة البيانات (Read)
  /// ==============================================================================

  /// قراءة البيانات مرة واحدة فقط (One-time Read)
  /// نستخدمها عندما لا نحتاج لتحديثات مستمرة (مثلاً جلب البروفايل عند الفتح)
  Future<DataSnapshot> getUserProfile(String userId) async {
    final snapshot = await _db.child("users").child(userId).get();
    if (snapshot.exists) {
      print(snapshot.value);
    }
    return snapshot;
  }

  /// الاستماع المستمر للتغييرات (Stream / Realtime Listener)
  /// أي تغيير في الداتا بيز سيصلك فوراً هنا.
  Stream<DatabaseEvent> listenToChatMessages(String chatId) {
    return _db.child("chats").child(chatId).onValue;
  }

  /// ==============================================================================
  /// 4. الفلترة والترتيب (Querying & Filtering)
  /// ==============================================================================

  /// جلب البيانات مرتبة ومفلترة
  /// ملاحظة: في RTD الترتيب والفلترة محدودين مقارنة بـ Firestore
  Stream<DatabaseEvent> getRecentMessages(String chatId) {
    return _db.child("chats")
        .child(chatId)
        .orderByChild("timestamp") // ترتيب حسب الوقت
        .limitToLast(20)          // جلب آخر 20 رسالة فقط
        .onValue;
  }

  /// ==============================================================================
  /// 5. العمليات المتقدمة (Advanced)
  /// ==============================================================================

  /// المعاملات (Transactions)
  /// تستخدم عندما نريد تعديل قيمة تعتمد على قيمتها الحالية (مثل العدادات)
  /// وتضمن عدم حدوث تضارب إذا قام مستخدمان بالتعديل في نفس اللحظة.
  Future<void> incrementLikeCount(String postId) async {
    await _db.child("posts").child(postId).child("likes").runTransaction((Object? currentData) {
      // إذا لم تكن القيمة موجودة، نبدأ بـ 0
      if (currentData == null) {
        return Transaction.success(1);
      }
      // إذا كانت موجودة، نزيدها بـ 1
      return Transaction.success((currentData as int) + 1);
    });
  }

  /// المزامنة دون اتصال (Offline Capabilities)
  /// keepSynced(true): تجعل هذا المسار محدثاً دائماً ومخزناً في الكاش المحلي
  /// حتى لو لم يكن التطبيق يعرض هذه البيانات حالياً.
  void keepChatSynced(String chatId) {
    _db.child("chats").child(chatId).keepSynced(true);
  }
}
