//
//  CountryViewController.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 03/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import UIKit
import WebKit

final class CountryDescriptionViewController: UIViewController {
	private let mainQueue = DispatchQueue.main
	private let scrollView = UIScrollView()
	private let flagWebView = UIWebView()
	private var flagWebViewHeight: NSLayoutConstraint?
	private let countryLabel = UILabel()
	private let nameCountryLabel = UILabel()
	private let languagesLabel = UILabel()
	private let languagesCountryLabel = UILabel()
	private let currenciesLabel = UILabel()
	private let currenciesCountryLabel = UILabel()
	private let borderLabel = UILabel()
	private let borderStackView = UIStackView()
	private lazy var alert: AlertsProtocol = Alerts()
	private let activityIndicator = UIActivityIndicatorView()
	var presenter: CountryDescriptionViewPresenterProtocol!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		isHiddenAll(isHide: true)
	}
}

// MARK: - CountryViewProtocol
extension CountryDescriptionViewController: CountryViewProtocol {
	func succes() {
		mainQueue.async {
			guard let country = self.presenter.country else { return }
			self.setCountry(country: country)
			self.activityIndicator.stopAnimating()
		}
	}
	
	func failure(error: String) {
		mainQueue.async {
			self.navigationController?.popViewController(animated: true)
			self.alert.showAlertMessage(self, title: "Error", message: error)
			self.activityIndicator.stopAnimating()
		}
	}
}

// MARK: - private func
fileprivate extension CountryDescriptionViewController {
	
	private func setCountry(country: CountryDescriptionModelProtocol){
		guard let svg = country.flag else { flagWebView.isHidden = true; return }
		var languagesNativeName = ""
		var currenciesText = ""
		
		country.languages.forEach { lang in
			languagesNativeName += lang.nativeName + "\n"
		}
		country.currencies.forEach { currencies in
			currenciesText += currencies.name + " " + currencies.symbol + "\n"
		}
		
		nameCountryLabel.text = (country.name ?? "") + "\n" + country.nativeName
		languagesCountryLabel.text = languagesNativeName.removeLineBreakLast()
		currenciesCountryLabel.text = currenciesText.removeLineBreakLast()
		addButtonToBorderStackView(from: country)
		loadSVG(svg: svg)
		isHiddenAll(isHide: false)
	}
	
	@objc private func hundleRightBarButton(_ sender: UIButton) {
		self.navigationController?.popToRootViewController(animated: true)
	}
	
	@objc private func handlePushCounry(_ sender: UIButton) {
		guard let countryCode = sender.titleLabel?.text else { return }
		let countryController = ViewBuilder
			.createCountryDescriptionViewController(by: countryCode)
		
		navigationController?.pushViewController(countryController, animated: true)
	}

	private func loadSVG(svg strUrl: String?) {
		guard let strUrl = strUrl else { flagWebView.isHidden = true; return }
		guard let url = URL(string: strUrl) else { flagWebView.isHidden = true; return }
		
		let webSite = URLRequest(url: url,
								 cachePolicy: .reloadIgnoringLocalCacheData,
								 timeoutInterval: 10.0)
		mainQueue.async {
			self.flagWebView.loadRequest(webSite)
		}
	}
	
	private func setFlagWebViewHeightOf(contentSize: CGSize) {
		let scale = contentSize.height / contentSize.width
		let height = flagWebView.bounds.width * scale
		self.flagWebViewHeight?.constant = height
	}
	

	private func isHiddenAll(isHide: Bool) {
		flagWebView.isHidden = isHide
		countryLabel.isHidden = isHide
		nameCountryLabel.isHidden = isHide
		languagesLabel.isHidden = isHide
		languagesCountryLabel.isHidden = isHide
		currenciesLabel.isHidden = isHide
		currenciesCountryLabel.isHidden = isHide
		borderLabel.isHidden = isHide
		borderStackView.isHidden = isHide
	}
}

