package app.tankste.favorite.ui.widget

import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.DpSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.max
import androidx.compose.ui.unit.sp
import androidx.glance.ColorFilter
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.ImageProvider
import androidx.glance.LocalContext
import androidx.glance.LocalSize
import androidx.glance.action.ActionParameters
import androidx.glance.appwidget.CircularProgressIndicator
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.SizeMode
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.components.CircleIconButton
import androidx.glance.appwidget.components.Scaffold
import androidx.glance.appwidget.cornerRadius
import androidx.glance.appwidget.lazy.LazyColumn
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.fillMaxWidth
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.size
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextAlign
import androidx.glance.text.TextStyle
import androidx.glance.unit.ColorProvider
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.OutOfQuotaPolicy
import androidx.work.WorkManager
import androidx.work.workDataOf
import app.tankste.favorite.R
import app.tankste.favorite.di.favoriteWidgetScope
import org.koin.core.component.KoinComponent
import app.tankste.core.R as CoreR

@SuppressLint("RestrictedApi")
class FavoriteListWidget : GlanceAppWidget(), KoinComponent {

    override val sizeMode: SizeMode = SizeMode.Responsive(
        setOf(
            DpSize(128.dp, 128.dp),
            DpSize(256.dp, 128.dp),
        )
    )

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        val controller = getKoin()
            .favoriteWidgetScope(context = context, glanceId = id)
            .get<FavoriteListController>()

