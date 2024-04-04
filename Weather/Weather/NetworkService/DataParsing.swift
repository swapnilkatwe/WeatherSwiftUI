//
//  DataParsing.swift
//  Weather
//
//  Created by Swapnil Katwe on 04/04/24.
//

import Foundation

protocol DataParsing {
    func parseDataForWeatherResponse(data: Data) -> Result<WeatherResponse, NetworkError>
}

extension DataParsing {
    func parseDataForWeatherResponse(data: Data) -> Result<WeatherResponse, NetworkError> {
        do {
            let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return .success(result)
        } catch {
            debugPrint("Error while parcing data \(error)")
            return .failure(.apiError("Data parcing error"))
        }
    }
}
