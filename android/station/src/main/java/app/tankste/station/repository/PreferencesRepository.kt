package app.tankste.station.repository

//TODO: move to extra module if more logic will added
interface PreferencesRepository {

    //TODO: return flow & result as well
    fun getStringPreference(key: String): String?
}