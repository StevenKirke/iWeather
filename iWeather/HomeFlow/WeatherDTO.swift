//
//  WeatherDTO.swift
//  iWeather
//
//  Created by Steven Kirke on 18.02.2024.
//

import Foundation

// swiftlint:disable all
struct WeatherDTO: Decodable {
	let fact: FactDTO
	let geoObject: GeoObject
	let forecasts: [Forecast]

	enum CodingKeys: String, CodingKey {
		case fact
		case forecasts
		case geoObject = "geo_object"
	}
}

// MARK: - Fact
struct FactDTO: Codable {
	let temp: Int
	let icon: String
	let condition: Condition
	let daytime: Daytime

	enum CodingKeys: String, CodingKey {
		case temp
		case icon
		case condition
		case daytime
	}
}

struct GeoObject: Codable {
	let locality: Locality
}

struct Locality: Codable {
	let name: String
}

enum Condition: String, Codable {
	case clear = "clear"
	case cloudy = "cloudy"
	case cloudyAndLightRain = "cloudy-and-light-rain"
	case overcast = "overcast"
	case overcastAndLightRain = "overcast-and-light-rain"
	case overcastAndRain = "overcast-and-rain"
	case partlyCloudy = "partly-cloudy"
	case partlyCloudyAndRain = "partly-cloudy-and-rain"
	case overcastAndWetSnow = "overcast-and-wet-snow"
	case overcastAndLightSnow = "overcast-and-light-snow"
	case cloudyAndSnow = "cloudy-and-snow"
}

enum Daytime: String, Codable {
	case d = "d"
	case n = "n"
}

// MARK: - Forecast
struct Forecast: Decodable {
	let parts: Parts
	let date: String
	let hours: [HourDTO]?

	enum CodingKeys: String, CodingKey {
		case parts
		case date
		case hours
	}
}

struct HourDTO: Codable {
	let hour: String
	let icon: String
	let temp: Int

	enum CodingKeys: String, CodingKey {
		case hour
		case icon
	    case temp
	}
}

struct Parts: Decodable {
	let day: Day
	let night: Day
	let dayShort: Day
	let nightShort: Day
	let morning: Day
	let evening: Day

	enum CodingKeys: String, CodingKey {
		case day
		case night
		case dayShort = "day_short"
		case nightShort = "night_short"
		case morning
		case evening
	}
}

struct Day: Decodable {
	let tempMin: Int?
	let	tempMax: Int?
	let icon: String

	enum CodingKeys: String, CodingKey {
		case tempMin = "temp_min"
		case tempMax = "temp_max"
		case icon
	}
}

struct Yesterday: Codable {
	let temp: Int
}
// swiftlint:enable all
