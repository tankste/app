package app.tankste.station.usecase

import app.tankste.station.model.StationModel
import kotlinx.coroutines.flow.Flow

interface GetStationsUseCase {

    operator fun invoke(): Flow<Result<List<StationModel>>>
}