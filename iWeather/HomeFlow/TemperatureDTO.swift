//
//  TemperatureDTO.swift
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

struct Fact: Decodable {
	/// Текущая температура для населенного пункта.
	let temp: Int
	let condition: ConditionDTO
}

enum ConditionDTO: String, Codable {
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
	case cloudyAndLightSnow = "cloudy-and-light-snow"
}

extension ConditionDTO {
	var title: String {
		   var title = ""
		   switch self {
		   case .clear:
			   title = "Clear"
		   case .cloudy:
			   title = "Cloudy"
		   case .cloudyAndLightRain:
			   title = "Cloudy and light rain"
		   case .overcast:
			   title = "Overcast"
		   case .overcastAndLightRain:
			   title = "Overcast and light rain"
		   case .overcastAndRain:
			   title = "Rain"
		   case .partlyCloudy:
			   title = "Partly cloudy"
		   case .partlyCloudyAndRain:
			   title = "Cloudy and rain"
		   case .overcastAndWetSnow:
			   title = "Wet snow"
		   case .overcastAndLightSnow:
			   title = "Snow"
		   case .cloudyAndSnow:
			   title = "Snow"
		   case .cloudyAndLightSnow:
			   title = "Snow"
		   }
		   return title
	   }

	   var iconType: String {
		   var title = ""
		   switch self {
		   case .clear:
			   title = "clear"
		   case .cloudy:
			   title = "cloudy"
		   case .cloudyAndLightRain:
			   title = "rain"
		   case .overcast:
			   title = "overcast"
		   case .overcastAndLightRain:
			   title = "rain"
		   case .overcastAndRain:
			   title = "rain"
		   case .partlyCloudy:
			   title = "overcast"
		   case .partlyCloudyAndRain:
			   title = "rain"
		   case .overcastAndWetSnow:
			   title = "snow"
		   case .overcastAndLightSnow:
			   title = "snow"
		   case .cloudyAndSnow:
			   title = "snow"
		   case .cloudyAndLightSnow:
			   title = "snow"
		   }
		   return title
	   }
}
