package app.tankste.currency.di

import app.tankste.client.currency.repository.impl.TanksteLocalCurrencyRepository
import app.tankste.currency.repository.CurrencyRepository
import app.tankste.currency.repository.PreferencesCurrencyRepository
import org.koin.dsl.module
import app.tankste.client.currency.repository.CurrencyRepository as ClientCurrencyRepository

val currencyModule = module {
    single<CurrencyRepository> {
        PreferencesCurrencyRepository(
            context = get(),
            clientCurrencyRepository = get()
        )
    }
    single<ClientCurrencyRepository> { TanksteLocalCurrencyRepository }
}
