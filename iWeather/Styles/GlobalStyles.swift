//
//  GlobalStyles.swift
//  iWeather
//
//  Created by Steven Kirke on 20.02.2024.
//

import UIKit

enum FontsStyle {
	case poppinsBold(CGFloat)
	case poppinsMedium(CGFloat)
	case poppinsRegular(CGFloat)
	case robotoRegular(CGFloat)

	var font: UIFont {
		var font = ""
		var fontSize: CGFloat = 0
		switch self {
		case .poppinsBold(let size):
			font = "Poppins-SemiBold"
			fontSize = size
		case .poppinsMedium(let size):
			font = "Poppins-Medium"
			fontSize = size
		case .poppinsRegular(let size):
			font = "Poppins-Regular"
			fontSize = size
		case .robotoRegular(let size):
			font = "Roboto-Regular"
			fontSize = size
		}
		return UIFont(name: font, size: fontSize)!
	}
}
