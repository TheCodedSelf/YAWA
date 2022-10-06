//
//  WeatherLocationView.swift
//  Weather
//
//  Created by Keegan on 23/08/2022.
//

import SwiftUI

struct WeatherLocationView: View {
    @ObservedObject private var viewModel: WeatherLocationViewModel
    @State private var searchText: String = ""
    @State private var buttonsMaxWidth: CGFloat?
    @State private var searchBarHeight: CGFloat = 0
    @FocusState private var isFocused: Bool
    private let onSearch: (String) -> ()
    private let onLocate: () -> ()
    private let autocompleteHeight: CGFloat = 250
    private let searchBarSidePadding: CGFloat = 8

    init(location: String,
         onSearch: @escaping (String) -> (),
         onLocate: @escaping () -> ()) {
        self.onSearch = onSearch
        self.onLocate = onLocate
        self.viewModel = WeatherLocationViewModel()
        self.viewModel.state = .loaded(location)
    }

    var body: some View {
        switch(viewModel.state) {
        case .loading:
            ProgressView()
        case .loaded(let location):
            ZStack {
                Text(location)
                    .font(.title)
                    .padding([.leading, .trailing], buttonsMaxWidth)
                HStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            withAnimation {
                                viewModel.searchTapped()
                            }
                        }, label: {
                            Image(systemName: "magnifyingglass")
                        })
                        Button(action: {
                            withAnimation(.easeOut(duration: 0.4)) {
                                onLocate()
                            }
                        }, label: {
                            Image(systemName: "location")
                        })
                    }
                    .padding(.trailing, 8)
                    .background(GeometryReader { geometry in
                        Color.clear.preference(
                            key: ButtonsWidthPreferenceKey.self,
                            value: geometry.size.width
                        )
                    })
                }
                .onPreferenceChange(ButtonsWidthPreferenceKey.self) {
                    buttonsMaxWidth = $0
                }
            }
            .transition(.opacity)
        case .searching:
            HStack {
                ZStack {
                    TextField("Location:", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocused)
                        .onAppear { isFocused = true }
                        .onSubmit {
                            withAnimation(.easeOut(duration: 0.4)) {
                                onSearch(searchText)
                            }
                        }
                    HStack {
                        Spacer()
                        Button(action: { searchText = "" }) {
                            Image(systemName: "delete.backward.fill")
                                .foregroundColor(.gray)
                                .opacity(0.5)
                        }
                    }
                    .padding(.trailing, 8)
                }
                Button("Cancel", action: {
                    withAnimation {
                        viewModel.restoreState()
                    }
                })
            }
            .padding([.leading, .trailing], searchBarSidePadding)
            .transition(.move(edge: .top)
                .combined(with: .opacity))
            .readSizeInBackground(onChange: {
                searchBarHeight = $0.height
            })
            .overlay {
                AutocompleteList(searchText: $searchText)
                    .cornerRadius(10)
                    .frame(height: autocompleteHeight)
                .padding(.top, autocompleteHeight + searchBarHeight + 20)
                .padding([.leading, .trailing], 8)
                .shadow(color: .black, radius: 5)
            }
        }
    }
}

struct WeatherLocationView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherLocationView(location: "Poznań",
                            onSearch: { _ in },
                            onLocate: { })
    }
}

private extension WeatherLocationView {
    struct ButtonsWidthPreferenceKey: PreferenceKey {
        static let defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat,
                           nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}
