//
//  FullWeatherView.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI

struct FullWeatherView: View {
    @StateObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            CurrentWeatherView(weatherViewModel: weatherViewModel)
                .padding()
            HourlyView(weatherViewModel: weatherViewModel)
                .padding(.horizontal)
            DailyWeatherView(weatherViewModel: weatherViewModel)
                .padding(.horizontal)
        }
    }
}

struct FullWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        FullWeatherView(weatherViewModel: WeatherViewModel())
    }
}
