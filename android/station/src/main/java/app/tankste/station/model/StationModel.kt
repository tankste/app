package app.tankste.station.model

import app.tankste.navigation.model.CoordinateModel

data class StationModel(
    val id: String,
    val name: String,
    val company: String,
    val address: Address,
    val prices: Prices?,
    val coordinate: CoordinateModel,
    val isOpen: Boolean,
) {

    val label: String
        get() = name.takeIf(String::isNotBlank) ?: company

    data class Address(
        val street: String,
        val houseNumber: String,
        val postCode: String,
        val city: String,
    )

    data class Prices(
        val e5: Double,
        val e5Range: PriceRange,
        val e10: Double,
        val e10Range: PriceRange,
        val diesel: Double,
        val dieselRange: PriceRange
    ) {

        fun getFirstPrice(): Double? =
            e5.takeIf { p -> p != 0.0 }
            ?: e10.takeIf { p -> p != 0.0 }
            ?: diesel.takeIf { p -> p != 0.0 }

        fun getFirstPriceRange(): PriceRange? =
            e5Range.takeIf { r -> r != PriceRange.UNKNOWN }
                ?: e10Range.takeIf { r -> r != PriceRange.UNKNOWN }
                ?: dieselRange.takeIf { r -> r != PriceRange.UNKNOWN }

        enum class PriceRange {
            UNKNOWN,
            CHEAP,
            NORMAL,
            EXPENSIVE,
        }
    }
}