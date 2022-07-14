package app.tankste.station.repository

import app.tankste.navigation.model.CoordinateModel
import app.tankste.station.model.StationModel
import kotlinx.coroutines.flow.Flow


interface StationRepository {

    //TOOD: `type` should be an enum
    fun list(type: String, coordinate: CoordinateModel): Flow<Result<List<StationModel>>>
}