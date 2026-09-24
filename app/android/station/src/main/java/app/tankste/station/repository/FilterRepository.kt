package app.tankste.station.repository

import android.content.Context
import app.tankste.client.station.model.FuelType

interface FuelTypeRepository {
    suspend fun getSelected(): Result<FuelType>
}

class PreferencesFuelTypeRepository(
    private val context: Context,
) : FuelTypeRepository {

    override suspend fun getSelected(): Result<FuelType> = runCatching {
        val preferences = context.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE)
        val fuelKey = preferences.getString(PREFERENCES_PREFIX + PREFERENCES_KEY, null)

        return@runCatching when (fuelKey) {
            // Legacy key for e5
            "e5" -> FuelType.PETROL_SUPER_E5
            // Legacy key for e10
            "e10" -> FuelType.PETROL_SUPER_E10
            else ->
                FuelType.entries.firstOrNull { f ->
                    f.name.equals(fuelKey, ignoreCase = true)
                } ?: DEFAULT_FUEL
        }
    }

    private companion object {
        const val PREFERENCES_NAME = "FlutterSharedPreferences"
        const val PREFERENCES_PREFIX = "flutter."
        const val PREFERENCES_KEY = "filter_gas"
        val DEFAULT_FUEL = FuelType.PETROL_SUPER_E5
    }
}
