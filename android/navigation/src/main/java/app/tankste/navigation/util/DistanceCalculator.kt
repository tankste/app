package app.tankste.navigation.util

import android.location.Location
import app.tankste.navigation.model.CoordinateModel

class DistanceCalculator {

    companion object {

        fun calculateMeterDistance(start: CoordinateModel, end: CoordinateModel): Float {
            val result = FloatArray(1)
            Location.distanceBetween(
                start.latitude,
                start.longitude,
                end.latitude,
                end.longitude,
                result
            )
            return result[0]
        }
    }
}