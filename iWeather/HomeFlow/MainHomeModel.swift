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
			let icon: String
		}

		struct City {
			let cityName: String
			let coordinate: Coordinate
			var temperature: Int
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
			let coordinate: Coordinate
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
			let icon: URL?
		}
	}
}
// swiftlint:enable nesting

// Маппинг CitiesDTO.Item
extension MainHomeModel.Request.City {
	init(from: Item) {
		self.init(
			cityName: from.name,
			coordinate: RCoordinate(from: from),
			temperature: 0,
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
			coordinate: MainHomeModel.ViewModel.Coordinate(from: from.coordinate),
			errorDescription: from.errorDescription
		)
	}

	private static func convertTitleDegree(text: String, temp: Int) -> String {
		let degree = "\u{00B0}"
		let assembler = "\(text) \(temp)\(degree)C"
		return assembler
	}
}

// Маппинг Item
extension MainHomeModel.ViewModel.Coordinate {
	init(from: RCoordinate) {
		self.init(latitude: from.latitude, longitude: from.longitude)
	}
}

extension MainHomeModel.Request.Hour {
	init(from: HourDTO) {
		self.init(hour: from.hour, icon: Self.addLink(icon: from.icon), temp: Self.addDegree(temp: from.temp))
	}

	private static func addDegree(temp: Int) -> String {
		return "\(temp)\u{00B0}C"
	}

	private static func addLink(icon: String) -> String {
		"https://yastatic.net/weather/i/icons/funky/dark/\(icon).svg"
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

		// dateFormate.dateFormat = "HH:mm"
		dateFormate.dateFormat = "hh:mm a"
		let string = dateFormate.string(from: convertInDate!)
		return string
	}
}

extension MainHomeModel.Request.Location {
	init(
		name: String,
		dateString: String,
		currentTemp: String,
		minTemp: String,
		maxTemp: String,
		condition: String,
		icon: String
	) {
		self.init(
			name: name,
			data: dateString,
			currentTemperature: currentTemp,
			minTemp: minTemp,
			maxTemp: maxTemp,
			condition: condition,
			icon: icon
		)
	}
}

extension MainHomeModel.ViewModel.WeatherLocation {
	init(
		name: String,
		currentTemp: String,
		condition: String,
		assembler: String,
		icon: URL?
	) {
		self.init(name: name,
				  currentTemp: currentTemp,
				  condition: condition,
				  dateAndTemp: assembler,
				  icon: icon
		)
	}
}
