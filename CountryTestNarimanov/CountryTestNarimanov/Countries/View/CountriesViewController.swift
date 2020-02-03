//
//  ViewController.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 02/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import UIKit

final class CountriesViewController: UIViewController {
	private let tableView = UITableView()
	private let headerView = UIView()
	private let searchTextField = UITextField()
	private lazy var alert: AlertsProtocol = Alerts()
	private let activityIndicator = UIActivityIndicatorView()
	private let mainQueue = DispatchQueue.main
	private let allCountriesQueue = DispatchQueue(label: "eu.restcountries.allCountries",
												  qos: .userInitiated)
	var presenter: CountriesPresenterProtocol!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupAllView()
		getAllCountries()
	}
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension CountriesViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.filterCountries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let country = presenter.filterCountries[indexPath.row]
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "UITableViewCell")
		cell.textLabel?.text = country.name
		cell.detailTextLabel?.text = country.alpha3Code
		
		return cell
	}
	
	// MARK: Header Table View - Search Bar
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		return headerView
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let codeCountry = presenter.filterCountries[indexPath.row].alpha3Code else { return }
		let countryViewController = ViewBuilder.createCountryDescriptionViewController(by: codeCountry)
		self.navigationController?.pushViewController(countryViewController, animated: true)
	}
}

//MARK: - UITextFieldDelegate
extension CountriesViewController: UITextFieldDelegate {
	func textFieldDidChangeSelection(_ textField: UITextField) {
		guard var text = textField.text else { return }
		let nameCountry = text.removeEmptyLast()
		self.presenter.searchCountry(by: nameCountry)
	}
}

//MARK: - CountriesViewProtocol
extension CountriesViewController: CountriesViewProtocol {
	func succesSearch() {
		mainQueue.async {
			self.tableView.reloadData()
		}
	}
	func succes() {
		mainQueue.async {
			self.tableView.isHidden = false
			self.tableView.reloadData()
			self.searchTextField.resignFirstResponder()
			self.activityIndicator.stopAnimating()
		}
	}
	func failure(error: String) {
		mainQueue.async {
			self.alert.showAlertMessage(self, title: "Error", message: error)
			self.searchTextField.text = ""
			self.tableView.isHidden = false
			self.activityIndicator.stopAnimating()
		}
	}
}

//MARK: - setupAllView
fileprivate extension CountriesViewController {
	private func setupAllView() {
		dismissKeyboardTapOnView()
		setupNavigstionController()
		setupTableView()
		setupHeaderView()
		setupSearchTextField()
		setupActivityIndicator()
	}
	
	private func setupNavigstionController() {
		self.navigationItem.title = "Countries"
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
		tableView.keyboardDismissMode = .onDrag
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.isHidden = true
		
		self.view.addSubview(tableView)
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
		])
	}
	
	private func setupHeaderView() {
		let frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44)
		headerView.frame = frame
		headerView.translatesAutoresizingMaskIntoConstraints = true
		headerView.backgroundColor = .systemGray
	}
	
	private func setupSearchTextField() {
		let frame = CGRect(x: 8, y: 4, width: self.view.bounds.width - 16, height: 36)
		searchTextField.frame = frame
		searchTextField.translatesAutoresizingMaskIntoConstraints = true
		searchTextField.delegate = self
		searchTextField.backgroundColor = .white
		searchTextField.layer.cornerRadius = 16
		searchTextField.clipsToBounds = true
		searchTextField.placeholder = "Search Country..."
		searchTextField.returnKeyType = .search
		
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: searchTextField.frame.height))
		searchTextField.leftView = paddingView
		searchTextField.leftViewMode = .always
		searchTextField.clearButtonMode = .whileEditing
		
		headerView.addSubview(searchTextField)
		NSLayoutConstraint.activate([
			searchTextField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
			searchTextField.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
		])
	}
	
	private func setupActivityIndicator() {
		activityIndicator.style = .whiteLarge
		activityIndicator.translatesAutoresizingMaskIntoConstraints = true
		activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		activityIndicator.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
		
		activityIndicator.hidesWhenStopped = true
		activityIndicator.startAnimating()
		activityIndicator.color = .white
		
		self.view.addSubview(activityIndicator)
	}
}

//MARK: - private func
fileprivate extension CountriesViewController {
	private func getAllCountries() {
		allCountriesQueue.async {
			self.presenter.getAllCountries()
		}
	}
	
	private func dismissKeyboardTapOnView() {
		let tap = UITapGestureRecognizer(target: self.view,
										 action: #selector(UIView.endEditing(_:)))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
}
