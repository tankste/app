package app.tankste.car.di

import app.tankste.car.ui.list.ListViewModel
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.dsl.module


val carModule = module {

    viewModel { ListViewModel(get()) }

}
