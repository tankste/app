package app.tankste.favorite.repository

import android.content.Context
import android.util.Log
import androidx.datastore.preferences.core.stringPreferencesKey
import app.tankste.client.station.model.StationModel
import app.tankste.client.station.repository.StationRepository
import app.tankste.client.station.repository.impl.TanksteWebStationRepository
import io.flutter.plugins.sharedpreferences.sharedPreferencesDataStore
import kotlinx.coroutines.flow.first
import org.json.JSONArray

interface FavoriteRepository {
    suspend fun list(): Result<List<StationModel>>
}

class PreferencesFavoriteRepository(
    //TODO: use customized API URL
    private val context: Context,
    private val stationRepository: StationRepository = TanksteWebStationRepository(),
) : FavoriteRepository {
    override suspend fun list(): Result<List<StationModel>> = runCatching {
        getFavoriteStationIds()
            .map { stationId -> stationRepository.get(stationId).getOrThrow() }
    }

    private suspend fun getFavoriteStationIds(): List<Int> {
        val raw = context.sharedPreferencesDataStore.data.first()[stringPreferencesKey(PREFERENCES_KEY)] ?: return emptyList()

        val json = raw.removePrefix(FLUTTER_LIST_PREFIX)
        val array = JSONArray(json)
        return (0 until array.length()).map { array.getString(it).toInt() }
    }

    private companion object {
        const val PREFERENCES_KEY = "favorite_stations"
        // Ugly base64 hash used for identify types
        // See: https://github.com/flutter/packages/blob/a757073ac4eaf05b7516d3d0488e5c98b221043f/packages/shared_preferences/shared_preferences_android/android/src/main/java/io/flutter/plugins/sharedpreferences/SharedPreferencesPlugin.java#L34
        const val FLUTTER_LIST_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGxpc3Qu!"
    }
}
