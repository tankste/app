package app.tankste

import android.app.Application

class TanksteApplication: Application() {

    override fun onCreate() {
        super.onCreate()

        initKoin()
    }

    private fun initKoin() {
//        startKoin{
//            androidLogger()
//            androidContext(this@TanksteApplication)
////            modules(carModule)
//            modules(stationModule)
//            modules(navigationModule)
//        }X
    }
}