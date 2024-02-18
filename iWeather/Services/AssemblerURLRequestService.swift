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
		let token = "05830f3e-5ba7-4a1a-98f2-bc2cf5d7e3cf"

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue( "\(token)", forHTTPHeaderField: "X-Yandex-API-Key")

		return request
	}
}
