//
//  AddJobView.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import SwiftUI
import SimpleToast

struct AddJobView: View {
    
    @Environment (\.dismiss) var dismiss
    @Binding var jobs: [Job]
    @State var name: String
    let selectedIndex: Int?

    init(jobs: Binding<[Job]>, selectedIndex: Int?) {
        self._jobs = jobs
        self.selectedIndex = selectedIndex
        if let selectedIndex = selectedIndex {
            self.name = jobs[selectedIndex].name.wrappedValue
        } else {
            self.name = ""
        }
    }

    var body: some View {
        contentView
    }

    @ViewBuilder
    private var contentView: some View {
        NavigationStack {
            List {
                TextField("Job Name", text: $name)
                    .padding()
                    .cornerRadius(8)
                    .listRowInsets(EdgeInsets())
            }
            .navigationTitle(selectedIndex == nil ? "Add Job" : "Edit Job")
            .safeAreaInset(edge: .bottom) {
                MainButton(
                    isLoading: .constant(false),
                    isEnable: .constant(true),
                    buttonText: selectedIndex == nil ? "Add" : "Save",
                    backgroundColor: .theme) {
                        if let selectedIndex = selectedIndex {
                            jobs[selectedIndex].name = name
                        } else {
                            jobs.append(Job(id: nil, name: name))
                        }
                        dismiss()
                    }
                    .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .foregroundStyle(.theme)
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    AddJobView(
        jobs: .constant(
            [
                Job(id: "1", name: "Job 1"),
                Job(id: "2", name: "Job 2")
            ]
        ),
        selectedIndex: nil
    )
}
