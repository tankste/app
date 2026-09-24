package app.tankste.favorite.ui.widget

import android.appwidget.AppWidgetManager
import android.content.Context
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import androidx.work.Constraints
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequest
import androidx.work.WorkManager
import androidx.work.workDataOf
import kotlin.time.Duration.Companion.minutes
import kotlin.time.toJavaDuration

class FavoriteListWidgetReceiver : GlanceAppWidgetReceiver() {

    override val glanceAppWidget = FavoriteListWidget()

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)

        val workManager = WorkManager.getInstance(context)

        appWidgetIds.forEach { appWidgetId ->
            workManager.enqueueUniquePeriodicWork(
                "favorite-widget-worker-periodical-$appWidgetId",
                ExistingPeriodicWorkPolicy.KEEP,
                PeriodicWorkRequest.Builder(
                    FavoriteListWidgetWorker::class.java,
                    15.minutes.toJavaDuration(),
                )
                    .setConstraints(
                        Constraints.Builder()
                            .setRequiredNetworkType(NetworkType.CONNECTED)
                            .setRequiresBatteryNotLow(true)
                            .build()
                    )
                    .setInputData(workDataOf("appWidgetId" to appWidgetId))
                    .build(),
            )

            // Ensures the widget loads immediately when initialized again
            workManager.enqueueUniqueWork(
                "favorite-widget-worker-onetime-$appWidgetId",
                ExistingWorkPolicy.KEEP,
                OneTimeWorkRequestBuilder<FavoriteListWidgetWorker>()
                    .setInputData(workDataOf("appWidgetId" to appWidgetId))
                    .setConstraints(
                        Constraints.Builder()
                            .setRequiredNetworkType(NetworkType.CONNECTED)
                            .build()
                    )
                    .build(),
            )
        }
    }

    override fun onDeleted(
        context: Context,
        appWidgetIds: IntArray,
    ) {
        val workManager = WorkManager.getInstance(context)

        appWidgetIds.forEach { appWidgetId ->
            workManager.cancelUniqueWork("favorite-widget-worker-periodical-$appWidgetId")
            workManager.cancelUniqueWork("favorite-widget-worker-onetime-$appWidgetId")
        }

        super.onDeleted(context, appWidgetIds)
    }
}