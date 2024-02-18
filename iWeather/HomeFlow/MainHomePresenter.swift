//
//  MainHomePresenter.swift
//  iWeather
//
//  Created by Steven Kirke on 13.02.2024.
//

import Foundation

protocol IMainHomePresenter: AnyObject {
	func presentCities(response: MainHomeModel.Request)
}

final class MainHomePresenter {

	// MARK: - Public properties

	// MARK: - Dependencies

	// MARK: - Private properties

	// MARK: - Initializator
	internal init(viewController: IMainHomeViewLogic?) {
		self.viewController = viewController
	}

	// MARK: - Lifecycle
	private weak var viewController: IMainHomeViewLogic?

	// MARK: - Public methods

	// MARK: - Private methods

}

extension MainHomePresenter: IMainHomePresenter {
	func presentCities(response: MainHomeModel.Request) {
		switch response {
		case .successCities(let cities):
			let model = convertInModelCity(responseModel: cities)
			viewController?.renderCity(viewModel: model)
		case .successHours(let hours):
			let model = convertInModelHour(responseModel: hours)
			viewController?.renderHour(viewModel: model)
		case .failure(let error):
			print("Error \(error)")
		}
		// viewController?.render()
	}
}

private extension MainHomePresenter {
	func convertInModelCity(responseModel: [MainHomeModel.Request.City]) -> [MainHomeModel.ViewModel.City] {
		responseModel.map { MainHomeModel.ViewModel.City(from: $0) }
	}

	func convertInModelHour(responseModel: [MainHomeModel.Request.Hour]) -> [MainHomeModel.ViewModel.Hour] {
		responseModel.map { MainHomeModel.ViewModel.Hour(from: $0) }
	}
}
