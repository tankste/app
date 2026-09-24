package app.tankste.core.ui

import app.tankste.client.currency.model.CurrencyModel
import app.tankste.client.currency.model.CurrencyType
import java.util.Locale

object PriceFormat {

    private val superscriptDigits = mapOf(
        '0' to '\u2070',
        '1' to '\u00B9',
        '2' to '\u00B2',
        '3' to '\u00B3',
        '4' to '\u2074',
        '5' to '\u2075',
        '6' to '\u2076',
        '7' to '\u2077',
        '8' to '\u2078',
        '9' to '\u2079',
    )

    fun format(
        price: Double,
        currency: CurrencyModel,
        withCurrencySymbol: Boolean,
    ): String {
        val currencySymbol = if (withCurrencySymbol) currency.symbol else null
        return when (currency.currency) {
            CurrencyType.EUR -> formatThreeDecimal(price, currencySymbol)
            CurrencyType.DKK -> formatTwoDecimal(price, currencySymbol)
            CurrencyType.UNKNOWN, CurrencyType.ISK -> formatOneDecimal(price, currencySymbol)
        }
    }

    private fun formatThreeDecimal(price: Double, currencySymbol: String?): String {
        var priceText = if (price == 0.0) {
            "-,--\u207B"
        } else {
            String.format(Locale.US, "%.3f", price).replace('.', ',')
        }

        if (priceText.length == 5) {
            superscriptDigits[priceText[4]]?.let { superscript ->
                priceText = priceText.substring(0, 4) + superscript
            }
        }

        return if (currencySymbol != null) "$priceText $currencySymbol" else priceText
    }

    private fun formatOneDecimal(price: Double, currencySymbol: String?): String {
        val priceText = if (price == 0.0) {
            "---,-"
        } else {
            String.format(Locale.US, "%.1f", price).replace('.', ',')
        }

        return if (currencySymbol != null) "$priceText $currencySymbol" else priceText
    }

    private fun formatTwoDecimal(price: Double, currencySymbol: String?): String {
        val priceText = if (price == 0.0) {
            "--,--"
        } else {
            String.format(Locale.US, "%.2f", price).replace('.', ',')
        }

        return if (currencySymbol != null) "$priceText $currencySymbol" else priceText
    }
}
