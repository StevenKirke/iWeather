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
}

extension ConditionDTO {
	var title: String {
		   var title = ""
		   switch self {
		   case .clear:
			   title = "ясно"
		   case .cloudy:
			   title = "малооблачно"
		   case .cloudyAndLightRain:
			   title = "дождь"
		   case .overcast:
			   title = "пасмурно"
		   case .overcastAndLightRain:
			   title = "дождь"
		   case .overcastAndRain:
			   title = "дождь"
		   case .partlyCloudy:
			   title = "малооблачно"
		   case .partlyCloudyAndRain:
			   title = "дождь"
		   case .overcastAndWetSnow:
			   title = "дождь со снегом"
		   case .overcastAndLightSnow:
			   title = "снег"
		   case .cloudyAndSnow:
				title = "снег"
		   }
		   return title
	   }

	   var iconType: String {
		   var title = ""
		   switch self {
		   case .clear:
			   title = "c"
		   case .cloudy:
			   title = "pc"
		   case .cloudyAndLightRain:
			   title = "r"
		   case .overcast:
			   title = "pc"
		   case .overcastAndLightRain:
			   title = "r"
		   case .overcastAndRain:
			   title = "r"
		   case .partlyCloudy:
			   title = "pc"
		   case .partlyCloudyAndRain:
			   title = "r"
		   case .overcastAndWetSnow:
			   title = "r"
		   case .overcastAndLightSnow:
			   title = "s"
		   case .cloudyAndSnow:
			   title = "s"
		   }
		   return title
	   }

}
