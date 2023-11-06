package app.tankste.station.repository

import android.content.Context

//TODO: move to extra module if more logic will added
class FlutterPreferencesRepository(
    context: Context
): PreferencesRepository {

    private val sharedPreferences = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

    override fun getStringPreference(key: String): String? {
        return sharedPreferences.getString("flutter.$key", null)
    }
}
