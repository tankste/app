package app.tankste.car.ui.list

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.util.Log
import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.CarColor
import androidx.car.app.model.CarIcon
import androidx.car.app.model.CarLocation
import androidx.car.app.model.Item
import androidx.car.app.model.ItemList
import androidx.car.app.model.Metadata
import androidx.car.app.model.Pane
import androidx.car.app.model.PaneTemplate
import androidx.car.app.model.Place
import androidx.car.app.model.PlaceListMapTemplate
import androidx.car.app.model.PlaceMarker
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.core.graphics.drawable.IconCompat
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.map
import androidx.lifecycle.viewModelScope
import app.tankste.station.model.StationModel
import app.tankste.station.usecase.GetStationsUseCase
import kotlinx.coroutines.launch
import java.lang.Math.round
import java.math.RoundingMode
import java.text.DecimalFormat
import kotlin.math.roundToInt


class ListViewModel(
    private val getStationsUseCase: GetStationsUseCase,
) : ViewModel() {

    private val _stations = MutableLiveData<List<StationModel>>()

    val items: LiveData<List<ListItem>>
        get() = _stations.map { r ->
            r.map { station ->
                val priceCategory = when {
                    !station.isOpen ->
                        ListItem.PriceCategory.CLOSED
                    StationModel.Prices.PriceRange.CHEAP in listOf(
                        station.prices?.e5Range,
                        station.prices?.e10Range,
                        station.prices?.dieselRange
                    ) ->
                        ListItem.PriceCategory.CHEAP
                    StationModel.Prices.PriceRange.NORMAL in listOf(
                        station.prices?.e5Range,
                        station.prices?.e10Range,
                        station.prices?.dieselRange
                    ) ->
                        ListItem.PriceCategory.MEDIUM
                    StationModel.Prices.PriceRange.EXPENSIVE in listOf(
                        station.prices?.e5Range,
                        station.prices?.e10Range,
                        station.prices?.dieselRange
                    ) ->
                        ListItem.PriceCategory.EXPENSIVE
                    else -> ListItem.PriceCategory.CLOSED
                }

                val price = station.prices?.getFirstPrice() ?: 0.0
                var priceText = if (!station.isOpen || price == 0.0) {
                    "-,--\u207B"
                } else {
                    price.toString().replace(".", ",");
                }

                if (priceText.length == 5) {
                    priceText = priceText.substring(0, 4) + priceText.substring(4)
                        .replace("0", "\u2070")
                        .replace("1", "\u00B9")
                        .replace("2", "\u00B2")
                        .replace("3", "\u00B3")
                        .replace("4", "\u2074")
                        .replace("5", "\u2075")
                        .replace("6", "\u2076")
                        .replace("7", "\u2077")
                        .replace("8", "\u2078")
                        .replace("9", "\u2079");
                }

                val distance = station.coordinate.distanceMeters ?: 0f
                val distanceText = if (distance == 0f) {
                    ""
                } else if (distance >= 1000) {
                    val kilometers = distance / 1000f

                    val format = DecimalFormat("#.#")
                    format.roundingMode = RoundingMode.UP
                    val value = format.format(kilometers).replace(".", ",")
                    "${value}km"
                } else {
                    val value = distance.roundToInt()
                    "${value}m"
                }

                ListItem(
                    title = station.label,
                    price = "$priceText€",
                    priceLabel = priceText,
                    priceCategory = priceCategory,
                    distance = distanceText,
                    latitude = station.coordinate.latitude,
                    longitude = station.coordinate.longitude
                )
            }
        }

    val isLoading: LiveData<Boolean>
        get() = _stations.map { v -> v == null }

    init {
        fetchStations()
    }

    private fun fetchStations() {
        viewModelScope.launch {
            getStationsUseCase()
                .collect { result ->
                    Log.d("debug", "result: $result")
                    result.exceptionOrNull()?.printStackTrace()
                    //TODO: show error
                    _stations.postValue(result.getOrDefault(emptyList()))
                }
        }
    }

    data class ListItem(
        val title: String,
        val price: String,
        val priceLabel: String,
        val priceCategory: PriceCategory,
        val distance: String,
        val latitude: Double,
        val longitude: Double,
    ) {

        enum class PriceCategory {
            CLOSED,
            CHEAP,
            MEDIUM,
            EXPENSIVE
        }
    }
}