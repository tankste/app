package app.tankste.favorite.ui.widget

import androidx.annotation.StringRes
import androidx.compose.ui.graphics.Color
import app.tankste.client.currency.model.CurrencyModel
import app.tankste.client.currency.model.CurrencyType
import app.tankste.client.station.model.FuelType
import app.tankste.client.station.model.MarkerPrice
import app.tankste.client.station.model.PriceState
import app.tankste.client.station.repository.MarkerRepository
import app.tankste.core.ui.PriceFormat
import app.tankste.currency.repository.CurrencyRepository
import app.tankste.favorite.repository.FavoriteRepository
import app.tankste.station.repository.FuelTypeRepository
import app.tankste.station.ui.labelRes
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import java.time.LocalTime
import java.time.format.DateTimeFormatter

class FavoriteListController(
    private val favoriteRepository: FavoriteRepository,
    private val markerRepository: MarkerRepository,
    private val fuelTypeRepository: FuelTypeRepository,
    private val currencyRepository: CurrencyRepository,
) {

    private val _state = MutableStateFlow<State>(State.Loading)
    val state: Flow<State> = _state

    suspend fun onDataRequested() {
        loadFavorites()
    }

    private suspend fun loadFavorites() {
        _state.emit(State.Loading)

        fuelTypeRepository.getSelected()
            .fold(
                onSuccess = { selectedFuelType ->
                    currencyRepository.getSelected()
                        .fold(
                            onSuccess = { selectedCurrency ->
                                loadFavorites(selectedFuelType, selectedCurrency)
                            },
                            onFailure = { exception ->
                                _state.emit(
                                    State.Error(
                                        details = exception.message ?: "Unknown error!"
                                    )
                                )
                            },
                        )
                },
                onFailure = { exception ->
                    _state.emit(State.Error(details = exception.message ?: "Unknown error!"))
                },
            )
    }

    private suspend fun loadFavorites(fuelType: FuelType, homeCurrency: CurrencyModel) {
        _state.emit(State.Loading)

        favoriteRepository.list()
            .fold(
                onSuccess = { favorites ->
                    if (favorites.isEmpty()) {
                        _state.emit(State.Empty)
                        return@fold
                    }

                    val items = favorites.map { station ->
                        val marker = markerRepository.get(station.id).getOrNull()
                        val price = marker?.prices?.firstOrNull { p ->
                            p.fuelType == fuelType
                        } ?: MarkerPrice.empty()
                        val currency = marker?.currency ?: CurrencyModel.unknown
                        val priceString = PriceFormat.format(
                            price = currency.convertTo(
                                amount = price.price,
                                targetCurrency = marker?.currency?.currency ?: CurrencyType.UNKNOWN,
                            ) ?: 0.0,
                            currency = homeCurrency,
                            withCurrencySymbol = true,
                        )

                        State.Favorites.Item(
                            stationId = station.id,
                            nameParts = listOf(station.brand, station.address.street),
                            city = station.address.city,
                            price = if (currency != homeCurrency) "≈$priceString" else priceString,
                            priceColor = when (marker?.prices?.firstOrNull()?.state) {
                                PriceState.EXPENSIVE -> Color(0xFFF44336)
                                PriceState.MEDIUM -> Color(0xFFFF9800)
                                PriceState.CHEAP -> Color(0xFF4CAF50)
                                null,
                                PriceState.UNKNOWN,
                                PriceState.NOT_AVAILABLE -> Color(0xFF9E9E9E)

                            }
                        )
                    }

                    _state.emit(
                        State.Favorites(
                            fuelStringRes = fuelType.labelRes,
                            time = LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm")),
                            items = items,
                        )
                    )
                },
                onFailure = { exception ->
                    _state.emit(State.Error(details = exception.message ?: "Unknown error!"))
                },
            )
    }

    sealed interface State {
        data object Loading : State
        data object Empty : State
        data class Favorites(
            val time: String,
            @StringRes val fuelStringRes: Int,
            val items: List<Item>
        ) : State {
            data class Item(
                val stationId: Int,
                val nameParts: List<String>,
                val city: String,
                val price: String,
                val priceColor: Color,
            )
        }

        data class Error(val details: String) : State
    }
}
