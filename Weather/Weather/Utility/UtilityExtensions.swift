//
//  UtilityExtensions.swift
//  Weather
//
//  Created by Swapnil Katwe on 04/04/24.
//

import Foundation

extension URL {
    func appendingQueryParameters(_ parameters: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters
        return components?.url ?? self
    }
}
