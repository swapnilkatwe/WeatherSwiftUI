//
//  WeatherViewModel.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, DataParsing {
    private let locationManager: CLLocationManager
    private let networkManager: NetworkService

    @Published var weather = WeatherResponse.empty()
    @Published var city = Constants.Strings.city {
        didSet {
            getLocation()
            saveLastSearchedLocation()
        }
    }

    init(networkManager: NetworkService = NetworkManager(), locationManager: CLLocationManager = CLLocationManager()) {
        self.networkManager = networkManager
        self.locationManager = locationManager
        super.init()
        self.initialiseLocation()
    }
    
    private func getLocation() {
        CLGeocoder().geocodeAddressString(city) { (placemarks, error) in
            if let places = placemarks,
               let place = places.first {
                self.getWeatherForLocation(coord: place.location?.coordinate)
            }
        }
    }
    
    private func saveLastSearchedLocation() {
        
        UserDefaults.standard.set(self.city, forKey: "city")
    }
    
    private func getWeatherForLocation(coord: CLLocationCoordinate2D?) {
        var queryParam: [URLQueryItem] = []
        var location = CLLocationCoordinate2D()
        if let coord = coord {
            location = coord
        }
        else {
            location = CLLocationCoordinate2D(latitude: 59.929305, longitude: 10.716746)// Oslo
        }
        queryParam = [
            URLQueryItem(name: "lat", value: "\(location.latitude)"),
            URLQueryItem(name: "lon", value: "\(location.longitude)"),
            URLQueryItem(name: "appid", value: "\(AppConfig.shared.key)"),
            URLQueryItem(name: "exclude", value: "minutely"),
            URLQueryItem(name: "units", value: "metric"),
        ]
        
        guard let url = URL(string: AppConfig.shared.baseURL + "/onecall") else {
            return
        }
        getWeatherForCity(city: city, for: url, queryParam: queryParam)
    }
    
    func getWeatherForCity(city: String, for url: URL?, queryParam: [URLQueryItem]?) {
        guard let url = url else {return}
        

        networkManager.fetchWeather(for: url, queryParam: queryParam) { [weak self] result in
            guard let _self = self else { return }
            switch result {
            case .success(let data):
                let parseResultData = _self.parseDataForWeatherResponse(data: data)
                
                switch parseResultData {
                case .success(let weatherResponse):
                    DispatchQueue.main.async {
                        _self.weather = weatherResponse
                    }
                case .failure(let error):
                    debugPrint(NetworkError.apiError(error.localizedDescription))
                }
            case .failure(let error):
                debugPrint(NetworkError.apiError(error.localizedDescription))
            }
        }
    }
    
    var date: String {
        return Time.defaultDateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.current.date)) )
    }
    
    var weatherIcon: String {
        return weather.current.weather.first?.icon ?? "sun"
    }
    
    var temperature: String {
        return getTempFor(weather.current.temperature)
    }
    
    var conditions: String {
        return weather.current.weather.first?.main ?? ""
    }
    
    var windSpeed: String {
        return String(format: "%0.1f", weather.current.windSpeed)
    }
    
    var humidity: String {
        return String(format: "%d%%", weather.current.humidity)
    }
    
    var rainChances: String {
        return String(format: "%0.1f%%", weather.current.dewPoint)
    }
    
    func getTimeFor(_ temp: Int) -> String {
        return Time.timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }
    
    func getDayFor(_ temp: Int) -> String {
        return Time.dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }
    
    func getDayNumber(_ temp: Int) -> String {
        return Time.dayNumberFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(temp)))
    }
    
    func getTempFor(_ temp: Double) -> String {
        return String(format: "%1.0f", temp)
    }
}

// MARK: - Location Manager Delegate

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func initialiseLocation() {
        let savedCity = retrieveLastSavedLocation()
        if savedCity != "" {
            self.city = savedCity
        }
        else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    private func retrieveLastSavedLocation() -> String{
        return UserDefaults.standard.string(forKey: "city") ?? ""
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Handle each case of location permissions
        switch status {
        case .authorizedAlways:
            locationManager.requestLocation()
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            break;
        case .notDetermined:
            break;
        case .restricted:
            break;
        @unknown default:
            break;
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            // Handle location update
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            self.city = city
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error) {
        debugPrint(error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            debugPrint("No access")
        case .authorizedAlways, .authorizedWhenInUse:
            debugPrint("Access")
        @unknown default:
            break
        }
    }
}
