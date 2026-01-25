import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

//keystoreProperties をロードする
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject . file ("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream (keystorePropertiesFile))
}

android {
    namespace = "io.github.miiko_cat.ai_analysis_diary_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "io.github.miiko_cat.ai_analysis_diary_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
        }
    }

    flavorDimensions += "default"
    productFlavors {
        create("local") {
            dimension = "default"
            resValue(
                type = "string",
                name = "app_name",
                value = "[local]AI分析日記アプリ"
            )
            applicationIdSuffix = ".local"
        }
        create("dev") {
            dimension = "default"
            resValue(
                type = "string",
                name = "app_name",
                value = "[dev]AI分析日記アプリ"
            )
            applicationIdSuffix = ".dev"
        }
        create("prod") {
            dimension = "default"
            resValue(
                type = "string",
                name = "app_name",
                value = "AI分析日記アプリ"
            )
        }
    }
}

flutter {
    source = "../.."
}
