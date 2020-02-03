//
//  CountryModel.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 02/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import Foundation

protocol CountryModelProtocol: Decodable {
	var name: String? { get }
	var alpha3Code: String? { get }
}
extension CountryModelProtocol {
	var name: String {
		return name ?? ""
	}
	var alpha3Code: String {
		return alpha3Code ?? ""
	}
}

struct CountryModel: CountryModelProtocol {
	var name: String?
	var alpha3Code: String?
}
