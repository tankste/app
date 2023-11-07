package app.tankste

import android.app.Application
//import app.tankste.car.di.carModule
import app.tankste.navigation.di.navigationModule
import app.tankste.station.di.stationModule
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin

class TanksteApplication: Application() {

    override fun onCreate() {
        super.onCreate()

        initKoin()
    }

    private fun initKoin() {
        startKoin{
            androidLogger()
            androidContext(this@TanksteApplication)
//            modules(carModule)
            modules(stationModule)
            modules(navigationModule)
        }
    }
}