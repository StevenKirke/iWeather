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
			let model = convertInModelListCities(responseModel: cities)
			viewController?.renderCity(viewModel: model)
		case .successCurrentLocation(let location):
			let model = convertInModelLocation(responseModel: location)
			viewController?.renderWeatherLocal(viewModel: model)
		case .successHours(let hours):
			let model = convertInModelListHours(responseModel: hours)
			viewController?.renderHour(viewModel: model)
		case .failure(let error):
			print("Error \(error)")
		}
	}
}

private extension MainHomePresenter {
	func convertInModelListCities(responseModel: [MainHomeModel.Request.City]) -> [MainHomeModel.ViewModel.City] {
		responseModel.map {
			return MainHomeModel.ViewModel.City(from: $0)
		}
	}

	func convertInModelListHours(responseModel: [MainHomeModel.Request.Hour]) -> [MainHomeModel.ViewModel.Hour] {
		responseModel.map { MainHomeModel.ViewModel.Hour(from: $0) }
	}

	func convertInModelLocation(responseModel: MainHomeModel.Request.Location) ->
	MainHomeModel.ViewModel.WeatherLocation {
		MainHomeModel.ViewModel.WeatherLocation(
			name: responseModel.name,
			currentTemp: addDegree(temp: responseModel.currentTemperature),
			condition: responseModel.condition,
			dateAndTemp: assemblerDateAndTemp(responseModel: responseModel),
			backgroundImage: responseModel.timeOfDay
		)
	}

	func assemblerDateAndTemp(responseModel: MainHomeModel.Request.Location) -> String {
		let data = responseModel.data
		let minTemp = addDegree(temp: responseModel.minTemp)
		let maxTemp = addDegree(temp: responseModel.maxTemp)
		let assembler = "\(data) \(minTemp)/\(maxTemp)"
		return assembler
	}

	func addDegree(temp: String) -> String {
		return "\(temp)\u{00B0}C"
	}

	func addURL(urlString: String) -> URL? {
		if let currentURL = URL(string: urlString) {
			return currentURL
		}
		return nil
	}
}
