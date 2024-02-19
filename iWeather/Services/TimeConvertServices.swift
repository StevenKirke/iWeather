//
//  TimeConvertServices.swift
//  iWeather
//
//  Created by Steven Kirke on 18.02.2024.
//

import Foundation
/// Конвертирование даты в текстовом формате в тип "20 Apr Wed".
final class TimeConvertServices {

	private let dateFormatter = DateFormatter()
	/**
	 Конвертация строкового значения даты в формат "20 Apr Wed".
	 - Parameters:
			- dataToString:  Текстовый формат даты.
	 - Returns: Вывод даты в значении "20 Apr Wed"
	 */
	func convertData(dataString: String) -> String {
		self.convert(dataString)
	}

	// MARK: - Private methods
	private func convert(_ textData: String) -> String {

		var monthShort = ""
		var dayOfWeekShort = ""
		var day = ""

		dateFormatter.dateFormat = "yyyy-MM-dd"
		let fullDate = dateFormatter.date(from: textData)

		if let currentDate = fullDate {
			// Месяц, короткое название.
			dateFormatter.dateFormat = "LLL"
			monthShort = dateFormatter.string(from: currentDate)
			// День недели, короткое название.
			dateFormatter.dateFormat = "EEE"
			dayOfWeekShort = dateFormatter.string(from: currentDate)
			// День.
			dateFormatter.dateFormat = "dd"
			day = dateFormatter.string(from: currentDate)
		}
		let assemblerDate = "\(day) \(monthShort) \(dayOfWeekShort)"
		return assemblerDate
	}
}
