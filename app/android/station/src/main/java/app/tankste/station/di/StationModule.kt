package app.tankste.station.di

import app.tankste.station.repository.FuelTypeRepository
import app.tankste.station.repository.PreferencesFuelTypeRepository
import org.koin.dsl.module

val stationModule = module {
    single<FuelTypeRepository> {
        PreferencesFuelTypeRepository(
            context = get(),
        )
    }
}
