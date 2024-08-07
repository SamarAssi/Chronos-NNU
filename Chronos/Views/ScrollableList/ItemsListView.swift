//
//  ItemsListView.swift
//  Chronos
//
//  Created by Samar Assi on 17/06/2024.
//

import SwiftUI

struct ItemsListView<T: Hashable & LabelRepresentable>: View {

    @Environment(\.dismiss) var dismiss
    @Binding var selectedItems: [T]

    var items: [T]
    
    var isDoneButtonDisabled: Bool {
        return selectedItems.isEmpty
    }
    
    var doneButtonColor: Color {
        isDoneButtonDisabled ?
        Color.theme.opacity(0.5) :
        Color.theme
    }

    var body: some View {
        NavigationStack {
            List(
                items,
                id: \.self
            ) { item in
                ListCellView(
                    isSelected: isSelectedItem(item: item),
                    name: item.label
                )
                .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                .onTapGesture {
                    toggleSelection(item: item)
                }
                .listRowSeparator(.hidden)
            }
            .padding()
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButtonView
                }
            }
        }
    }
    
    var backButtonView: some View {
        Image(systemName: "chevron.left")
            .scaleEffect(0.9)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    private func isSelectedItem(item: T) -> Binding<Bool> {
        return Binding(
            get: {
                selectedItems.contains(item)
            },
            set: { isSelected in
                if isSelected {
                    selectedItems.append(item)
                } else {
                    selectedItems.removeAll {
                        $0 == item
                    }
                }
            }
        )
    }
    
    private func toggleSelection(item: T) {
        if let index = selectedItems.firstIndex(of: item) {
            selectedItems.remove(at: index)
        } else {
            selectedItems.append(item)
        }
    }
}

#Preview {
    ItemsListView(
        selectedItems: .constant([]),
        items: [
            Job(
                id: nil,
                name: "iOS",
                sundaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                mondaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                tuesdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                wednesdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                thursdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                fridaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1),
                saturdaySettings: WeekdaysSettings(minimumNumberOfEmployees: 1)
            )
        ]
    )
}