        provideContent {
            Content(controller)
        }
    }

    @Composable
    private fun Content(controller: FavoriteListController) {
        val context = LocalContext.current
        val size = LocalSize.current

        val state by controller.state.collectAsState(initial = FavoriteListController.State.Loading)

        Scaffold(
            backgroundColor = ColorProvider(CoreR.color.background),
            titleBar = {
                Box(
                    GlanceModifier
                        .fillMaxWidth()
                        .padding(horizontal = 10.dp, vertical = 8.dp)
                        .background(CoreR.color.primary)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = GlanceModifier.fillMaxWidth()
                    ) {
                        if (size.width >= 256.dp || state !is FavoriteListController.State.Favorites) {
                            Image(
                                provider = ImageProvider(CoreR.drawable.ic_logo_white_24dp),
                                contentDescription = null,
                                colorFilter = ColorFilter.tint(ColorProvider(CoreR.color.on_primary)),
                                modifier = GlanceModifier
                                    .size(32.dp)
                            )
                        } else {
                            Box(GlanceModifier.height(32.dp)) {}
                        }

                        Spacer(modifier = GlanceModifier.defaultWeight())

                        (state as? FavoriteListController.State.Favorites)?.let { favoritesState ->
                            if (size.width >= 256.dp) {
                                Text(
                                    text = context.getString(favoritesState.fuelStringRes) ,
                                    style = TextStyle(
                                        fontSize = 12.sp,
                                        color = ColorProvider(CoreR.color.on_primary)
                                    ),
                                )

                                Text(
                                    text = "•",
                                    style = TextStyle(
                                        fontSize = 12.sp,
                                        color = ColorProvider(CoreR.color.on_primary)
                                    ),
                                    modifier = GlanceModifier.padding(horizontal = 4.dp)
                                )
                            }

                            Text(
                                text = context.getString(
                                    R.string.favorite_widget_updated,
                                    favoritesState.time,
                                ),
                                style = TextStyle(
                                    fontSize = 12.sp,
                                    color = ColorProvider(CoreR.color.on_primary)
                                ),
                            )
                        }
                    }
                }
            },
            horizontalPadding = 0.dp,
        ) {
            Box(contentAlignment = Alignment.BottomEnd, modifier = GlanceModifier.fillMaxSize()) {
                when (val currentState = state) {
                    is FavoriteListController.State.Loading -> {
                        Box(
                            contentAlignment = Alignment.Center,
                            modifier = GlanceModifier.fillMaxSize()
                        ) {
                            CircularProgressIndicator(color = ColorProvider(CoreR.color.primary))
                        }
                    }

                    is FavoriteListController.State.Error -> {
                        Box(
                            contentAlignment = Alignment.Center,
                            modifier = GlanceModifier.fillMaxSize()
                        ) {
                            Error(details = currentState.details)
                        }
                    }

                    FavoriteListController.State.Empty ->
                        Box(
                            contentAlignment = Alignment.Center,
                            modifier = GlanceModifier.fillMaxSize()
                        ) {
                            Empty()
                        }

                    is FavoriteListController.State.Favorites -> {
                        ListContent(currentState, size.width)
                    }
                }

                Box(GlanceModifier.padding(4.dp)) {
                    CircleIconButton(
                        ImageProvider(R.drawable.ic_refresh_black_24dp),
                        null,
                        onClick = actionRunCallback<RefreshAction>(),
                        contentColor = ColorProvider(CoreR.color.on_primary),
                        backgroundColor = ColorProvider(CoreR.color.primary),
                        modifier = GlanceModifier.size(48.dp)
                    )
                }
            }
        }
    }

    @Composable
    private fun ListContent(state: FavoriteListController.State.Favorites, width: Dp) {
        val useHorizonalItem = width >= 256.dp

        LazyColumn(
            modifier = GlanceModifier
                .fillMaxSize()
                .background(CoreR.color.background)
        ) {
            state.items.forEachIndexed { index, item ->
                if (index > 0) {
                    item { Spacer(modifier = GlanceModifier.height(6.dp)) }

                    item {
                        Box(
                            GlanceModifier
                                .padding(horizontal = 8.dp)
                        ) {
                            Box(
                                modifier = GlanceModifier
                                    .fillMaxWidth()
                                    .background(CoreR.color.divider)
                                    .height(1.dp)
                            ) {}
                        }
                    }
                }
                item { Spacer(modifier = GlanceModifier.height(6.dp)) }

                item {
                    if (useHorizonalItem) {
                        ItemHorizontal(item)
                    } else {
                        ItemVertical(item)
                    }
                }
            }

            item { Spacer(modifier = GlanceModifier.height(max(getWidgetRadius(), 56.dp))) }
        }
    }

    @Composable
    private fun ItemHorizontal(item: FavoriteListController.State.Favorites.Item) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = GlanceModifier
                .padding(horizontal = 8.dp)
                .fillMaxWidth()
        ) {
            Column(
                horizontalAlignment = Alignment.Start,
                modifier = GlanceModifier.defaultWeight()
            ) {
                Text(
                    text = item.nameParts.joinToString(" - "),
                    style = TextStyle(
                        fontWeight = FontWeight.Medium,
                        color = ColorProvider(CoreR.color.text),
                    ),
                    maxLines = 2,
                )

                Text(
                    text = item.city,
                    style = TextStyle(color = ColorProvider(CoreR.color.text_muted)),
                    maxLines = 1,
                )
            }

            Box(GlanceModifier.width(8.dp)) { }

            Text(
                text = item.price,
                style = TextStyle(
                    color = ColorProvider(CoreR.color.white),
                    fontWeight = FontWeight.Medium
                ),
                modifier = GlanceModifier
                    .padding(horizontal = 6.dp, vertical = 3.dp)
                    .background(item.priceColor)
                    .cornerRadius(4.dp)
            )
        }
    }

    @Composable
    private fun ItemVertical(item: FavoriteListController.State.Favorites.Item) {
        Column(
            GlanceModifier
                .padding(horizontal = 8.dp)
                .fillMaxWidth()
        ) {
            Text(
                text = item.nameParts[0],
                style = TextStyle(
                    fontWeight = FontWeight.Medium,
                    color = ColorProvider(CoreR.color.text),
                ),
                maxLines = 1,
            )

            Text(
                text = item.nameParts[1],
                style = TextStyle(
                    fontWeight = FontWeight.Medium,
                    color = ColorProvider(CoreR.color.text),
                ),
                maxLines = 2,
            )

            Text(
                item.city,
                maxLines = 1,
                style = TextStyle(color = ColorProvider(CoreR.color.text_muted))
            )

            Spacer(modifier = GlanceModifier.height(4.dp))

            Text(
                text = item.price,
                style = TextStyle(
                    fontWeight = FontWeight.Bold,
                    color = ColorProvider(item.priceColor)
                ),
            )
        }
    }

    @Composable
    private fun Error(details: String) {
        val context = LocalContext.current

        LazyColumn {
            item {
                Column(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .padding(16.dp)
                ) {
                    Text(
                        text = context.getString(R.string.favorite_widget_error_title),
                        style = TextStyle(
                            fontWeight = FontWeight.Bold,
                            textAlign = TextAlign.Center,
                            color = ColorProvider(CoreR.color.text),
                        )
                    )

                    Text(
                        text = context.getString(R.string.favorite_widget_error_hint),
                        style = TextStyle(
                            textAlign = TextAlign.Center,
                            color = ColorProvider(CoreR.color.text),
                        )
                    )

                    Text(
                        details,
                        style = TextStyle(
                            textAlign = TextAlign.Center,
                            color = ColorProvider(CoreR.color.text_muted),
                        ),
                        modifier = GlanceModifier.padding(top = 16.dp)
                    )
                }
            }
        }
    }

    @Composable
    private fun Empty() {
        val context = LocalContext.current

        LazyColumn {
            item {
                Column(
                    verticalAlignment = Alignment.CenterVertically,
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = GlanceModifier
                        .fillMaxWidth()
                        .padding(16.dp)
                ) {
                    Text(
                        text = context.getString(R.string.favorite_widget_empty_title),
                        style = TextStyle(
                            fontWeight = FontWeight.Bold,
                            textAlign = TextAlign.Center,
                            color = ColorProvider(CoreR.color.text),
                        )
                    )

                    Text(
                        text = context.getString(R.string.favorite_widget_empty_hint),
                        style = TextStyle(
                            textAlign = TextAlign.Center,
                            color = ColorProvider(CoreR.color.text),
                        )
                    )
                }
            }
        }
    }

    @Composable
    private fun getWidgetRadius(): Dp {
        val context = LocalContext.current
        val radiusPx = with(context.resources) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                getDimension(android.R.dimen.system_app_widget_background_radius) / displayMetrics.density
            } else {
                0f
            }
        }
        return radiusPx.dp
    }
}

class RefreshAction : ActionCallback, KoinComponent {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val appWidgetId = GlanceAppWidgetManager(context)
            .getAppWidgetId(glanceId)

        WorkManager.getInstance(context)
            .enqueueUniqueWork(
                "favorite-widget-worker-onetime-$appWidgetId",
                ExistingWorkPolicy.REPLACE,
                OneTimeWorkRequestBuilder<FavoriteListWidgetWorker>()
                    .setInputData(
                        workDataOf("appWidgetId" to appWidgetId)
                    )
                    .setConstraints(
                        androidx.work.Constraints.Builder()
                            .setRequiredNetworkType(androidx.work.NetworkType.CONNECTED)
                            .build()
                    )
                    .setExpedited(OutOfQuotaPolicy.RUN_AS_NON_EXPEDITED_WORK_REQUEST)
                    .build(),
            )
    }
}