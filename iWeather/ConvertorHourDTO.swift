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
			convertHours = hours.map { MainHomeModel.Request.Hour(from: $0) }
		}
		return convertHours
	}
}
