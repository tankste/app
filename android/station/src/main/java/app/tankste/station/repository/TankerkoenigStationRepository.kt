package app.tankste.station.repository

import android.content.Context
import app.tankste.station.api.TankerkoenigApi
import app.tankste.navigation.model.CoordinateModel
import app.tankste.core.R
import app.tankste.station.model.StationModel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

class TankerkoenigStationRepository(
    private val context: Context,
    private val tankerkoenigApi: TankerkoenigApi
) : StationRepository {

    override fun list(type: String, coordinate: CoordinateModel): Flow<Result<List<StationModel>>> =
        flow {
            val response = tankerkoenigApi.list(
                coordinate.latitude,
                coordinate.longitude,
                type,
                context.getString(R.string.tankerkoenig_api_key)
            )
            when {
                response.isSuccessful -> {
                    val stations = response
                        .body()
                        ?.toModelList(
                            when (type) {
                                "e10" ->
                                    StationListDto.PriceType.E10
                                "diesel" ->
                                    StationListDto.PriceType.DIESEL
                                else ->
                                    StationListDto.PriceType.E5
                            }
                        )
                        ?: emptyList()

                    emit(Result.success(stations))
                }
                else -> {
                    throw Exception("Server error: ${response.code()} - ${response.message()}")
                }
            }
        }
}