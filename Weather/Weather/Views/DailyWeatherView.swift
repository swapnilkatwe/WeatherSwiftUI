//
//  DailyView.swift
//  Weather
//
//  Created by SK on 26/11/23.
//

import SwiftUI

struct DailyWeatherView: View {
    @StateObject var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ForEach(weatherViewModel.weather.daily) { weather in
            LazyVStack {
                DailyWeatherCell(weather: weather)
            }
        }
    }
    
    private func DailyWeatherCell(weather: WeatherDaily) -> some View {
        HStack {
            HStack {
                Text(weatherViewModel.getDayFor(weather.date).uppercased())
                    .frame(width: 50)
                Text(weatherViewModel.getDayNumber(weather.date))
            }
            Spacer()

            NetworkImage(url: URL(string: Constants.Strings.imageUrl + weather.weather[0].icon + ".png"))
                .scaledToFill()
                .frame(width: Constants.Dimensions.defaultWidth,
                       height: Constants.Dimensions.defaultHeight,
                       alignment: .center)

            Spacer()
            HStack {
                Image(Constants.Images.cold)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text("\(weatherViewModel.getTempFor(weather.temperature.min))°C")
            }
            Spacer()
            HStack {
                Image(Constants.Images.warm)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                Text("\(weatherViewModel.getTempFor(weather.temperature.max))°C")
            }
        }
        .font(.system(size: Constants.Font.smallSize))
        .padding(.horizontal, 10)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: Constants.Dimensions.cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: Constants.Colors.gradient),
                        startPoint: .topLeading, endPoint: .bottomTrailing
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

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        DailyWeatherView(weatherViewModel: WeatherViewModel())
    }
}
