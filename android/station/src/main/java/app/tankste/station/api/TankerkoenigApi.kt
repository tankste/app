package app.tankste.station.api

import app.tankste.station.repository.StationListDto
import retrofit2.Response
import retrofit2.http.GET
import retrofit2.http.Query

interface TankerkoenigApi {

    @GET("list.php?rad=15&sort=dist")
    suspend fun list(
        @Query("lat") lat: Double,
        @Query("lng") lng: Double,
        @Query("type") type: String,
        @Query("apikey") apiKey: String
    ): Response<StationListDto>
}