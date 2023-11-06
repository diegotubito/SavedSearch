//
//  SavedSearchCell.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 06/11/2023.


import SwiftUI

struct SavedSearchViewCell: View {
    @State var title: String
    @State var subtitle: String
    @State var counter: Int = -1
    @State var behavior: Behavior = .tappable
    @State var isSelected: Bool = false
    
    enum Behavior {
        case selectable
        case tappable
    }
    
    struct Constants {
        static let selectedImageName = "circle.inset.filled"
        static let nonSelectedImageName = "circle"
        static let defaultTextForZeroCounter = "All"
        static let rightImageName = "chevron.right"
    }
        
    var body: some View {
        HStack {
            if behavior == .selectable && isSelected {
                Image(systemName: Constants.selectedImageName)
                    .foregroundColor(Color.blue)
            } else if behavior == .selectable && !isSelected {
                Image(systemName: Constants.nonSelectedImageName)
                    .foregroundColor(Color.gray)
            }
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(Color.black)
                    .font(.title2)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                }
                if counter > 0 {
                    Text("(\(String(counter)))")
                        .font(.caption)                        
                        .foregroundColor(Color.blue)
                } else if counter == 0 {
                    Text(Constants.defaultTextForZeroCounter)
                        .foregroundColor(Color.gray)
                        .font(.caption)
                }
            }
            Spacer()
            Image(systemName: Constants.rightImageName)
                .foregroundColor(Color.gray.opacity(0.5))
        }
        .padding(24)
        .background(Color.gray.opacity(0.5))
        .overlay(
            RoundedRectangle(cornerRadius: 3.0)
                .stroke(Color.gray, lineWidth: 0.2)
        )
        .cornerRadius(3.0)
    }
}

#Preview {
    SavedSearchViewCell(title: "Title", subtitle: "Subtitle", counter: 45)
}
