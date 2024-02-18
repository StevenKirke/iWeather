//
//  SitiesDTO.swift
//  iWeather
//
//  Created by Steven Kirke on 16.02.2024.
//

import Foundation

/// Массив городов.
struct CitiesDTO: Decodable {
	let items: [Item]
}

/// Информация по городу.
struct Item: Codable {
	/// Название населенного пункта.
	let name: String
	/// Название населенного пункта на английском.
	let english: String
	/// Широта.
	let latitude: Double
	/// Долгота.
	let longitude: Double
}
