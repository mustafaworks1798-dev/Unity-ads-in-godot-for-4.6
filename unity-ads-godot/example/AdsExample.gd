extends Node

## مثال شامل على استخدام Unity Ads Plugin
## ضع هذا السكريبت على أي Node في المشروع

func _ready() -> void:
	# ربط الإشارات لمتابعة الأحداث
	UnityAds.initialization_complete.connect(_on_init_done)
	UnityAds.ad_closed.connect(_on_ad_closed)
	UnityAds.ad_failed_to_show.connect(_on_ad_error)

func _on_init_done() -> void:
	print("Unity Ads جاهز!")
	# ابدأ تحميل الإعلانات مباشرة بعد التهيئة
	UnityAds.load_ad(UnityAds.REWARDED)

func _on_ad_closed(placement_id: String) -> void:
	print("أغلق المستخدم الإعلان: ", placement_id)
	# أعد المكافأة للمستخدم هنا
	if placement_id == UnityAds.REWARDED:
		give_reward()

func _on_ad_error(placement_id: String, error: String) -> void:
	print("خطأ في الإعلان: ", error)

func give_reward() -> void:
	print("تم منح المكافأة!")

# ─── أمثلة الاستخدام ───────────────────────────────────────────────────────

## ── مثال 1: عرض إعلان مكافأة (Rewarded) ──
func show_rewarded_ad() -> void:
	if UnityAds.is_ready(UnityAds.REWARDED):
		UnityAds.show_ad(UnityAds.REWARDED)
	else:
		print("الإعلان غير جاهز، جاري التحميل...")
		UnityAds.load_ad(UnityAds.REWARDED)
		await UnityAds.ad_loaded
		UnityAds.show_ad(UnityAds.REWARDED)

## ── مثال 2: عرض إعلان بيني (Interstitial) ──
func show_interstitial() -> void:
	UnityAds.load_ad(UnityAds.INTERSTITIAL)
	await UnityAds.ad_loaded
	UnityAds.show_ad(UnityAds.INTERSTITIAL)

## ── مثال 3: الطريقة المختصرة (تحميل + عرض بسطر واحد) ──
func show_any_ad() -> void:
	await UnityAds.load_and_show(UnityAds.REWARDED)
	print("انتهى الإعلان")
