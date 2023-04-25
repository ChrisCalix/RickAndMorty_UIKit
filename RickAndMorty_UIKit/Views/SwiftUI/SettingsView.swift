//
//  SettingsView.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import SwiftUI

struct SettingsView: View {
    
    let viewModel: SettingsViewViewModel
    
    var body: some View {
        List(viewModel.cellViewModels) { viewModel in
            HStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .renderingMode(.template)
                        .colorMultiply(Color(viewModel.iconContainerColor))
                        .padding(.trailing, 3)
                }
                Text(viewModel.title)
                    .padding(.leading, 10)
            }
            .padding(8)
            .onTapGesture {
                viewModel.onTapHandler(viewModel.type)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            viewModel: SettingsViewViewModel(
                cellViewModels: SettingsOption.allCases.compactMap({
                    return SettingsCellViewViewModel(type: $0) { option in
                        print("pressend \(option)")
                    }
                })
            )
        )
    }
}
