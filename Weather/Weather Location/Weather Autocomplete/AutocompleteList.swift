//
//  AutocompleteList.swift
//  Weather
//
//  Created by Keegan on 05/09/2022.
//

import SwiftUI
import MapKit

class AutocompleteListViewModel: NSObject, ObservableObject {
    @Binding var searchText: String
    @Published var listOptions: [String] = []
    let completer = MKLocalSearchCompleter()

    init(searchText: Binding<String>) {
        self._searchText = searchText
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address]
        completer.queryFragment = searchText.wrappedValue
    }

    func select(_ value: String) {
        searchText = value
    }

}

extension AutocompleteListViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        listOptions = completer.results.map { $0.title }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error)")
    }

}

struct AutocompleteList: View {
    @ObservedObject private var viewModel: AutocompleteListViewModel

    init(searchText: Binding<String>) {
        viewModel = AutocompleteListViewModel(searchText: searchText)
    }

    var body: some View {
        List(viewModel.listOptions, id: \.self) { item in
            Button(item, action: {
                viewModel.select(item)
            })
        }
        .foregroundColor(.black)
    }
}

struct AutocompleteList_Previews: PreviewProvider {
    static var previews: some View {
        AutocompleteList(searchText: .constant("foo"))
    }
}
