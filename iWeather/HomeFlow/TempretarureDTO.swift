//
//  File.swift
//  iWeather
//
//  Created by Steven Kirke on 17.02.2024.
//

import Foundation

/// Данные по температуре для определенного города..
struct TemperatureDTO: Decodable {
	/// Информация по температуре.
	let fact: Fact
}

struct Fact: Codable {
	/// Текущая температура для населенного пункта.
	let temp: Int
}
