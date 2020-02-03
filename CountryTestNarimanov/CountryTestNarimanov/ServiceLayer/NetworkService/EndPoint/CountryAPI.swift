//
//  HotelAPI.swift
//  HotelTestNarimanov
//
//  Created by Arthur Narimanov on 01/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//
// https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation

enum Fields: String {
	case fields
	case name
	case alpha3Code
	case nativeName
	case languages
	case currencies
	case flag
	case borders
}

enum NetworkEnvironment {
	case production
}
public enum CountryAPI {
	case getAllCountries
	case getCountry(code: String)
}

extension CountryAPI: EndPointType {
	var environmentBaseURL: String {
		switch NetworkManager.environment {
		case .production:
			var components = URLComponents()
			components.scheme = "https"
			components.host = "restcountries.eu"
			return components.string!
		}
	}
	
	var baseURL: URL {
		guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
		return url
	}
	
	var path: String {
		switch self {
		case .getAllCountries:
			return "/rest/v2/all"
		case .getCountry(let code):
			return "/rest/v2/alpha/\(code)"
		}
	}
	
	var httpMethod: HTTPMethod {
		switch self {
		case .getAllCountries:
			return .get
		case .getCountry:
			return .get
		}
	}
	
	var task: HTTPTask {
		switch self {
		case .getAllCountries:
			let filterNameCodeParameters: [Fields] = [.name, .alpha3Code]
			let filterFieldsParameters = [Fields.fields.rawValue: filterNameCodeParameters.getStringWithSemicolon()]
			return .requestUrlParameters(urlParameters: filterFieldsParameters)
		case .getCountry:
			let filterParameters: [Fields] = [.name, .languages, .currencies, .flag, .borders, .nativeName]
			let fieldsParameters = [Fields.fields.rawValue: filterParameters.getStringWithSemicolon()]
			return .requestUrlParameters(urlParameters: fieldsParameters)
		}
	}
	
	var headers: HTTPHeaders? {
		switch self {
		case .getAllCountries:
			return nil
		case .getCountry:
			return nil
		}
	}
}

