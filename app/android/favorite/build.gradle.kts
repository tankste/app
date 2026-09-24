plugins {
    alias(libs.plugins.android.library)
    alias(libs.plugins.compose.compiler)
}

kotlin {
    jvmToolchain(21)
}

android {
    namespace = "app.tankste.favorite"
    compileSdk = 37

    defaultConfig {
        minSdk = 26
    }

    buildFeatures {
        compose = true
    }
}

dependencies {
    implementation(project(":core"))
    implementation(project(":currency"))
    implementation(project(":station"))

    api("app.tankste:client-station:0.1.0")

    // Flutter's preferences plugins
    implementation(project(":shared_preferences_android"))

    implementation("androidx.datastore:datastore-preferences:1.2.1")

// For AppWidgets support
    implementation("androidx.glance:glance-appwidget:1.2.0")
// For interop APIs with Material 3
    implementation("androidx.glance:glance-material3:1.2.0")

    // Koin - https://github.com/InsertKoinIO/koin
    implementation("io.insert-koin:koin-core:4.2.2")
    implementation("io.insert-koin:koin-android:4.2.2")
    implementation("io.insert-koin:koin-android-compat:4.2.2")
    implementation(libs.androidx.material3)
    implementation(libs.androidx.work.runtime.ktx)
    implementation(libs.material)

//    api(libs.androidx.lifecycle.viewmodel.ktx)
//    api(platform(libs.compose.bom))
//    api(libs.compose.runtime)
//    api(libs.compose.ui)
//    api(libs.compose.navigation)
//
//    implementation(libs.compose.ui.tooling)
//    implementation(libs.compose.ui.tooling.preview)
//    implementation(libs.compose.material3)
//    implementation(libs.compose.material.icons)
//
//    testImplementation(libs.junit)
//    testImplementation(libs.kotlin.test)
//    testImplementation(libs.mockk)
//    testImplementation(libs.kotlinx.coroutines.test)
//    testImplementation(libs.turbine)
}

repositories {
    mavenLocal()
}