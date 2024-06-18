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

    var body: some View {
        NavigationStack {
            itemSelectionView
        }
    }
}

extension ScrollableListView {

    var itemSelectionView: some View {
        VStack(
            alignment: .leading
        ) {
            lableView
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isTapped {
                ItemsListView(
                    selectedItems: $selectedItems,
                    items: items
                )
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray)
//                    .frame(height: 45)
//                    .background {
//                        itemsListView(items: items)
//                    }
            }
        }
    }
    
    var lableView: some View {
        HStack {
//            Text(label)
//                .font(.subheadline)
//                .padding(.horizontal, 10)
            
            
            NavigationLink {
                ItemsListView(
                    selectedItems: $selectedItems,
                    items: items
                )
//                itemsListView(items: items)
                    .navigationBarBackButtonHidden()
            } label: {
                HStack {
                    Text(label)
                        .font(.subheadline)
                        .padding(.horizontal, 10)
                   // Image(systemName: "chevron.right")
                }
                .foregroundStyle(Color.black)
            }

//            Image(systemName: "chevron.right")
//                .rotationEffect(Angle(degrees: rotationAngle))
//                .animation(
//                    .spring(
//                        response: 0.3,
//                        dampingFraction: 0.6,
//                        blendDuration: 0
//                    ),
//                    value: rotationAngle
//                )
//                .onTapGesture {
//                    withAnimation(
//                        .spring(
//                            response: 0.3,
//                            dampingFraction: 0.6,
//                            blendDuration: 0
//                        )
//                    ) {
//                        isTapped.toggle()
//                        rotationAngle = isTapped ? -180 : -0
//                    
//                    }
//                }
        }
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
        ]
    )
}
