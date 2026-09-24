import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

repositories {
    mavenLocal()
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

    compileSdk = 37
    ndkVersion = "28.1.13356709"

    defaultConfig {
        applicationId = "app.tankste"

        minSdk = 26
        targetSdk = 37

        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    buildTypes {
        release {
            isShrinkResources = true
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
    implementation(project(":currency"))
    implementation(project(":station"))
    implementation(project(":favorite"))

    // Koin - https://github.com/InsertKoinIO/koin
    implementation("io.insert-koin:koin-core:4.2.2")
    implementation("io.insert-koin:koin-android:4.2.2")
    implementation("io.insert-koin:koin-android-compat:4.2.2")
}
