//
//  MainHomeModel.swift
//  iWeather
//
//  Created by Steven Kirke on 13.02.2024.
//

import Foundation

/// Представление для - Request.Coordinate.
typealias RCoordinate = MainHomeModel.Request.Coordinate

/// Представление для - ViewModel.Coordinate.
typealias WCoordinate = MainHomeModel.ViewModel.Coordinate

// swiftlint:disable nesting
enum MainHomeModel {

	enum Response {
		case location(Coordinate)

		struct Coordinate {
			let latitude: Double
			let longitude: Double
		}
	}

	enum Request {
		case successCities([City])
		case successCurrentLocation(Location)
		case successHours([Hour])
		case failure(Error)

		struct Location {
			let name: String
			let data: String
			let currentTemperature: String
			let minTemp: String
			let maxTemp: String
			let condition: String
			let timeOfDay: String
		}

		struct City {
			let cityName: String
			let coordinate: Coordinate
			var temperature: Int
			var condition: String
			var conditionType: String
			var errorDescription: String
		}

		struct Weather {
			let cityName: String
			let cityEngName: String
			let coordinate: Coordinate
		}

		struct Coordinate {
			let latitude: Double
			let longitude: Double
		}

		struct Hour {
			let hour: String
			let icon: String
			let temp: String
		}
	}

	enum ViewModel {
		case success([City])
		case successHours([Hour])
		case successWeatherLocation([Hour])
		case failure(Error)

		struct City {
			let title: String
			let imagePath: String
			let coordinate: Coordinate
			var conditionType: String
			var errorDescription: String
		}

		struct Hour {
			let hour: String
			let icon: String
			let temp: String
		}

		struct Coordinate {
			let latitude: Double
			let longitude: Double
		}

		struct WeatherLocation {
			let name: String
			let currentTemp: String
			let condition: String
			let dateAndTemp: String
			let backgroundImage: String
		}
	}
}
// swiftlint:enable nesting

// Маппинг CitiesDTO.Item
extension MainHomeModel.Request.City {
	init(from: Item) {
		self.init(
			cityName: from.english,
			coordinate: RCoordinate(from: from),
			temperature: 0,
			condition: "",
			conditionType: "",
			errorDescription: ""
		)
	}
}

// Маппинг Item
extension MainHomeModel.Request.Coordinate {
	init(from: Item) {
		self.init(latitude: from.latitude, longitude: from.longitude)
	}
}

extension MainHomeModel.ViewModel.City {
	init(from: MainHomeModel.Request.City) {
		self.init(
			title: Self.convertTitleDegree(text: from.cityName, temp: from.temperature),
			imagePath: from.condition,
			coordinate: MainHomeModel.ViewModel.Coordinate(from: from.coordinate),
			conditionType: Self.showCondition(condition: from.conditionType),
			errorDescription: from.errorDescription
		)
	}

	private static func convertTitleDegree(text: String, temp: Int) -> String {
		let degree = "\u{00B0}"
		let assembler = "\(text) \(temp)\(degree)C"
		return assembler
	}

	private static func convertConditionTypeToImage(conditionType: String) -> String {
		conditionType
	}

	private static func showCondition(condition: String) -> String {
		var image = ""
		switch condition {
		case "clear":
			image = "ImageWeather/clear"
		case "cloudy":
			image = "ImageWeather/cloudy"
		case "overcast":
			image = "ImageWeather/overcast"
		case "rain":
			image = "ImageWeather/rain"
		case "snow":
			image = "ImageWeather/snow"
		default:
		image = ""
		}
		return image
	}
}

// Маппинг Item
extension MainHomeModel.ViewModel.Coordinate {
	init(from: RCoordinate) {
		self.init(latitude: from.latitude, longitude: from.longitude)
	}
}

extension MainHomeModel.ViewModel.Hour {
	init(from: MainHomeModel.Request.Hour) {
		self.init(hour: Self.convertHour(hour: from.hour), icon: from.icon, temp: from.temp)
	}

	private static func convertHour(hour: String) -> String {
		let dateFormate = DateFormatter()
		let fullTime = "\(hour):00:00"
		dateFormate.dateFormat = "HH:mm:ss"
		let convertInDate = dateFormate.date(from: fullTime)

		dateFormate.dateFormat = "hh:mm a"
		let string = dateFormate.string(from: convertInDate!)
		return string
	}
}
