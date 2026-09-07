import com.android.build.gradle.internal.api.ApkVariantOutputImpl
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { input ->
        localProperties.load(input)
    }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "0.0.0"

kotlin {
    jvmToolchain(21)
}

android {
    namespace = "app.tankste"

    compileSdk = 36
    ndkVersion = "28.1.13356709"

    defaultConfig {
        applicationId = "app.tankste.fdroid"

        minSdk = flutter.minSdkVersion
        targetSdk = 36

        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            isShrinkResources = false
            isMinifyEnabled = true

            ndk {
                debugSymbolLevel = "SYMBOL_TABLE"
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
////    implementation project(':car')
//    implementation project(':station')
//    implementation project(':navigation')
//    implementation project(':core')
//
////    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.9.22"
//
//    // Koin - https://github.com/InsertKoinIO/koin
//    var koin_version = '3.2.2'
//    implementation "io.insert-koin:koin-core:$koin_version"
//    implementation "io.insert-koin:koin-android:$koin_version"
//    implementation "io.insert-koin:koin-android-compat:$koin_version"
}
