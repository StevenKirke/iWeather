//
//  ConvertorWeatherForLocationDTO.swift
//  iWeather
//
//  Created by Steven Kirke on 20.02.2024.
//

import Foundation

protocol IConvertorWeatherForLocationDTO: AnyObject {
	func convertDTO(weatherDTO: WeatherDTO) -> MainHomeModel.Request.Location
}

final class ConvertorWeatherForLocationDTO: IConvertorWeatherForLocationDTO {

	// MARK: - Public properties

	// MARK: - Dependencies
	let timeConvertServices = TimeConvertServices()

	// MARK: - Private properties
	private var currentLocation = MainHomeModel.Request.Location(
		name: "",
		data: "",
		currentTemperature: "",
		minTemp: "",
		maxTemp: "",
		condition: "",
		icon: "",
		timeOfDay: ""
	)

	private struct CurrentMinMaxTemp {
		var minTemp: String
		var maxTemp: String
	}

	// MARK: - Public methods
	func convertDTO(weatherDTO: WeatherDTO) -> MainHomeModel.Request.Location {
		convert(weather: weatherDTO)
	}
}

private extension ConvertorWeatherForLocationDTO {
	private func convert(weather: WeatherDTO) -> MainHomeModel.Request.Location {
		var minMaxTemp: CurrentMinMaxTemp = CurrentMinMaxTemp(minTemp: "", maxTemp: "")

		if let currentForecast = weather.forecasts.first {
			minMaxTemp = answerTimesOfDay(dayTime: weather.fact.daytime, parts: currentForecast.parts)
		}

		currentLocation = MainHomeModel.Request.Location(
			name: convertNameCity(nameCity: weather.geoObject.locality.name),
			data: convertDateInShort(weather: weather),
			currentTemperature: convertToString(weather.fact.temp),
			minTemp: minMaxTemp.minTemp,
			maxTemp: minMaxTemp.maxTemp,
			condition: weather.fact.condition.rawValue,
			icon: convertIconURLString(icon: weather.fact.icon),
			timeOfDay: weather.fact.daytime.rawValue
		)

		return currentLocation
	}
}

private extension ConvertorWeatherForLocationDTO {
	// Добавление URL для иконки погоды.
	func convertIconURLString(icon: String) -> String {
		"https://yastatic.net/weather/i/icons/funky/dark/\(icon).svg"
	}

	// Удаление из названия города, лишних знаков.
	func convertNameCity(nameCity: String) -> String {
		let cropSlash = nameCity.components(separatedBy: "/")
		if let name = cropSlash.last {
			return croppingText(text: name)
		}
		return ""
	}

	// Удаление из названия города, лишних знаков.
	func croppingText(text: String) -> String {
		text.replacingOccurrences(of: "_", with: " ")
	}

	// Конвертация даты в формат “20 Apr Wed”.
	func convertDateInShort(weather: WeatherDTO) -> String {
		if let currentForecast = weather.forecasts.first {
			return timeConvertServices.convertData(dataString: currentForecast.date)
		}
		return ""
	}

	// Выбор минимальной и максимальной температуры, в зависимости от времени суток.
	private func answerTimesOfDay(dayTime: Daytime, parts: Parts) -> CurrentMinMaxTemp {
		var temperature: CurrentMinMaxTemp = CurrentMinMaxTemp(minTemp: "", maxTemp: "")

		switch dayTime {
		case .d:
			temperature.minTemp = convertToString(parts.day.tempMin)
			temperature.maxTemp = convertToString(parts.day.tempMin)
		case .n:
			temperature.minTemp = convertToString(parts.night.tempMin)
			temperature.maxTemp = convertToString(parts.night.tempMin)
		}
		return temperature
	}

	func convertToString(_ tempInt: Int?) -> String {
		guard let temp = tempInt else { return "" }
		return String(temp)
	}
}
