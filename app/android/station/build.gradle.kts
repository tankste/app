plugins {
    alias(libs.plugins.android.library)
}

kotlin {
    jvmToolchain(21)
}

android {
    namespace = "app.tankste.station"
    compileSdk = 37

    defaultConfig {
        minSdk = 26
    }
}

dependencies {
    implementation(project(":core"))

    api("app.tankste:client-station:0.1.0")

    // Flutter's preferences plugins
    implementation(project(":shared_preferences_android"))

    implementation("androidx.datastore:datastore-preferences:1.2.1")

    // Koin - https://github.com/InsertKoinIO/koin
    implementation("io.insert-koin:koin-core:4.2.2")
    implementation("io.insert-koin:koin-android:4.2.2")
    implementation("io.insert-koin:koin-android-compat:4.2.2")
}

repositories {
    mavenLocal()
}