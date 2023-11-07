package app.tankste.navigation.repository

import android.annotation.SuppressLint
import app.tankste.navigation.model.CoordinateModel
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.Priority
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine
import android.location.Location

class GoogleLocationRepository(
    private val locationClient: FusedLocationProviderClient
) : LocationRepository {

    //TODO: show permission error on car display (better UX & user helping)
    @SuppressLint("MissingPermission")
    override fun getCurrentLocation(): Flow<Result<CoordinateModel>> = flow {
//        try {
        val location = suspendCoroutine<Location?> { continuation ->
            // TODO: should we relly need `Priority.PRIORITY_HIGH_ACCURACY`? Test this and evaluate best priority type
            locationClient.getCurrentLocation(Priority.PRIORITY_HIGH_ACCURACY, null)
                .addOnSuccessListener { location ->
                    continuation.resume(location)
                }
                .addOnFailureListener { exception ->
                    continuation.resumeWithException(exception)
                }
        }

        location?.let { loc ->
            emit(Result.success(CoordinateModel(loc.latitude, loc.longitude)))
        }
//        } catch (e: Exception) {
//            emit(Result.failure(e))
//        }
    }
}