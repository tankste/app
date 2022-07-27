package app.tankste.station.usecase

import android.hardware.SensorManager
import android.util.Log
import app.tankste.navigation.model.CoordinateModel
import app.tankste.navigation.repository.LocationRepository
import app.tankste.navigation.util.DistanceCalculator
import app.tankste.station.model.StationModel
import app.tankste.station.repository.PreferencesRepository
import app.tankste.station.repository.StationRepository
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.flow.transform


class GetStationsUseCaseImpl(
    private val stationRepository: StationRepository,
    private val locationRepository: LocationRepository,
    private val preferencesRepository: PreferencesRepository,
) : GetStationsUseCase {

    override fun invoke(): Flow<Result<List<StationModel>>> =
        locationRepository.getCurrentLocation().transform { locationResult ->
            stationRepository.list(
                preferencesRepository.getStringPreference("filter_gas") ?: "e5",
                locationResult.getOrThrow()
            )
                .collect { result ->
                    if (result.isFailure) {
                        emit(result)
                        return@collect
                    }

                    val stations = result.getOrThrow()
                    if (stations.isEmpty()) {
                        emit(result)
                    }

                    val minE5Price = stations.filter { s -> s.prices != null && s.prices.e5 != 0.0 }
                        .minOfOrNull { s -> s.prices!!.e5 }
                    val minE10Price =
                        stations.filter { s -> s.prices != null && s.prices.e10 != 0.0 }
                            .minOfOrNull { s -> s.prices!!.e10 }
                    val minDieselPrice =
                        stations.filter { s -> s.prices != null && s.prices.diesel != 0.0 }
                            .minOfOrNull { s -> s.prices!!.diesel }

                    emit(Result.success(stations.map { station ->
                        station.copy(
                            coordinate = station.coordinate.copy(
                                distanceMeters = DistanceCalculator.calculateMeterDistance(locationResult.getOrThrow(), station.coordinate)
                            ),
                            prices = station.prices?.copy(
                                e5Range = getPriceRange(minE5Price ?: 0.0, station.prices.e5),
                                e10Range = getPriceRange(minE10Price ?: 0.0, station.prices.e10),
                                dieselRange = getPriceRange(minDieselPrice ?: 0.0, station.prices.diesel),
                            )
                        )
                    }))
                }
        }
            .onEach { r -> if (r.isFailure) throw r.exceptionOrNull()!! }
            .catch { e ->
                e.printStackTrace()
                emit(Result.failure(e))
            }

    private fun getPriceRange(minPrice: Double, price: Double): StationModel.Prices.PriceRange {
        if (price == 0.0) {
            return StationModel.Prices.PriceRange.UNKNOWN;
        }

        if (minPrice + 0.04 >= price) {
            return StationModel.Prices.PriceRange.CHEAP;
        } else if (minPrice + 0.10 >= price) {
            return StationModel.Prices.PriceRange.NORMAL;
        } else {
            return StationModel.Prices.PriceRange.EXPENSIVE;
        }
    }
}