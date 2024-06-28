//
//  ScrollableListView.swift
//  Chronos
//
//  Created by Samar Assi on 17/06/2024.
//

import SwiftUI

struct ScrollableListView<T: Hashable & LabelRepresentable>: View {

    @State private var isTapped = false
    @State private var rotationAngle: Double = 0
    @Binding var selectedItems: [T]

    var label: LocalizedStringKey
    var items: [T]
    var withIcon: Bool

    var body: some View {
        NavigationStack {
            itemSelectionView
        }
    }
}

extension ScrollableListView {

    var itemSelectionView: some View {
        NavigationLink {
            ItemsListView(
                selectedItems: $selectedItems,
                items: items
            )
            .navigationBarBackButtonHidden()
        } label: {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                if withIcon {
                    Image(systemName: "chevron.right")
                }
            }
            .foregroundStyle(Color.black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ScrollableListView(
        selectedItems: .constant([]),
        label: "Select the job/s:",
        items: [
            Job(id: nil, name: "iOS"),
            Job(id: nil, name: "Android"),
            Job(id: nil, name: "Backend")
        ],
        withIcon: false
    )
}
