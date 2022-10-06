//
//  WeatherDataPointView.swift
//  Weather
//
//  Created by Keegan on 15/08/2022.
//

import SwiftUI

struct WeatherDataPointView: View {
    let title: String
    let value: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.body)
            Text(value)
                .font(.largeTitle)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(4)
        .foregroundColor(.white)
        .background(Color.gray)
        .cornerRadius(10)
    }
}

struct WeatherDataPointView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDataPointView(title: "title6", value: "value")
    }
}
