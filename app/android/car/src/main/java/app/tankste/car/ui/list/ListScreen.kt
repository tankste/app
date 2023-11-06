package app.tankste.car.ui.list

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.net.Uri
import androidx.car.app.CarContext
import androidx.car.app.CarToast
import androidx.car.app.HostException
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.CarIcon
import androidx.car.app.model.CarLocation
import androidx.car.app.model.ItemList
import androidx.car.app.model.Metadata
import androidx.car.app.model.Place
import androidx.car.app.model.PlaceListMapTemplate
import androidx.car.app.model.PlaceMarker
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.core.graphics.drawable.IconCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import app.tankste.station.model.StationModel
import org.koin.core.component.KoinComponent
import org.koin.core.component.inject

class ListScreen(carContext: CarContext) : Screen(carContext), KoinComponent {

    private val viewModel: ListViewModel by inject()
    private var isLoading: Boolean = true
    private var items: List<ListViewModel.ListItem> = emptyList()

    init {
        lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onCreate(owner: LifecycleOwner) {
                viewModel.isLoading.observe(this@ListScreen) { isLoading ->
                    this@ListScreen.isLoading = isLoading
                    invalidate()
                }

                viewModel.items.observe(this@ListScreen) { items ->
                    this@ListScreen.items = items
                    invalidate()
                }
            }
        })
    }

    override fun onGetTemplate(): Template {
        if (isLoading) {
            return PlaceListMapTemplate.Builder()
                .setHeaderAction(Action.APP_ICON)
                .setTitle("tankste!")
                .setCurrentLocationEnabled(true)
                .setLoading(isLoading)
                .build()
        }

        val itemListBuilder = ItemList.Builder()
        items.forEach { item ->
            itemListBuilder
                .addItem(
                    Row.Builder()
                        .setTitle(item.title)
                        .addText("${item.price} • ${item.distance}")
                        .setBrowsable(true)
                        .setOnClickListener {
                            val uri = Uri.parse("geo:0,0?q=${item.latitude},${item.longitude}(${item.title})")
                            val intent = Intent(CarContext.ACTION_NAVIGATE, uri)

                            try {
                                carContext.startCarApp(intent);
                            } catch (e: HostException) {
                                CarToast.makeText(
                                    getCarContext(),
                                    "Fehler! Navigation konnte nicht gestartet werden.",
                                    CarToast.LENGTH_LONG
                                )
                                    .show();
                            }
                        }
                        .setMetadata(
                            Metadata.Builder()
                                .setPlace(
                                    Place.Builder(
                                        CarLocation.create(
                                            item.latitude,
                                            item.longitude
                                        )
                                    )
                                        .setMarker(
                                            PlaceMarker.Builder()
                                                .setIcon(
                                                    CarIcon.Builder(
                                                        IconCompat.createWithBitmap(
                                                            createPriceIcon(
                                                                item.priceLabel,
                                                                item.priceCategory
                                                            )
                                                        )
                                                    )
                                                        .build(),
                                                    PlaceMarker.TYPE_IMAGE
                                                )
                                                .build()
                                        )
                                        .build()
                                )
                                .build(),
                        )
                        .build()
                )
                .build()
        }

        return PlaceListMapTemplate.Builder()
            .setHeaderAction(Action.APP_ICON)
            .setTitle("tankste!")
            .setCurrentLocationEnabled(true)
            .setLoading(false)
            .setItemList(itemListBuilder.build())
            .build()
    }

    private fun createPriceIcon(
        price: String,
        priceCategory: ListViewModel.ListItem.PriceCategory
    ): Bitmap {
        val bitmap = Bitmap.createBitmap(72, 72, Bitmap.Config.ARGB_8888)

        val canvas = Canvas(bitmap)

        canvas.drawColor(
            when (priceCategory) {
                ListViewModel.ListItem.PriceCategory.CLOSED -> Color.parseColor("#858585")
                ListViewModel.ListItem.PriceCategory.CHEAP -> Color.parseColor("#008000")
                ListViewModel.ListItem.PriceCategory.MEDIUM -> Color.parseColor("#EBA209")
                ListViewModel.ListItem.PriceCategory.EXPENSIVE -> Color.parseColor("#AF0000")
            }
        )

        val textPaint = Paint().apply {
            textSize = 28f
            color = Color.WHITE
        }
        canvas.drawText(price, 0, 5, 4f, 48f, textPaint)

        return bitmap
    }
}