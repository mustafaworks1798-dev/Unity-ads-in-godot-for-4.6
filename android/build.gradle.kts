plugins {
    id("com.android.library") version "8.5.0"
    id("org.jetbrains.kotlin.android") version "2.0.21"
}

val godotTemplatesPath = System.getenv("GODOT_TEMPLATES_PATH")
    ?: "REPLACE_WITH_PATH_TO_GODOT_ANDROID_TEMPLATES"

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
    compileOnly(fileTree(godotTemplatesPath) { include("godot-lib*.aar") })
    implementation("com.unity3d.ads:unity-ads:4.10.0")
}
