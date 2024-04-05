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
    // For @escaping Closure based
    func parseDataForWeatherResponse(data: Data) -> Result<WeatherResponse, NetworkError> {
        do {
            let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return .success(result)
        } catch {
            debugPrint("Error while parcing data \(error)")
            return .failure(.apiError("Data parsing error"))
        }
    }
    
    // For async await based
    func parseDataForWeatherResponseAsync(data: Data) throws -> WeatherResponse {
        do {
            let result = try JSONDecoder().decode(WeatherResponse.self, from: data)
            return result
        } catch {
            throw NetworkError.apiError("Data parsing error")
        }
    }
}
