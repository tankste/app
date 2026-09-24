package app.tankste.currency.repository

import android.content.Context
import app.tankste.client.currency.model.CurrencyModel
import app.tankste.client.currency.model.CurrencyType
import app.tankste.client.currency.repository.impl.TanksteLocalCurrencyRepository
import app.tankste.client.currency.repository.CurrencyRepository as ClientCurrencyRepository

interface CurrencyRepository {
    suspend fun list(): Result<List<CurrencyModel>>
    suspend fun getSelected(): Result<CurrencyModel>
}

class PreferencesCurrencyRepository(
    private val context: Context,
    private val clientCurrencyRepository: ClientCurrencyRepository = TanksteLocalCurrencyRepository,
) : CurrencyRepository {

    override suspend fun list(): Result<List<CurrencyModel>> {
        return clientCurrencyRepository.list()
    }

    override suspend fun getSelected(): Result<CurrencyModel> = runCatching {
        val preferences = context.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE)
        val currencyKey = preferences.getString(PREFERENCES_PREFIX + PREFERENCES_KEY, null)
        val currencyType = CurrencyType.entries.firstOrNull { c ->
            c.name.equals(currencyKey, ignoreCase = true)
        } ?: DEFAULT_CURRENCY

        clientCurrencyRepository.list()
            .getOrThrow()
            .first { it.currency == currencyType }
    }

    private companion object {
        const val PREFERENCES_NAME = "FlutterSharedPreferences"
        const val PREFERENCES_PREFIX = "flutter."
        const val PREFERENCES_KEY = "currency"
        val DEFAULT_CURRENCY = CurrencyType.EUR
    }
}
