package app.tankste.station.repository

import com.squareup.moshi.JsonClass
import app.tankste.navigation.model.CoordinateModel
import app.tankste.station.model.StationModel


@JsonClass(generateAdapter = true)
data class StationListDto(
    val stations: List<StationListItemDto>?,
) {

    fun toModelList(type: PriceType): List<StationModel> {
        return stations?.map { s -> s.toModel(type) }
            ?: emptyList()
    }

    @JsonClass(generateAdapter = true)
    data class StationListItemDto(
        val id: String?,
        val name: String?,
        val brand: String?,
        val street: String?,
        val houseNumber: String?,
        val postCode: Int?,
        val place: String?,
        val price: Double?,
        val lat: Double?,
        val lng: Double?,
        val isOpen: Boolean?
    ) {

        fun toModel(type: PriceType) = StationModel(
            id = id ?: "",
            name = name ?: "",
            company = brand ?: "",
            address = StationModel.Address(
                street = street ?: "",
                houseNumber = houseNumber ?: "",
                postCode = postCode?.toString() ?: "",
                city = place ?: "",
            ),
            prices = StationModel.Prices(
                e5 = if (type == PriceType.E5) price ?: 0.0 else 0.0,
                e10 = if (type == PriceType.E10) price ?: 0.0 else 0.0,
                diesel = if (type == PriceType.DIESEL) price ?: 0.0 else 0.0,
                e5Range = StationModel.Prices.PriceRange.UNKNOWN,
                e10Range = StationModel.Prices.PriceRange.UNKNOWN,
                dieselRange = StationModel.Prices.PriceRange.UNKNOWN
            ),
            coordinate = CoordinateModel(
                latitude = lat ?: 0.0,
                longitude = lng ?: 0.0,
            ),
            isOpen = isOpen ?: false
        )
    }

    enum class PriceType {
        E5,
        E10,
        DIESEL
    }
}
