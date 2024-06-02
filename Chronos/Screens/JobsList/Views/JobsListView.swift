//
//  JobsListView.swift
//  Chronos
//
//  Created by Samar Assi on 01/06/2024.
//

import SwiftUI

struct JobsListView: View {
    @StateObject private var jobsListModel = JobsListModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var isEditing = true
    @State private var isShowAddJobView = false
        
    var body: some View {
        VStack(
            alignment: .leading
        ) {
            if jobsListModel.isLoading {
                CustomProgressView()
            } else {
                if let jobsResponse = jobsListModel.jobsResponse {
                    if jobsResponse.jobs.isEmpty {
                        emptyView
                    } else {
                        List(
                            jobsResponse.jobs,
                            id: \.self
                        ) { job in
                            Text(job.name)
                        }
                    }
                }
                tabView
            }
        }
        .fontDesign(.rounded)
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButtonView
            }
            
            ToolbarItem(placement: .topBarLeading) {
                titleView
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                editButtonView
            }
        }
        .onAppear {
            jobsListModel.getJobsList()
        }
        .fullScreenCover(isPresented: $isShowAddJobView) {
            AddJobView(jobsListModel: jobsListModel)
        }
    }
}

extension JobsListView {
    var titleView: some View {
        Text("Jobs List")
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxHeight: .infinity, alignment: .topLeading)
    }
    
    var emptyView: some View {
        VStack {
            Image(.SAMAR_911)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            Text("Oops, No jobs until now")
                .font(.subheadline)
                .fontWeight(.bold)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .center
        )
    }
    
    var editButtonView: some View {
        Group {
            if ((jobsListModel.jobsResponse?.jobs.isEmpty) == nil) {
                Button {
                    isEditing.toggle()
                } label: {
                    Text(isEditing ? "Edit" : "Done")
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                }
            }
        }
    }

    var backButtonView: some View {
        Image(systemName: "lessthan")
            .scaleEffect(0.6)
            .scaleEffect(x: 1, y: 2)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    var tabView: some View {
        HStack {
            if !isEditing {
                Image(systemName: "trash")
            }
            Image(systemName: "plus")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .onTapGesture {
                    isShowAddJobView.toggle()
                }
        }
        .frame(height: 30)
    }
}

#Preview {
    JobsListView()
}
