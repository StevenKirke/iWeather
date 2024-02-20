//
//  ConvertorHourDTO.swift
//  iWeather
//
//  Created by Steven Kirke on 20.02.2024.
//

import Foundation

protocol IConvertorHourDTO: AnyObject {
	func convert(forecastDTO: Forecast?) -> [MainHomeModel.Request.Hour]
}

final class ConvertorHourDTO: IConvertorHourDTO {
	func convert(forecastDTO: Forecast?) -> [MainHomeModel.Request.Hour] {
		convertHours(forecastDTO: forecastDTO)
	}
}

private extension ConvertorHourDTO {
	func convertHours(forecastDTO: Forecast?) -> [MainHomeModel.Request.Hour] {
		var convertHours: [MainHomeModel.Request.Hour] = []
		if let currentDay = forecastDTO, let hours = currentDay.hours {
			convertHours = hours.map {
				convertHour(modelRequest: $0)
			}
		}
		return convertHours
	}

	func convertHour(modelRequest: HourDTO) -> MainHomeModel.Request.Hour {
		MainHomeModel.Request.Hour(
			hour: modelRequest.hour,
			icon: addLink(icon: modelRequest.icon),
			temp: addDegree(temp: modelRequest.temp))
	}

	func addDegree(temp: Int) -> String {
		return "\(temp)\u{00B0}C"
	}

	func addLink(icon: String) -> String {
		"https://yastatic.net/weather/i/icons/funky/dark/\(icon).svg"
	}
}
