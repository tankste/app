package app.tankste.favorite.di

import android.content.Context
import androidx.glance.GlanceId
import androidx.glance.appwidget.GlanceAppWidgetManager
import app.tankste.client.station.repository.MarkerRepository
import app.tankste.client.station.repository.impl.TanksteWebMarkerRepository
import app.tankste.favorite.repository.FavoriteRepository
import app.tankste.favorite.repository.PreferencesFavoriteRepository
import app.tankste.favorite.ui.widget.FavoriteListController
import org.koin.core.Koin
import org.koin.core.qualifier.named
import org.koin.core.scope.Scope
import org.koin.dsl.module

private val FavoriteWidgetScope = named("FavoriteWidget")

val favoriteModule = module {

    single<FavoriteRepository> { PreferencesFavoriteRepository(context = get()) }
    single<MarkerRepository> { TanksteWebMarkerRepository() }

    scope(FavoriteWidgetScope) {
        scoped {
            FavoriteListController(
                favoriteRepository = get(),
                markerRepository = get(),
                fuelTypeRepository = get(),
                currencyRepository = get(),
            )
        }
    }
}

internal fun Koin.favoriteWidgetScope(
    context: Context,
    glanceId: GlanceId,
): Scope {
    return getOrCreateScope(
        scopeId = favoriteWidgetScopeId(context, glanceId),
        qualifier = FavoriteWidgetScope,
    )
}

private fun favoriteWidgetScopeId(
    context: Context,
    glanceId: GlanceId,
): String {
    val appWidgetId = GlanceAppWidgetManager(context)
        .getAppWidgetId(glanceId)

    return "favorite-widget-$appWidgetId"
}