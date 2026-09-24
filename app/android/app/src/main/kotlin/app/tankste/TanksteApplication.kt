package app.tankste

import android.app.Application
import app.tankste.currency.di.currencyModule
import app.tankste.favorite.di.favoriteModule
import app.tankste.station.di.stationModule
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.GlobalContext.startKoin

class TanksteApplication : Application() {

    override fun onCreate() {
        super.onCreate()

        initKoin()
    }

    private fun initKoin() {
        startKoin {
            androidLogger()
            androidContext(this@TanksteApplication)
            modules(currencyModule)
            modules(stationModule)
            modules(favoriteModule)
        }
    }
}