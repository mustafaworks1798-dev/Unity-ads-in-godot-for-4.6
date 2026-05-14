# Unity Ads Plugin for Godot 4.x (Android)
Game ID: **6109903**

## هيكل الملفات / File Structure

```
unity-ads-godot/
├── android/                        ← مشروع Android (بناء الـ AAR)
│   ├── build.gradle.kts
│   ├── settings.gradle.kts
│   └── src/main/
│       ├── AndroidManifest.xml
│       └── kotlin/.../UnityAdsPlugin.kt
│
├── addons/unity_ads/               ← انسخ هذا المجلد إلى مشروعك مباشرة
│   ├── UnityAds.gd                 ← Autoload رئيسي
│   └── plugin.cfg
│
└── example/
    └── AdsExample.gd               ← أمثلة الاستخدام
```

---

## الخطوة 1 — بناء الـ AAR

### المتطلبات
- Android Studio أو JDK 17
- Godot 4.x Android Export Templates

### التعليمات
1. افتح مجلد `android/` في Android Studio
2. في ملف `build.gradle.kts`، غيّر:
   ```
   val godotTemplatesPath = "REPLACE_WITH_PATH_TO_GODOT_ANDROID_TEMPLATES"
   ```
   إلى المسار الفعلي، مثال Windows:
   ```
   val godotTemplatesPath = "C:/Users/YourName/AppData/Roaming/Godot/export_templates/4.x.stable/android_source"
   ```
3. شغّل:
   ```bash
   ./gradlew :android:assembleRelease
   ```
4. ستجد الملف الناتج في:
   ```
   android/build/outputs/aar/android-release.aar
   ```
5. انسخه إلى `addons/unity_ads/bin/UnityAdsPlugin.aar`

---

## الخطوة 2 — إضافة البلوجن لمشروع Godot

1. **انسخ مجلد** `addons/unity_ads/` كاملاً إلى مشروعك داخل `res://addons/unity_ads/`
2. **ضع ملف AAR** في `res://addons/unity_ads/bin/UnityAdsPlugin.aar`
3. **فعّل البلوجن** من:
   `Project → Project Settings → Plugins → Unity Ads → Enable`
4. **أضف Autoload** من:
   `Project → Project Settings → Autoload`
   - Path: `res://addons/unity_ads/UnityAds.gd`
   - Name: `UnityAds`

---

## الخطوة 3 — الاستخدام في GDScript

```gdscript
# ── مثال 1: إعلان مكافأة (Rewarded) ──────────────────────────────────
func _on_watch_ad_button_pressed() -> void:
    UnityAds.load_ad(UnityAds.REWARDED)
    await UnityAds.ad_loaded
    UnityAds.show_ad(UnityAds.REWARDED)

# ── مثال 2: إعلان بيني (Interstitial) ───────────────────────────────
func _on_level_complete() -> void:
    await UnityAds.load_and_show(UnityAds.INTERSTITIAL)

# ── مثال 3: مكافأة المستخدم بعد الإعلان ─────────────────────────────
func _ready() -> void:
    UnityAds.ad_closed.connect(func(id): 
        if id == UnityAds.REWARDED:
            player.coins += 50
    )
```

## أنواع الإعلانات / Placement IDs

| الثابت               | القيمة                  | النوع              |
|----------------------|-------------------------|--------------------|
| `UnityAds.BANNER`    | `"Banner_Android"`      | بانر ثابت          |
| `UnityAds.INTERSTITIAL` | `"Interstitial_Android"` | إعلان بيني      |
| `UnityAds.REWARDED`  | `"Rewarded_Android"`    | إعلان بمكافأة     |

> تأكد أن هذه الأسماء مطابقة لما أنشأته في لوحة تحكم Unity Ads.

## الإشارات المتاحة / Signals

```gdscript
UnityAds.initialization_complete
UnityAds.initialization_failed(error: String)
UnityAds.ad_loaded(placement_id: String)
UnityAds.ad_failed_to_load(placement_id: String, error: String)
UnityAds.ad_showed(placement_id: String)
UnityAds.ad_closed(placement_id: String)
UnityAds.ad_clicked(placement_id: String)
UnityAds.ad_failed_to_show(placement_id: String, error: String)
```

## ملاحظات مهمة
- البلوجن يعمل على **Android فقط**
- غيّر `TEST_MODE = true` في `UnityAds.gd` أثناء التطوير
- للنشر: تأكد من تفعيل Android Export في Godot مع Custom Build
