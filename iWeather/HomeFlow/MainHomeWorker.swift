//
//  MainHomeWorker.swift
//  iWeather
//
//  Created by Steven Kirke on 16.02.2024.
//

import Foundation

protocol IMainHomeWorker: AnyObject {
	/**
	 Запрос получения списка городов
	 - Returns: Возвращает модель CitiesDTO или ошибку.
	 */
	func fetchDataCityList(response: @escaping (Result<CitiesDTO, Error>) -> Void)
	/**
	 Запрос получения температуры населенного пункта.
	 - Parameters:
			- cityCoordinate: Координаты населенного пункта.

	 - Returns: Возвращает модель CitiesDTO или ошибку.
	 */
	func fetchDataWeather(
		cityCoordinate: MainHomeModel.Request.Coordinate,
		response: @escaping (Result<TemperatureDTO, Error>) -> Void
	)

	func fetchDataWeatherTest<T: Decodable>(
		cityCoordinate: RCoordinate, model: T.Type,
		response: @escaping (Result<T, Error>) -> Void
	)

	func fetchCoordinate(resultCoordinate: @escaping (Result<RCoordinate, Error>) -> Void) async
}

final class MainHomeWorker {

	// MARK: - Public properties
	private let fileName = "CitiesMock"

	// MARK: - Dependencies
	var networkManager: INetworkManager?
	var decodeJSONManager: IDecodeJsonManager?
	var assemblerURL: IAssemblerURLService?
	var assemblerRequestURL: IAssemblerURLRequestService?
	var fileManager: IWriteFileManager?
	var locationManager: ILocationManager?

	// MARK: - Initializator
	internal init(
		networkManager: INetworkManager?,
		decodeJSONManager: IDecodeJsonManager?,
		assemblerURL: IAssemblerURLService?,
		assemblerRequestURL: IAssemblerURLRequestService?,
		fileManager: IWriteFileManager?,
		locationManager: ILocationManager?
	) {
		self.networkManager = networkManager
		self.decodeJSONManager = decodeJSONManager
		self.assemblerURL = assemblerURL
		self.assemblerRequestURL = assemblerRequestURL
		self.fileManager = fileManager
		self.locationManager = locationManager
	}
}

// - MARK: Fetch DATA.
extension MainHomeWorker: IMainHomeWorker {

	func fetchDataCityList(response: @escaping (Result<CitiesDTO, Error>) -> Void) {
		let citiesURL = assemblerURL?.assemblerUlRsCities()
		print(citiesURL)
		fileManager?.getFile(resource: fileName, type: .json) { result in
			switch result {
			case .success(let data):
					self.decodeData(data: data, model: CitiesDTO.self) { resultJSON in
					switch resultJSON {
					case .success(let json):
						response(.success(json))
					case .failure(let error):
						response(.failure(error))
					}
				}
			case .failure(let error):
				response(.failure(error))
			}
		}
	}


	func fetchData() {
//		let citiesURL = assemblerURL?.assemblerUlRsCities()
//		print(citiesURL)
//		networkManager?.getData(url: citiesURL) { response in
//			switch response {
//			case .success(let data):
//				self.decode(data: data)
//			case .failure(let error):
//				print("Error \(response)")
//			}
//		}
	}


	func fetchDataWeather(
		cityCoordinate: MainHomeModel.Request.Coordinate,
		response: @escaping (Result<TemperatureDTO, Error>) -> Void
	) {
		let url = assemblerURL?.assemblerUlRsTemperature(
			lat: cityCoordinate.latitude,
			lon: cityCoordinate.longitude
		)

		guard let currentURL = url else {
			print("Failure URL")
			return
		}

		let requestURL = assemblerRequestURL?.assemblerURLRequest(url: currentURL)
		guard let currentRequestURL = requestURL else {
			print("Failure RequestURL")
			return
		}
		networkManager?.getData(request: currentRequestURL) { result in
			switch result {
			case .success(let data):
				self.decodeData(data: data, model: TemperatureDTO.self) { resultJSON in
				switch resultJSON {
				case .success(let json):
					response(.success(json))
				case .failure(let error):
					response(.failure(error))
				}
			}
			case .failure(let error):
				response(.failure(error))
			}
		}
	}

	func fetchCoordinate(resultCoordinate: @escaping (Result<RCoordinate, Error>) -> Void) async {
		await locationManager?.getLocation { coordinate in
			switch coordinate {
			case .success(let coordinate):
				let coordinate = RCoordinate(latitude: coordinate.latitude, longitude: coordinate.longitude)
				resultCoordinate(.success(coordinate))
			case .failure(let error):
				resultCoordinate(.failure(error))
			}
		}
	}

	func fetchDataWeatherTest<T: Decodable>(
		cityCoordinate: RCoordinate, model: T.Type,
		response: @escaping (Result<T, Error>) -> Void
	) {
			let url = assemblerURL?.assemblerUlRsTemperature(
				lat: cityCoordinate.latitude,
				lon: cityCoordinate.longitude
			)

			guard let currentURL = url else {
				print("Failure URL")
				return
			}

			let requestURL = assemblerRequestURL?.assemblerURLRequest(url: currentURL)
			guard let currentRequestURL = requestURL else {
				print("Failure RequestURL")
				return
			}

		networkManager?.getData(request: currentRequestURL) { result in
			switch result {
			case .success(let data):
					self.decodeData(data: data, model: model) { resultJSON in
				switch resultJSON {
				case .success(let json):
					response(.success(json))
				case .failure(let error):
					response(.failure(error))
				}
			}
			case .failure(let error):
				response(.failure(error))
			}
		}
		}
}

// - MARK: Decode JSON
private extension MainHomeWorker {
	func decodeData<T: Decodable>(data: Data, model: T.Type, response: @escaping (Result<T, Error>) -> Void) {
		decodeJSONManager?.decodeJSON(data: data, model: model) { resultJSON in
			switch resultJSON {
			case .success(let json):
				response(.success(json))
			case .failure(let error):
				response(.failure(error))
			}
		}
	}
}
