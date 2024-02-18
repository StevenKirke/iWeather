//
//  MainHomeIterator.swift
//  iWeather
//
//  Created by Steven Kirke on 13.02.2024.
//

import Foundation

protocol IMainHomeIterator: AnyObject {
	/**
	 Запрос на список городов.
	 */
	func fetchCityList()
	/**
	 Запрос на температуру для текущего города.
	 - Parameters:
		- coordinate: The cubes available for allocation
	 - Returns: Возвращает температуру или ошибку.
	 */
	func fetchTemperatureForCity(coordinate: RCoordinate, response: @escaping (Result<Int, Error>) -> Void)

	func fetchCurrentLocation()
}

final class MainHomeIterator {

	// MARK: - Public properties

	// MARK: - Dependencies
	var presenter: IMainHomePresenter?
	var worker: IMainHomeWorker?

	// MARK: - Private properties

	// MARK: - Initializator
	internal init(presenter: IMainHomePresenter?, worker: IMainHomeWorker?) {
		self.presenter = presenter
		self.worker = worker
	}

	// MARK: - Lifecycle

	// MARK: - Public methods

	// MARK: - Private methods
}

// MARK: - Fetch data.
extension MainHomeIterator: IMainHomeIterator {
	func fetchCityList() {
		self.worker?.fetchDataCityList { responseCity in
			switch responseCity {
			case .success(let cities):
				self.addCities(cities: cities) { citiesWithTemp in
					self.presenter?.presentCities(response: .successCities(citiesWithTemp))
				}
			case .failure(let error):
				self.presenter?.presentCities(response: .failure(error))
			}
		}
	}

	// Запрос прогноза погоды для города.
	func fetchTemperatureForCity(coordinate: RCoordinate, response: @escaping (Result<Int, Error>) -> Void) {
		self.worker?.fetchDataWeatherTest(cityCoordinate: coordinate, model: TemperatureDTO.self) { responseWeather in
			switch responseWeather {
			case .success(let weather):
				response(.success(weather.fact.temp))
			case .failure(let error):
				response(.failure(error))
			}
		}
	}

	func fetchCurrentLocation() {
		Task.init {
			await self.worker?.fetchCoordinate { responseCurrentCoordinate in
				switch responseCurrentCoordinate {
				case .success(let coordinate):
					self.getWeatherForCurrentLocation(coordinate: coordinate)
				case .failure(let error):
					self.presenter?.presentCities(response: .failure(error))
				}
			}
		}
	}
}

// - MARK: Handler request cities.
private extension MainHomeIterator {
	func addCities(cities: CitiesDTO, resultCities: @escaping ([MainHomeModel.Request.City]) -> Void) {
		/// Убираем лишние города из массива, по заданию 10.
		let subCities = cities.items.prefix(10)
		/// Конвертируем данным в формат  MainHomeModel.Request.City.
		let cities = subCities.map { MainHomeModel.Request.City(from: $0) }
		/// Добавляем текущую температуру к городам.
		self.addWeatherInCity(cities: cities) { cities in
			resultCities(cities)
		}
	}

	/// Добавление температуры к в списку городов.
	func addWeatherInCity(
		cities: [MainHomeModel.Request.City],
		resultCities: @escaping ([MainHomeModel.Request.City]
		) -> Void) {
		// Добавление группы задач, для отслеживание записи данных температуры для всех городов.
		let group = DispatchGroup()
		var tempCities: [MainHomeModel.Request.City] = []
		for city in cities {
			group.enter()
			var city = MainHomeModel.Request.City(
				cityName: city.cityName,
				coordinate: city.coordinate,
				temperature: 0,
				errorDescription: ""
			)
			self.fetchTemperatureForCity(coordinate: city.coordinate) { resultTemperature in
				switch resultTemperature {
				case .success(let temperature):
					let temp = temperature
					city.temperature = temp
				case .failure(let error):
					city.errorDescription = error.localizedDescription
				}
				tempCities.append(city)
				group.leave()
			}
		}
		group.notify(queue: .main) {
			resultCities(tempCities)
		}
	}
}

// - MARK: Handler request weather for current location (City).
private extension MainHomeIterator {
	func getWeatherForCurrentLocation(coordinate: RCoordinate) {
		self.worker?.fetchDataWeatherTest(cityCoordinate: coordinate, model: WeatherDTO.self) { responseWeather in
			switch responseWeather {
			case .success(let weather):
				let hours = self.convertHours(forecast: weather.forecasts.first)
				self.presenter?.presentCities(response: .successHours(hours))
			case .failure(let error):
				self.presenter?.presentCities(response: .failure(error))
			}
		}
	}
	private func convertHours(forecast: Forecast?) -> [MainHomeModel.Request.Hour] {
		var convertHours: [MainHomeModel.Request.Hour] = []
		if let currentDay = forecast, let hours = currentDay.hours {
			convertHours = hours.map { MainHomeModel.Request.Hour(from: $0) }
		}
		return convertHours
	}
}
