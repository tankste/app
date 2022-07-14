package app.tankste.navigation.repository

import app.tankste.navigation.model.CoordinateModel
import kotlinx.coroutines.flow.Flow

interface LocationRepository {

    fun getCurrentLocation(): Flow<Result<CoordinateModel>>
}