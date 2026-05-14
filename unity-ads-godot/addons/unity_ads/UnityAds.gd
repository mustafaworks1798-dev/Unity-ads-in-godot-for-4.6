extends Node

## Unity Ads Autoload for Godot 4.x
## Game ID: 6109903
##
## الاستخدام / Usage:
##   UnityAds.initialize()
##   await UnityAds.ad_loaded
##   UnityAds.show_ad("Interstitial_Android")

# ─── الإشارات / Signals ───────────────────────────────────────────────────────
signal initialization_complete
signal initialization_failed(error: String)
signal ad_loaded(placement_id: String)
signal ad_failed_to_load(placement_id: String, error: String)
signal ad_showed(placement_id: String)
signal ad_failed_to_show(placement_id: String, error: String)
signal ad_clicked(placement_id: String)
signal ad_closed(placement_id: String)

# ─── الإعدادات / Config ───────────────────────────────────────────────────────
const GAME_ID      := "6109903"
const TEST_MODE    := false   # ← غيّره إلى true أثناء التطوير / true during dev

# أسماء وحدات الإعلان الافتراضية / Default placement IDs
const BANNER       := "Banner_Android"
const INTERSTITIAL := "Interstitial_Android"
const REWARDED     := "Rewarded_Android"

# ─── المتغيرات الداخلية / Internal vars ──────────────────────────────────────
var _plugin: Object = null
var _initialized   := false
var _loaded_ads    := {}   # placement_id → bool

# ─── التهيئة / Init ───────────────────────────────────────────────────────────
func _ready() -> void:
	if Engine.has_singleton("UnityAds"):
		_plugin = Engine.get_singleton("UnityAds")
		_connect_signals()
		initialize()
	else:
		push_warning("UnityAds: البلوجن غير متاح على هذا المنصة (يعمل على Android فقط)")

func _connect_signals() -> void:
	_plugin.initialization_complete.connect(_on_initialization_complete)
	_plugin.initialization_failed.connect(_on_initialization_failed)
	_plugin.ad_loaded.connect(_on_ad_loaded)
	_plugin.ad_failed_to_load.connect(_on_ad_failed_to_load)
	_plugin.ad_showed.connect(_on_ad_showed)
	_plugin.ad_failed_to_show.connect(_on_ad_failed_to_show)
	_plugin.ad_clicked.connect(_on_ad_clicked)
	_plugin.ad_closed.connect(_on_ad_closed)

# ─── الدوال العامة / Public API ───────────────────────────────────────────────

## تهيئة Unity Ads (تُستدعى تلقائياً عند بدء التشغيل)
func initialize(test_mode: bool = TEST_MODE) -> void:
	if _plugin == null:
		return
	_plugin.initialize(GAME_ID, test_mode)

## تحميل إعلان
## placement_id: "Banner_Android" | "Interstitial_Android" | "Rewarded_Android"
##
## مثال:
##   UnityAds.load_ad(UnityAds.REWARDED)
##   await UnityAds.ad_loaded
func load_ad(placement_id: String) -> void:
	if _plugin == null:
		push_warning("UnityAds: البلوجن غير متاح")
		return
	if not _initialized:
		push_warning("UnityAds: لم تكتمل التهيئة بعد")
		return
	_loaded_ads[placement_id] = false
	_plugin.load_ad(placement_id)

## عرض إعلان محمّل مسبقاً
func show_ad(placement_id: String) -> void:
	if _plugin == null:
		push_warning("UnityAds: البلوجن غير متاح")
		return
	if not _loaded_ads.get(placement_id, false):
		push_warning("UnityAds: الإعلان '%s' لم يُحمَّل بعد" % placement_id)
		return
	_plugin.show_ad(placement_id)

## دالة مختصرة: تحميل ثم عرض الإعلان
##
## مثال:
##   await UnityAds.load_and_show(UnityAds.INTERSTITIAL)
func load_and_show(placement_id: String) -> void:
	load_ad(placement_id)
	await ad_loaded
	show_ad(placement_id)

## هل الـ SDK مُهيَّأ؟
func is_initialized() -> bool:
	return _initialized

## هل الإعلان محمّل وجاهز للعرض؟
func is_ready(placement_id: String) -> bool:
	return _loaded_ads.get(placement_id, false)

# ─── معالجات الإشارات الداخلية / Signal handlers ─────────────────────────────
func _on_initialization_complete() -> void:
	_initialized = true
	print("UnityAds ✓ تمت التهيئة بنجاح")
	initialization_complete.emit()

func _on_initialization_failed(error: String) -> void:
	push_error("UnityAds ✗ فشلت التهيئة: " + error)
	initialization_failed.emit(error)

func _on_ad_loaded(placement_id: String) -> void:
	_loaded_ads[placement_id] = true
	print("UnityAds ✓ تم تحميل الإعلان: " + placement_id)
	ad_loaded.emit(placement_id)

func _on_ad_failed_to_load(placement_id: String, error: String) -> void:
	_loaded_ads[placement_id] = false
	push_error("UnityAds ✗ فشل تحميل '%s': %s" % [placement_id, error])
	ad_failed_to_load.emit(placement_id, error)

func _on_ad_showed(placement_id: String) -> void:
	ad_showed.emit(placement_id)

func _on_ad_failed_to_show(placement_id: String, error: String) -> void:
	push_error("UnityAds ✗ فشل عرض '%s': %s" % [placement_id, error])
	ad_failed_to_show.emit(placement_id, error)

func _on_ad_clicked(placement_id: String) -> void:
	ad_clicked.emit(placement_id)

func _on_ad_closed(placement_id: String) -> void:
	_loaded_ads[placement_id] = false
	ad_closed.emit(placement_id)
