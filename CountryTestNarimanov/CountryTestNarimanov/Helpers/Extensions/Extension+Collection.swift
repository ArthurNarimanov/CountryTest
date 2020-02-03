//
//  Extension+Collection.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 05/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import Foundation

extension Collection where Iterator.Element == Fields {
	func getStringWithSemicolon() -> String {
		var str: String = ""
		self.forEach { field in
			str += field.rawValue + ";"
		}
		return str
	}
}
