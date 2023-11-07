package app.tankste.navigation.di

import app.tankste.navigation.repository.GoogleLocationRepository
import app.tankste.navigation.repository.LocationRepository
import com.google.android.gms.location.LocationServices
import org.koin.android.ext.koin.androidContext
import org.koin.dsl.module


val navigationModule = module {

    // Repository
    single<LocationRepository> { GoogleLocationRepository(get()) }

    // API
    factory { LocationServices.getFusedLocationProviderClient(androidContext()) }
}