// MARK: - SetupView()
fileprivate extension CountryDescriptionViewController {
	private func setupView() {
		self.view.backgroundColor = #colorLiteral(red: 1, green: 0.9253602624, blue: 0.7316443324, alpha: 1)
		setupNavigationBar()
		setupScrollView()
		setupFlagWebView()
		setupCountryLabel()
		setupNameCountryLabel()
		setupLanguagesLabel()
		setupLanguagesLabelLabel()
		setupCurrenciesLabel()
		setupCurrenciesCountryLabel()
		setupBorderLabel()
		setupBorderStackView()
		setupActivityIndicator()
	}
	
	private func setupNavigationBar() {
		guard let childrenCount = self.parent?.children.count else { return }
		if  childrenCount > 2 {
			let rightBarButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(hundleRightBarButton(_:)))
			self.navigationItem.rightBarButtonItem = rightBarButton
		}
	}
	
	private func setupScrollView() {
		scrollView.frame = view.bounds
		scrollView.translatesAutoresizingMaskIntoConstraints = true
		
		self.view.addSubview(scrollView)
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
			scrollView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
		])
	}
	
	private func setupFlagWebView() {
		flagWebView.translatesAutoresizingMaskIntoConstraints = false
		flagWebView.layer.cornerRadius = 8
		flagWebView.clipsToBounds = true
		flagWebView.contentMode = .center
		flagWebView.scalesPageToFit = false
		flagWebView.scrollView.isScrollEnabled = false
		flagWebView.sizeToFit()
		flagWebView.delegate = self
		flagWebView.backgroundColor = .clear
		flagWebView.isOpaque = false
		
		scrollView.addSubview(flagWebView)
		flagWebViewHeight = flagWebView.heightAnchor.constraint(equalToConstant: 1)
		NSLayoutConstraint.activate([
			flagWebView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
			flagWebView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
			flagWebView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			flagWebView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
			flagWebViewHeight!
		])
	}
	
	private func setupCountryLabel() {
		countryLabel.text = "Country name:"
		countryLabel.font = UIFont.systemFont(ofSize: 16)
		countryLabel.translatesAutoresizingMaskIntoConstraints = false
		countryLabel.backgroundColor = .clear
		countryLabel.textAlignment = .center
		
		scrollView.addSubview(countryLabel)
		NSLayoutConstraint.activate([
			countryLabel.topAnchor.constraint(equalTo: self.flagWebView.bottomAnchor, constant: 16),
			countryLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			countryLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
			countryLabel.heightAnchor.constraint(equalToConstant: 20)
		])
	}
	
	private func setupNameCountryLabel() {
		nameCountryLabel.translatesAutoresizingMaskIntoConstraints = false
		nameCountryLabel.backgroundColor = .clear
		nameCountryLabel.textAlignment = .center
		nameCountryLabel.numberOfLines = 0
		
		scrollView.addSubview(nameCountryLabel)
		NSLayoutConstraint.activate([
			nameCountryLabel.topAnchor.constraint(equalTo: self.countryLabel.bottomAnchor, constant: 4),
			nameCountryLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			nameCountryLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
		])
	}
	
	private func setupLanguagesLabel() {
		languagesLabel.text = "Languages:"
		languagesLabel.font = UIFont.systemFont(ofSize: 16)
		languagesLabel.translatesAutoresizingMaskIntoConstraints = false
		languagesLabel.backgroundColor = .clear
		languagesLabel.textAlignment = .center
		
		scrollView.addSubview(languagesLabel)
		NSLayoutConstraint.activate([
			languagesLabel.topAnchor.constraint(equalTo: self.nameCountryLabel.bottomAnchor, constant: 16),
			languagesLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			languagesLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
			languagesLabel.heightAnchor.constraint(equalToConstant: 20)
		])
	}
	
	private func setupLanguagesLabelLabel() {
		languagesCountryLabel.translatesAutoresizingMaskIntoConstraints = false
		languagesCountryLabel.backgroundColor = .clear
		languagesCountryLabel.textAlignment = .center
		languagesCountryLabel.numberOfLines = 0
		
		scrollView.addSubview(languagesCountryLabel)
		NSLayoutConstraint.activate([
			languagesCountryLabel.topAnchor.constraint(equalTo: self.languagesLabel.bottomAnchor, constant: 4),
			languagesCountryLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			languagesCountryLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
		])
	}
	
	private func setupCurrenciesLabel() {
		currenciesLabel.text = "Currencies:"
		currenciesLabel.font = UIFont.systemFont(ofSize: 16)
		currenciesLabel.translatesAutoresizingMaskIntoConstraints = false
		currenciesLabel.backgroundColor = .clear
		currenciesLabel.textAlignment = .center
		
		scrollView.addSubview(currenciesLabel)
		NSLayoutConstraint.activate([
			currenciesLabel.topAnchor.constraint(equalTo: self.languagesCountryLabel.bottomAnchor, constant: 16),
			currenciesLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			currenciesLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
			currenciesLabel.heightAnchor.constraint(equalToConstant: 20)
		])
	}
	
	private func setupCurrenciesCountryLabel() {
		currenciesCountryLabel.translatesAutoresizingMaskIntoConstraints = false
		currenciesCountryLabel.backgroundColor = .clear
		currenciesCountryLabel.textAlignment = .center
		currenciesCountryLabel.numberOfLines = 0
		
		scrollView.addSubview(currenciesCountryLabel)
		NSLayoutConstraint.activate([
			currenciesCountryLabel.topAnchor.constraint(equalTo: self.currenciesLabel.bottomAnchor, constant: 4),
			currenciesCountryLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			currenciesCountryLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
		])
	}
	
	private func setupBorderLabel() {
		borderLabel.text = "Border:"
		borderLabel.font = UIFont.systemFont(ofSize: 16)
		borderLabel.translatesAutoresizingMaskIntoConstraints = false
		borderLabel.backgroundColor = .clear
		borderLabel.textAlignment = .center
		
		scrollView.addSubview(borderLabel)
		NSLayoutConstraint.activate([
			borderLabel.topAnchor.constraint(equalTo: self.currenciesCountryLabel.bottomAnchor, constant: 16),
			borderLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			borderLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
			borderLabel.heightAnchor.constraint(equalToConstant: 20)
		])
	}
	
	private func setupBorderStackView() {
		borderStackView.translatesAutoresizingMaskIntoConstraints = false
		borderStackView.backgroundColor = .clear
		borderStackView.axis = .vertical
		borderStackView.alignment = .fill
		borderStackView.distribution = .fillEqually
		borderStackView.spacing = 4
		borderStackView.layoutIfNeeded()
		
		scrollView.addSubview(borderStackView)
		NSLayoutConstraint.activate([
			borderStackView.topAnchor.constraint(equalTo: self.borderLabel.bottomAnchor, constant: 4),
			borderStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
			borderStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
			borderStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
		])
	}
	
	private func addButtonToBorderStackView(from array: CountryDescriptionModelProtocol) {
		array.borders.forEach { border in
			let titleText = border
			let borderButton: UIButton = {
				let button = UIButton()
				button.translatesAutoresizingMaskIntoConstraints = false
				button.heightAnchor.constraint(equalToConstant: 24).isActive = true
				button.backgroundColor = .clear
				button.setTitle(titleText, for: .normal)
				button.setTitleColor(.blue, for: .normal)
				button.addTarget(self, action: #selector(handlePushCounry(_:)), for: .touchUpInside)
				
				return button
			}()
			borderStackView.addArrangedSubview(borderButton)
		}
		borderStackView.setNeedsLayout()
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

// MARK: - UIWebViewDelegate
extension CountryDescriptionViewController: UIWebViewDelegate {
	func webViewDidFinishLoad(_ webView: UIWebView) {
		let contentSize: CGSize = webView.scrollView.contentSize
		let webViewSize: CGSize = webView.bounds.size
		let scaleFactor: CGFloat = webViewSize.width / contentSize.width
		
		webView.scrollView.minimumZoomScale = scaleFactor
		webView.scrollView.maximumZoomScale = scaleFactor
		webView.scrollView.zoomScale = scaleFactor
		
		setFlagWebViewHeightOf(contentSize: contentSize)
	}
}
