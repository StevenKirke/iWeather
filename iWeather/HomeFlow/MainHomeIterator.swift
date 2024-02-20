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
	func fetchTemperatureForCity(coordinate: RCoordinate, response: @escaping (Result<(Int, String), Error>) -> Void)

	func fetchCurrentLocation(coordinate: MainHomeModel.Response.Coordinate?)
}

final class MainHomeIterator {

	// MARK: - Public properties

	// MARK: - Dependencies
	var presenter: IMainHomePresenter?
	var worker: IMainHomeWorker?
	let convertorCityDTO: IConvertorCityDTO?
	let convertorHourDTO: IConvertorHourDTO?
	let convertorWeatherForLocationDTO: IConvertorWeatherForLocationDTO?

	// MARK: - Private properties
	let convertDate = TimeConvertServices()

	// MARK: - Initializator
	internal init(
		presenter: IMainHomePresenter?,
		worker: IMainHomeWorker?,
		convertorCityDTO: IConvertorCityDTO?,
		convertorHourDTO: IConvertorHourDTO?,
		convertorWeatherForLocationDTO: IConvertorWeatherForLocationDTO?
	) {
		self.presenter = presenter
		self.worker = worker
		self.convertorCityDTO = convertorCityDTO
		self.convertorHourDTO = convertorHourDTO
		self.convertorWeatherForLocationDTO = convertorWeatherForLocationDTO
	}
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
	func fetchTemperatureForCity(coordinate: RCoordinate, response: @escaping (Result<(Int, String), Error>) -> Void) {
		self.worker?.fetchWeather(coordinates: coordinate, model: TemperatureDTO.self) { responseWeather in
			switch responseWeather {
			case .success(let weather):
				response(.success((weather.fact.temp, weather.fact.condition.iconType)))
			case .failure(let error):
				response(.failure(error))
			}
		}
	}

	func fetchCurrentLocation(coordinate: MainHomeModel.Response.Coordinate?) {
		if let currentCoordinate = coordinate {
			let coord: RCoordinate = RCoordinate(
				latitude: currentCoordinate.latitude,
				longitude: currentCoordinate.longitude
			)
			self.getWeatherForCurrentLocation(coordinate: coord)
		} else {
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
			self.fetchTemperatureForCity(coordinate: city.coordinate) { resultTemperature in
				switch resultTemperature {
				case .success(let tempAndCondition):
						if var currentCity = self.convertorCityDTO?.convert(cityDTO: city) {
						currentCity.temperature = tempAndCondition.0
						currentCity.condition = tempAndCondition.1
						currentCity.conditionType = tempAndCondition.1
						tempCities.append(currentCity)
						group.leave()
					}
				case .failure(let error):
					print("Error")
				}
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
		self.worker?.fetchWeather(coordinates: coordinate, model: WeatherDTO.self) { responseWeather in
			switch responseWeather {
			case .success(let weather):
				self.transferHour(forecast: weather.forecasts.first)
				self.transferWeatherLocation(weather: weather)
			case .failure(let error):
				self.presenter?.presentCities(response: .failure(error))
			}
		}
	}

	// Передача температуры и иконки погоды, на сутки с интервалом 1 час.
	func transferHour(forecast: Forecast?) {
		guard let currentForecast = forecast else { return }
		guard let hours = self.convertorHourDTO?.convert(forecastDTO: currentForecast) else { return }

		self.presenter?.presentCities(response: .successHours(hours))
	}

	// Передача погоды для выбранной локации.
	func transferWeatherLocation(weather: WeatherDTO) {
		guard let location = self.convertorWeatherForLocationDTO?.convertDTO(weatherDTO: weather) else { return }
		self.presenter?.presentCities(response: .successCurrentLocation(location))
	}
}
