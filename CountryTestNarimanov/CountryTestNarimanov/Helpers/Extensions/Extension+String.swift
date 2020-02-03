//
//  Extension+String.swift
//  CountryTestNarimanov
//
//  Created by Arthur Narimanov on 03/12/2019.
//  Copyright © 2019 Arthur Narimanov. All rights reserved.
//

import Foundation

extension String {
	mutating func removeEmptyLast() -> String {
		guard self.last == " " else { return self }
		self.removeLast()
		return self.removeEmptyLast()
	}
	
	mutating func removeLineBreakLast() -> String {
		guard self.last == "\n" else { return self }
		self.removeLast()
		return self.removeLineBreakLast()
	}
}
