//
//  CountryDescriptionPresenterTest.swift
//  CountryTestNarimanovTests
//
//  Created by Arthur Narimanov on 05/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import XCTest
@testable import CountryTestNarimanov

class MockCountryView: CountryViewProtocol {
	var titleError: String?
	var isSucces: Bool?
	func succes() {
		isSucces = true
	}
	func failure(error: String) {
		titleError = error
	}
}

struct MockCountryDescriptionModel: CountryDescriptionModelProtocol {
	var currencies: [Currencies]
	var languages: [Languages]
	var flag: String?
	var name: String?
	var borders: [String]
	var nativeName: String
}

class MockCountryNetworkManager: NetworkServiceProtocol {
	func getAllCountriesSecond(completion: @escaping (ResultNetwork<Decodable?, String>) -> Void) {}
	
	func getAllCountries(completion: @escaping (ResultNetwork<[CountryModelProtocol]?, String>) -> Void) {}
	
	private(set) var searchTest: String?
	func getCountryDescription(code: String,
							   completion: @escaping (ResultNetwork<CountryDescriptionModelProtocol?, String>) -> Void) {
		searchTest = code
		completion(.success(nil))
	}
}

class CountryDescriptionPresenterTest: XCTestCase {
	var view: MockCountryView!
	var presenter: CountryDescriptionViewPresenter!
	var networkService: MockCountryNetworkManager!
	var mockCountryModel: MockCountryDescriptionModel!
	var currencies: Currencies!
	var languages: Languages!
	
    override func setUp() {
        view = MockCountryView()
		networkService = MockCountryNetworkManager()
		presenter = CountryDescriptionViewPresenter(view: view, networkService: networkService)
		
		currencies = Currencies(code: "Foo", name: "Baz", symbol: "Bar")
		languages = Languages(iso639_1: "Foo", iso639_2: "Baz", name: "Bar", nativeName: "Foz")
		
		mockCountryModel = MockCountryDescriptionModel(currencies: [currencies],
													   languages: [languages],
													   flag: nil,
													   name: "Foo",
													   borders: ["Foo", "Baz", "Bar"],
													   nativeName: "Baz")
    }

    override func tearDown() {
        view = nil
		networkService = nil
		presenter = nil
		mockCountryModel = nil
		currencies = nil
		languages = nil
    }
	
	func testCountriesIsNotNil() {
		XCTAssertNotNil(view)
		XCTAssertNotNil(networkService)
		XCTAssertNotNil(presenter)
		XCTAssertNotNil(mockCountryModel)
		XCTAssertNotNil(currencies)
		XCTAssertNotNil(languages)
	}
	
	func testNetworkService() {
		let foo = "Foo"
		presenter.searchCountry(by: foo)
		XCTAssertEqual(networkService.searchTest, foo)
	}
	
	func testViewNetworkService() {
		networkService.getCountryDescription(code: "Foo") { result in
			switch result {
			case .success:
				self.view.succes()
			case .failure(let error):
				self.view.failure(error: error)
			}
		}
		XCTAssertEqual(self.view.isSucces, true)
	}
	
	func testViewPresenter() {
		presenter.searchCountry(by: "Foo")
		XCTAssertEqual(self.view.isSucces, true)
	}
	
	func testCountryModel() {
		let currencies = Currencies(code: "Foo", name: "Baz", symbol: "Bar")
		let languages = Languages(iso639_1: "Foo", iso639_2: "Baz", name: "Bar", nativeName: "Foz")
		
		XCTAssertEqual(mockCountryModel.name, "Foo")
		XCTAssertEqual(mockCountryModel.nativeName, "Baz")
		XCTAssertEqual(mockCountryModel.borders, ["Foo", "Baz", "Bar"])
		XCTAssertEqual(mockCountryModel.currencies, [currencies])
		XCTAssertEqual(mockCountryModel.languages, [languages])
	}
}
