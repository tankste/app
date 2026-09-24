package app.tankste.station.ui

import app.tankste.client.station.model.FuelType
import app.tankste.station.R

val FuelType.labelRes: Int
    get() = when (this) {
        FuelType.UNKNOWN -> R.string.fuel_label_unknown
        FuelType.PETROL -> R.string.fuel_label_petrol
        FuelType.PETROL_SUPER_E5 -> R.string.fuel_label_petrol_super_e5
        FuelType.PETROL_SUPER_E10 -> R.string.fuel_label_petrol_super_e10
        FuelType.PETROL_SUPER_PLUS -> R.string.fuel_label_petrol_super_plus
        FuelType.PETROL_SUPER_E5_ADDITIVE -> R.string.fuel_label_petrol_super_e5_additive
        FuelType.PETROL_SUPER_E10_ADDITIVE -> R.string.fuel_label_petrol_super_e10_additive
        FuelType.PETROL_SUPER_PLUS_ADDITIVE -> R.string.fuel_label_petrol_super_plus_additive
        FuelType.DIESEL -> R.string.fuel_label_diesel
        FuelType.DIESEL_HVO100 -> R.string.fuel_label_diesel_hvo100
        FuelType.DIESEL_ADDITIVE -> R.string.fuel_label_diesel_additive
        FuelType.DIESEL_HVO100_ADDITIVE -> R.string.fuel_label_diesel_hvo100_additive
        FuelType.DIESEL_TRUCK -> R.string.fuel_label_diesel_truck
        FuelType.DIESEL_HVO100_TRUCK -> R.string.fuel_label_diesel_hvo100_truck
        FuelType.LPG -> R.string.fuel_label_lpg
        FuelType.ADBLUE -> R.string.fuel_label_adblue
    }