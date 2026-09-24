package app.tankste.favorite.ui.widget

import android.content.Context
import androidx.glance.GlanceId
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import app.tankste.favorite.di.favoriteWidgetScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.koin.core.component.KoinComponent

class FavoriteListWidgetWorker(
    private val appContext: Context,
    private val params: WorkerParameters
) : CoroutineWorker(appContext, params), KoinComponent {

    private val glanceId: GlanceId
        get() = params.inputData.getInt("appWidgetId", -1)
            .takeIf { it != -1 }
            ?.let { GlanceAppWidgetManager(appContext).getGlanceIdBy(it) }
            ?: throw IllegalArgumentException("Invalid appWidgetId")

    val controller = getKoin()
        .favoriteWidgetScope(context = appContext, glanceId = glanceId)
        .get<FavoriteListController>()

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        controller.onDataRequested()

        FavoriteListWidget().update(applicationContext, glanceId)
        Result.success()
    }
}