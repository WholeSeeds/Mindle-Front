import java.util.Properties

fun loadDotEnv(): Properties {
    val env = Properties()
    val envFile = rootProject.file("../.env")
    if (envFile.exists()) {
        envFile.forEachLine { line ->
            if (line.trim().startsWith("#").not() && line.contains("=")) {
                val (key, value) = line.split("=", limit = 2)
                env.setProperty(key.trim(), value.trim())
            }
        }
    } 
    return env
}

val dotenv = loadDotEnv()

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:33.14.0"))

  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")

  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
}

android {
    namespace = "com.wholeseeds.mindle"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.wholeseeds.mindle"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // manifest에 전달할 placeholder 설정
        manifestPlaceholders["GOOGLE_MAPS_PLATFORM_API_KEY"] = dotenv.getProperty("GOOGLE_MAPS_PLATFORM_API_KEY") ?: ""
        manifestPlaceholders["KAKAO_NATIVE_APP_KEY"] =
            dotenv.getProperty("KAKAO_NATIVE_APP_KEY") ?: ""
    }

    signingConfigs {
        create("release") {
            storeFile = file(dotenv.getProperty("KEYSTORE_PATH") ?: "")
            storePassword = dotenv.getProperty("KEYSTORE_PASSWORD") ?: ""
            keyAlias = dotenv.getProperty("KEY_ALIAS") ?: ""
            keyPassword = dotenv.getProperty("KEY_PASSWORD") ?: ""
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
