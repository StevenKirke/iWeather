//
//  AssemblerURLRequestService.swift
//  iWeather
//
//  Created by Steven Kirke on 17.02.2024.
//

import Foundation

protocol IAssemblerURLRequestService: AnyObject {
	/// Сборщик Request.
	func assemblerURLRequest(url: URL) -> URLRequest
}

final class AssemblerURLRequestService: IAssemblerURLRequestService {
	func assemblerURLRequest(url: URL) -> URLRequest {
		let token = "4d6abbab-31a4-4b3c-affe-f61463113343"

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue( "\(token)", forHTTPHeaderField: "X-Yandex-API-Key")

		return request
	}
}
