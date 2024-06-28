//
//  JobSettingsSection.swift
//  Chronos
//
//  Created by Bassam Hillo on 28/06/2024.
//

import SwiftUI

struct JobSettingsSection: View {
    @Binding var job: Job
    @State var isExpanded = false

    var body: some View {
        Section(isExpanded: $isExpanded) {
            HStack {
                Text("Sunday")
                    .font(.headline)
                    .foregroundColor(.theme)
                Spacer()
                NumberInputView(
                    title: "Count",
                    number: $job.sundaySettings.minimumNumberOfEmployees
                )
                .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Monday")
                    .font(.headline)
                    .foregroundColor(.theme)
                Spacer()
                NumberInputView(
                    title: "Count",
                    number: $job.mondaySettings.minimumNumberOfEmployees
                )
                .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Tuesday")
                    .font(.headline)
                    .foregroundColor(.theme)
                Spacer()
                NumberInputView(
                    title: "Count",
                    number: $job.tuesdaySettings.minimumNumberOfEmployees
                )
                .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Wednesday")
                    .font(.headline)
                    .foregroundColor(.theme)
                Spacer()
                NumberInputView(
                    title: "Count",
                    number: $job.wednesdaySettings.minimumNumberOfEmployees
                )
                .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Thursday")
                    .font(.headline)
                    .foregroundColor(.theme)
                Spacer()
                NumberInputView(
                    title: "Count",
                    number: $job.thursdaySettings.minimumNumberOfEmployees
                )
                .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Friday")
                    .font(.headline)
                    .foregroundColor(.theme)
                Spacer()
                NumberInputView(
                    title: "Count",
                    number: $job.fridaySettings.minimumNumberOfEmployees
                )
                .multilineTextAlignment(.trailing)
            }

            HStack {
                Text("Saturday")
                    .font(.headline)
                    .foregroundColor(.theme)
                Spacer()
                NumberInputView(
                    title: "Count",
                    number: $job.saturdaySettings.minimumNumberOfEmployees
                )
                .multilineTextAlignment(.trailing)
            }
        }  header: {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(job.name)
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

