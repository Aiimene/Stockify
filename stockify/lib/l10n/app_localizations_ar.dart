// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'StockiFy';

  @override
  String get welcome => 'مرحباً';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get dashboard => 'لوحة التحكم';

  @override
  String get products => 'المنتجات';

  @override
  String get orders => 'الطلبات';

  @override
  String get analytics => 'التحليلات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get addProduct => 'إضافة منتج';

  @override
  String get editProduct => 'تعديل المنتج';

  @override
  String get deleteProduct => 'حذف المنتج';

  @override
  String get productName => 'اسم المنتج';

  @override
  String get sku => 'رمز المنتج';

  @override
  String get barcode => 'الباركود';

  @override
  String get description => 'الوصف';

  @override
  String get costPrice => 'سعر التكلفة';

  @override
  String get sellingPrice => 'سعر البيع';

  @override
  String get stockQuantity => 'الكمية المتوفرة';

  @override
  String get lowStockThreshold => 'حد المخزون المنخفض';

  @override
  String get expiryDate => 'تاريخ الانتهاء';

  @override
  String get image => 'الصورة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get view => 'عرض';

  @override
  String get add => 'إضافة';

  @override
  String get search => 'بحث';

  @override
  String get filter => 'تصفية';

  @override
  String get totalRevenue => 'إجمالي الإيرادات';

  @override
  String get totalOrders => 'إجمالي الطلبات';

  @override
  String get totalProducts => 'إجمالي المنتجات';

  @override
  String get averageOrderValue => 'متوسط قيمة الطلب';

  @override
  String get lowStockCount => 'عدد المخزون المنخفض';

  @override
  String get revenueTrends => 'اتجاهات الإيرادات';

  @override
  String get topSellingProducts => 'المنتجات الأكثر مبيعاً';

  @override
  String get lowStockAlerts => 'تنبيهات المخزون المنخفض';

  @override
  String get recentActivities => 'الأنشطة الأخيرة';

  @override
  String get newSale => 'بيع جديد';

  @override
  String get orderNumber => 'رقم الطلب';

  @override
  String get orderDate => 'تاريخ الطلب';

  @override
  String get orderStatus => 'حالة الطلب';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get totalAmount => 'المبلغ الإجمالي';

  @override
  String get completed => 'مكتمل';

  @override
  String get refunded => 'مسترد';

  @override
  String get cash => 'نقدي';

  @override
  String get card => 'بطاقة';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get subscription => 'الاشتراك';

  @override
  String get billing => 'الفوترة';

  @override
  String get help => 'المساعدة';

  @override
  String get privacy => 'سياسة الخصوصية';

  @override
  String get language => 'اللغة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get update => 'تحديث';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String unitsSold(int count) {
    return 'تم بيع $count وحدة';
  }

  @override
  String onlyLeft(int count) {
    return 'بقي $count فقط';
  }

  @override
  String get outOfStock => 'نفد المخزون';

  @override
  String get noDataAvailable => 'لا توجد بيانات متاحة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get success => 'نجح';

  @override
  String pleaseEnter(String field) {
    return 'يرجى إدخال $field';
  }

  @override
  String get invalidEmail => 'يرجى إدخال عنوان بريد إلكتروني صحيح';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String languageChanged(String language) {
    return 'تم تغيير اللغة إلى $language';
  }
}
