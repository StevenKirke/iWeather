//
//  NetworkManager.swift
//  iWeather
//
//  Created by Steven Kirke on 15.02.2024.
//

import Foundation

protocol INetworkManager {
	func getData(url: URL?, returnModel: @escaping (Result<Data, ErrorResponse>) -> Void)
	func getData(request: URLRequest, response: @escaping (Result<Data, Error>) -> Void)
}

enum ErrorResponse: Error {
	/// Ошибка, конвертации URL.
	case errorConvertURL
	/// Ошибка, состояния ответа HTTP.
	case errorResponse
	/// Ошибка, запроса HTTP.
	case errorRequest(String)
	/// Пустая Data.
	case errorEmptyData

	var title: String {
		var textError = ""
		switch self {
		case .errorConvertURL:
			textError = "Invalid URL conversion."
		case .errorResponse:
			textError = "Invalid Response received from the server."
		case .errorRequest(let error):
			textError = "Post Request -  \(error)"
		case .errorEmptyData:
			textError = "Nil Data."
		}
		return textError
	}
}

final class NetworkManager: INetworkManager {

	// MARK: - Private properties
	private let task = URLSession.shared

	// MARK: - Public methods
	func getData(url: URL?, returnModel: @escaping (Result<Data, ErrorResponse>) -> Void) {
		guard let currentUrl = url else {
			returnModel(.failure(.errorConvertURL))
			return
		}
		let request = URLRequest(url: currentUrl)

		let dataTask = task.dataTask(with: request) { data, _, error in
			DispatchQueue.main.async {
				if let currentError = error {
					returnModel(.failure(.errorRequest(currentError.localizedDescription)))
				}
				guard let currentData = data else {
					returnModel(.failure(.errorEmptyData))
					return
				}
				returnModel(.success(currentData))
			}
		}
		dataTask.resume()
	}

	func getData(request: URLRequest, response: @escaping (Result<Data, Error>) -> Void) {
		let session = URLSession.shared
		let task = session.dataTask(with: request) { data, _, error in
			if let currentError = error {
				print("CurrentError \(currentError)")
			}
			if let currentData = data {
				response(.success(currentData))
			}
		}
		task.resume()
	}
}
