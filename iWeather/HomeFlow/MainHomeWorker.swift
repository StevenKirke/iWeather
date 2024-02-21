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
	 Запрос получения прогноза погоды для населенного пункта.
	 - Parameters:
			- cityCoordinate: Координаты населенного пункта.
	 - Returns: Возвращает модель CitiesDTO или ошибку.
	 */
	func fetchWeather<T: Decodable>(
		coordinates: RCoordinate, model: T.Type, response: @escaping (Result<T, Error>
		) -> Void
	)

	/// Запрос текущий координат устройства.
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

	// Запрос списка городов.
	// Метод отключен так как есть лимит запросов в сутки. Вместо него используется Mock файл.
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

	func fetchWeather<T: Decodable>(
		coordinates: RCoordinate, model: T.Type, response: @escaping (Result<T, Error>) -> Void
		) {
		let url = assemblerURL?.assemblerUlRsTemperature(lat: coordinates.latitude, lon: coordinates.longitude)
		guard let currentURL = url else { return }

		let requestURL = assemblerRequestURL?.assemblerURLRequest(url: currentURL)
		guard let currentRequestURL = requestURL else { return }

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
