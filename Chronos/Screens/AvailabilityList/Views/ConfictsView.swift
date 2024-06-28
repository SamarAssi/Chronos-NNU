//
//  ConfictsView.swift
//  Chronos
//
//  Created by Tareq Khalili on 28/06/2024.
//

import SwiftUI

struct ConfictsView: View {
    
    var conflicts: [AvailabilityConflict]
    var warnings: [String]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Conflicts").font(.system(size: 16)).foregroundStyle(.red)) {
                    ForEach(conflicts, id: \.self) { conflict in
                        Text(
                            LocalizedStringKey(
                                [
                                    "Shift on",
                                    conflict.day ?? "--",
                                    "from",
                                    conflict.start?.stringTime ?? "--",
                                    "to",
                                    conflict.end?.stringTime ?? "--"
                                ].joined(separator: " ")
                            )
                        )
                    }
                }
                Section(header: Text("Warnings").font(.system(size: 16)).foregroundStyle(.darkYellow)) {
                    ForEach(warnings, id: \.self) { warning in
                        Text(warning)
                    }
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
            .listRowSeparator(.hidden)
            .navigationTitle("Request issues")
        }
    }
    
    func conflictsView(conflicts: [AvailabilityConflict]) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(conflicts) { conflict in
                    Text(
                        LocalizedStringKey(
                            [
                                "Shift on",
                                conflict.day ?? "--",
                                "from",
                                conflict.start?.stringTime ?? "--",
                                "to",
                                conflict.end?.stringTime ?? "--"
                            ].joined(separator: " ")
                        )
                    )
                    .font(.system(size: 16))
                    .foregroundStyle(Color.red)
                    .frame(height: 30)
                }
            }
        }
    }
}
