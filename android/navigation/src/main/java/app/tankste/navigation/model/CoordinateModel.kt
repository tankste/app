package app.tankste.navigation.model

data class CoordinateModel(
    val latitude: Double,
    val longitude: Double,
    val distanceMeters: Float? = null
)