//
//  WeatherView.swift
//  Weather
//
//  Created by Keegan on 14/08/2022.
//

import SwiftUI

let itemWidth: Double = 150
let itemHeight: Double = 100

struct WeatherView: View {
    @EnvironmentObject var context: Context
    @ObservedObject var viewModel = WeatherViewModel(locator: Locator(),
                                                     apiClient: APICommunicator())
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State var headerHeight: CGFloat = 0.0
    init() {
        viewModel.locate()
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemIndigo)
                .ignoresSafeArea()
            switch viewModel.state {
            case .loading:
                ProgressView("Loading")
                    .foregroundColor(.white)
                    .tint(.white)
            case .error(let error):
                VStack {
                    Text(error)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(4)
                        .background(Color.red.opacity(0.5))
                        .cornerRadius(5)
                    Button("OK", action: viewModel.reload)
                        .padding(4)
                        .background(Color.white)
                        .foregroundColor(.red)
                        .cornerRadius(3)
                }
            case .loaded(let dataModel):
                ZStack {
                    VStack {
                        Text(dataModel.temperature)
                            .font(.largeTitle)
                        Text("Feels like \(dataModel.feelsLike)")
                            .font(.body)
                        ScrollView {
                            GeometryReader { geometry in
                                LazyVGrid(columns: columns) {
                                    ForEach(dataModel.dataPoints, id: \.title) {
                                        WeatherDataPointView(title: $0.title, value: $0.value)
                                            .frame(width: geometry.size.width * 0.4)
                                    }
                                }.frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.top, headerHeight) // This should be set to the WeatherLocationView's size
                    .transition(.scale)
                    VStack {
                        WeatherLocationView(
                            location: dataModel.location,
                            onSearch: viewModel.search,
                            onLocate: viewModel.locate)
                        .readSizeInBackground(onChange: { newSize in
                            if !headerHeight.rounded().isEqual(to: newSize.height) {
                                headerHeight = newSize.height
                            }
                        })
                        Spacer()
                    }
                    
                }
                .foregroundColor(Color.white)
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
