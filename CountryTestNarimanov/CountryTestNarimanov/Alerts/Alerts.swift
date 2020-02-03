//
//  Alerts.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 05/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import UIKit

protocol AlertsProtocol: class {
	func showAlertMessage(_ controller: UIViewController, title: String, message: String?)
}

final class Alerts: AlertsProtocol {
	private let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
	
	public func showAlertMessage(_ controller: UIViewController, title: String, message: String?) {
		mainAlert(controller: controller, title: title, message: message, preferredStyle: .alert)
	}
}

//MARK: - private func
fileprivate extension Alerts {
	private func mainAlert(controller: UIViewController, title: String, message: String?, preferredStyle: UIAlertController.Style) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
		alert.addAction(ok)
		
		controller.present(alert, animated: true, completion: nil)
	}
}
