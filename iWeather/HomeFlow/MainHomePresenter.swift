//
//  MainHomePresenter.swift
//  iWeather
//
//  Created by Steven Kirke on 13.02.2024.
//

import Foundation

typealias MainHomeClosure = () -> Void

protocol IMainHomePresenter: AnyObject {

	func presentCities(response: MainHomeModel.Request)
	/// Отображение профиля.
	func showProfileView()
	/// Переход на следующий поток.
	func showMenuWScene()
}

final class MainHomePresenter {

	// MARK: - Public properties

	// MARK: - Dependencies
	private var mainHomeClosure: MainHomeClosure?
	private var mainHomeAlertDelegate: IMainHomeAlertDelegate?
	// MARK: - Private properties

	// MARK: - Initializator
	internal init(
		viewController: IMainHomeViewLogic?,
		mainHomeAlertDelegate: IMainHomeAlertDelegate?,
		mainHomeClosure: MainHomeClosure?
	) {
		self.viewController = viewController
		self.mainHomeAlertDelegate = mainHomeAlertDelegate
		self.mainHomeClosure = mainHomeClosure
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
			let searchCurrentTime = overkillCurrentTime(hours: hours)
			let model = convertInModelListHours(responseModel: searchCurrentTime)
			viewController?.renderHour(viewModel: model)
		case .failure(let error):
			break
			mainHomeAlertDelegate?.showAlertView(massage: error.localizedDescription)
		}
	}

	func showProfileView() {
		mainHomeAlertDelegate?.showAlertView(massage: "Hell world.")
	}

	func showMenuWScene() {
		mainHomeClosure?()
	}
}

// MARK: - Convert Cities
private extension MainHomePresenter {
	func convertInModelListCities(responseModel: [MainHomeModel.Request.City]) -> [MainHomeModel.ViewModel.City] {
		responseModel.map {
			return MainHomeModel.ViewModel.City(from: $0)
		}
	}
}

// MARK: - Convert Hour
private extension MainHomePresenter {
	func convertInModelListHours(responseModel: [MainHomeModel.Request.Hour]) -> [MainHomeModel.ViewModel.Hour] {
		responseModel.map {return MainHomeModel.ViewModel.Hour(from: $0) }
	}

	private func overkillCurrentTime(hours: [MainHomeModel.Request.Hour]) -> [MainHomeModel.Request.Hour] {
		let currentHour = String(getCurrentTime())
		var newHours: [MainHomeModel.Request.Hour] = []
		var newHour: MainHomeModel.Request.Hour?
		var
		_ = hours.map {
			if $0.hour == currentHour {
				let hour = MainHomeModel.Request.Hour(
					hour: "Now",
					icon: $0.icon,
					temp: $0.temp
				)
				newHours.insert(hour, at: 0)
			} else if $0.hour == "0" {
				newHour = $0
			} else {
				newHours.append($0)
			}
		}
		if let currentHour = newHour {
			newHours.append(currentHour)
		}
		return newHours
	}

	private func getCurrentTime() -> Int {
		let date = Date()
		let calendar = Calendar.current
		return calendar.component(.hour, from: date)
	}
}

// MARK: - Convert Location
private extension MainHomePresenter {
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
