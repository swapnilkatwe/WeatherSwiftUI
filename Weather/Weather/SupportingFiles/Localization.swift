//
//  Localization.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI

extension String {
    func localizated() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localization",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}
