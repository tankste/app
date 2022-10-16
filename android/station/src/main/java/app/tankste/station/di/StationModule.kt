package app.tankste.station.di

import app.tankste.station.api.TankerkoenigApi
import app.tankste.station.repository.FlutterPreferencesRepository
import app.tankste.station.repository.PreferencesRepository
import app.tankste.station.repository.StationRepository
import app.tankste.station.repository.TankerkoenigStationRepository
import app.tankste.station.usecase.GetStationsUseCase
import app.tankste.station.usecase.GetStationsUseCaseImpl
import okhttp3.OkHttpClient
import org.koin.dsl.module
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory


val stationModule = module {

    // Use Case
    factory<GetStationsUseCase> { GetStationsUseCaseImpl(get(), get(), get()) }

    // Repository
    single<StationRepository> { TankerkoenigStationRepository(get(), get()) }
    single<PreferencesRepository> { FlutterPreferencesRepository(get()) }

    // API
    factory { get<Retrofit>().create(TankerkoenigApi::class.java) }

    // Generic retrofit
    //TODO: move to specific API-module if more native Android logic comes up
    // Retrofit
    factory {
        Retrofit.Builder()
            .client(get())
            .baseUrl("https://creativecommons.tankerkoenig.de/json/")
            .addConverterFactory(MoshiConverterFactory.create())
            .build()
    }

    // OkHttp
    factory {
        OkHttpClient.Builder()
            .build()
    }
}
