//
//  WeatherViewModel.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI
import CoreLocation

class WeatherViewModel: NSObject,ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var weather = WeatherResponse.empty()
    @Published var city = Constants.Strings.city {
        didSet {
            getLocation()
            saveLastSearchedLocation()
        }
    }
    
    override init() {
        super.init()
        initialiseLocation()
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
        var urlString = ""
        if let coord = coord {
            urlString = WeatherApi.getCurrentWeatherURL(latitude: coord.latitude, longitude: coord.longitude)
        }
        else {
            urlString = WeatherApi.getCurrentWeatherURL(latitude: 59.929305, longitude: 10.716746) // Oslo
        }
        getWeatherForCity(city: city, for: urlString)
    }
    
    private func getWeatherForCity(city: String, for urlString: String) {
        guard let url = URL(string: urlString) else {return}
        NetworkManager<WeatherResponse>.fetchWeather(for: url) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.weather = response
                }
            case .failure(let error):
                debugPrint(error)
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

extension WeatherViewModel: CLLocationManagerDelegate{
    
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
