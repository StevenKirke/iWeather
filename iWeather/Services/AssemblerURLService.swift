//
//  AssemblerURLService.swift
//  iWeather
//
//  Created by Steven Kirke on 16.02.2024.
//

import Foundation

protocol IAssemblerURLService: AnyObject {
	/// Сборщик URL для запроса списка городов.
	func assemblerUlRsCities() -> URL?
	/// Сборщик URL для запроса температуры для конкретного города.
	func assemblerUlRsTemperature(lat: Double, lon: Double) -> URL?
}

final class AssemblerURLCities: IAssemblerURLService {
	func assemblerUlRsCities() -> URL? {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "htmlweb.ru"
		components.path = "/json/geo/city_list"
		components.queryItems = [
			 URLQueryItem(name: "country", value: "russia"),
			 URLQueryItem(name: "api_key", value: "3ebb7b4bbc7f104159df626ddc56904f"),
			 URLQueryItem(name: "level", value: "1")
		 ]
		return components.url
	}

	func assemblerUlRsTemperature(lat: Double, lon: Double) -> URL? {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "api.weather.yandex.ru"
		components.path = "/v1/forecast"
		components.queryItems = [
			 URLQueryItem(name: "lat", value: "\(lat)"),
			 URLQueryItem(name: "lon", value: "\(lon)"),
			 URLQueryItem(name: "limit", value: "1")
		 ]
		return components.url
	}
}
