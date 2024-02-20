//
//  ConvertorLocationDTO.swift
//  iWeather
//
//  Created by Steven Kirke on 20.02.2024.
//

import Foundation

protocol IConvertorLocationDTO: AnyObject {
	func convert(forecastDTO: Forecast?) -> [MainHomeModel.Request.Hour]
}

final class ConvertorLocationDTO: IConvertorHourDTO {
	func convert(forecastDTO: Forecast?) -> [MainHomeModel.Request.Hour] {
		convertHours(forecastDTO: forecastDTO)
	}
}

private extension ConvertorLocationDTO {
	func convertHours(forecastDTO: Forecast?) -> [MainHomeModel.Request.Hour] {
		var convertHours: [MainHomeModel.Request.Hour] = []
		if let currentDay = forecastDTO, let hours = currentDay.hours {
			convertHours = hours.map { MainHomeModel.Request.Hour(from: $0) }
		}
		return convertHours
	}
}
