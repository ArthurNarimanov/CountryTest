//
//  CountryDescriptionModel.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 03/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import Foundation

protocol CountryDescriptionModelProtocol {
	var currencies: [Currencies] { get }
	var languages: [Languages] { get }
	var flag: String? { get }
	var name: String? { get }
	var borders: [String] { get }
	var nativeName: String { get }
}

protocol CurrenciesProtocol {
	var code: String? { get }
	var name: String? { get }
	var symbol: String? { get }
}
extension CurrenciesProtocol {
	var code: String {
		return code ?? ""
	}
	var name: String {
		return name ?? ""
	}
	var symbol: String {
		return symbol ?? ""
	}
}

protocol LanguagesProtocol {
	var iso639_1: String? { get }
	var iso639_2: String? { get }
	var name: String? { get }
	var nativeName: String? { get }
}
extension LanguagesProtocol {
	var iso639_1: String {
		return iso639_1 ?? ""
	}
	var iso639_2: String {
		return iso639_2 ?? ""
	}
	var name: String {
		return name ?? ""
	}
	var nativeName: String {
		return nativeName ?? ""
	}
}

struct CountryDescriptionModel: Decodable, CountryDescriptionModelProtocol {
	var currencies: [Currencies]
	var languages: [Languages]
	var flag: String?
	var name: String?
	var borders: [String]
	var nativeName: String
}

struct Currencies: Decodable, Equatable, CurrenciesProtocol {
	var code: String?
	var name: String?
	var symbol: String?
}

struct Languages: Decodable, Equatable, LanguagesProtocol {
	let iso639_1: String?
	let iso639_2: String?
	let name: String?
	let nativeName: String?
}



