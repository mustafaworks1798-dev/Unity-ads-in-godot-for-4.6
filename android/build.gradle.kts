plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android")
}

// =====================================================================
// قم بتغيير هذا المسار ليشير إلى مجلد Godot Android templates لديك
// Change this path to point to your Godot Android templates folder
// مثال: C:/Users/YourName/AppData/Roaming/Godot/export_templates/4.x.stable/android_source
val godotTemplatesPath = System.getenv("GODOT_TEMPLATES_PATH")
    ?: "REPLACE_WITH_PATH_TO_GODOT_ANDROID_TEMPLATES"
// =====================================================================

android {
    namespace = "com.replit.unityadsplugin"
    compileSdk = 34

    defaultConfig {
        minSdk = 21
        targetSdk = 34
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    // Godot engine library (من مجلد templates)
    compileOnly(fileTree(godotTemplatesPath) { include("godot-lib*.aar") })

    // Unity Ads SDK
    implementation("com.unity3d.ads:unity-ads:4.10.0")
}

// مهمة لنسخ الـ AAR الناتج تلقائياً إلى مجلد الـ addons
tasks.register<Copy>("copyToAddons") {
    dependsOn("assembleRelease")
    from(layout.buildDirectory.dir("outputs/aar")) {
        include("*-release.aar")
        rename { "UnityAdsPlugin.aar" }
    }
    into("${rootProject.projectDir}/addons/unity_ads/bin")
}
