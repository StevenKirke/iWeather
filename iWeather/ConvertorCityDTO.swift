//
//  ConvertorCityDTO.swift
//  iWeather
//
//  Created by Steven Kirke on 20.02.2024.
//

import Foundation

protocol IConvertorCityDTO: AnyObject {
	func convert(cityDTO: MainHomeModel.Request.City) -> MainHomeModel.Request.City
}

final class ConvertorCityDTO: IConvertorCityDTO {
	func convert(cityDTO: MainHomeModel.Request.City) -> MainHomeModel.Request.City {
		convertDTO(city: cityDTO)
	}
}

private extension ConvertorCityDTO {
	func convertDTO(city: MainHomeModel.Request.City) -> MainHomeModel.Request.City {
		MainHomeModel.Request.City(
			cityName: city.cityName,
			coordinate: city.coordinate,
			temperature: 0,
			condition: "",
			conditionType: city.conditionType,
			errorDescription: ""
		)
	}
}
