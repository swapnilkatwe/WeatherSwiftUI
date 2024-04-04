//
//  HourlyView.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI

struct HourlyView: View {
    @StateObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.Dimensions.secondSpacing) {
                ForEach(weatherViewModel.weather.hourly) { weather in
                    let selectedIcon = (weather.weather.count > 0) ? weather.weather[0].icon : "sun"
                    let icon = NetworkImage(url: URL(string: Constants.Strings.imageUrl + selectedIcon + ".png"))
                    let hour = weatherViewModel.getTimeFor(weather.date)
                    let temp = weatherViewModel.getTempFor(weather.temperature)
                    
                    HourlyWeatherCell(hour: hour, image: icon, temp: temp)
                }
            }
        }
    }
    
    private func HourlyWeatherCell(hour: String, image: NetworkImage, temp: String) -> some View {
        VStack(spacing: Constants.Dimensions.secondSpacing) {
            Text(hour)
            image
                .scaledToFill()
                .frame(width: Constants.Dimensions.defaultWidth,
                       height: Constants.Dimensions.defaultHeight,
                       alignment: .center)
            Text("\(temp)°C")
        }
        .font(.system(size: Constants.Font.smallSize))
        //.foregroundStyle(.white)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: Constants.Colors.gradient),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: Color.white.opacity(0.1),
                radius: 2,
                x: -2,
                y: -2)
        .shadow(color: Color.black.opacity(0.2),
                radius: 2,
                x: 2,
                y: 2)
    }
}

struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView(weatherViewModel: WeatherViewModel())
    }
}
