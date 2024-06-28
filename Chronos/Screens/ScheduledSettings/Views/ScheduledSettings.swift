//
//  ScheduledSettings.swift
//  Chronos
//
//  Created by Samar Assi on 28/06/2024.
//

import SwiftUI

struct ScheduledSettings: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var jobsListModel = JobsListModel()
    @State private var weekdaysData = WeekdaysModel.data
    @State private var textFieldModels = TextFieldModel.weekdaysData
    
    var body: some View {
        VStack(alignment: .leading) {
            List(jobsListModel.jobs) { job in
                VStack {
                    ScheduledCellView(
                        job: job
                    )
                    setWeekdays(job: job)
                }
            }
            .listStyle(PlainListStyle())
            
            saveButtonView
                .padding()
        }
        .fontDesign(.rounded)
        .navigationTitle("Jobs Settings")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButtonView
            }
        }
        .onAppear {
            jobsListModel.getJobsList()
        }
    }
}

extension ScheduledSettings {
    
    var backButtonView: some View {
        Image(systemName: "chevron.left")
            .scaleEffect(0.9)
            .onTapGesture {
                dismiss.callAsFunction()
            }
    }
    
    var saveButtonView: some View {
        MainButton(
            isLoading: .constant(false),
            isEnable: .constant(false),
            buttonText: "Save",
            backgroundColor: Color.theme,
            action: {
                //jobsListModel.handleUpdateJobResponse(jobs: <#T##[Job]#>)
            }
        )
    }
    
    private func updateminimumNumberOfEmployeesForJobs() {
        var newJobs = jobsListModel.jobs
        
        for newJob in newJobs {
        }
    }
    
    private func setWeekdays(job: Job) -> some View {
        VStack(
            alignment: .leading,
            spacing: 0
        ) {
            ForEach(weekdaysData.indices, id: \.self) { index in
                HStack {
                    Text(weekdaysData[index].name.rawValue.capitalized)
                    Spacer()
                    setSettings(
                        weekday: weekdaysData[index].name.rawValue.capitalized,
                        job: job
                    )
                }
            }
        }
        .padding()
    }
    
    private func setSettings(
        weekday: String,
        job: Job
    ) -> some View {
        Group {
            switch weekday {
            case "Sunday":
                TextFieldView(
                    textFieldModel: TextFieldModel(
                        text: String(job.sundaySettings.minimumNumberOfEmployees),
                        label: "",
                        placeholder: "Min",
                        isSecure: false,
                        keyboardType: .numbersAndPunctuation,
                        isDisabled: false,
                        isOptional: false
                    )
                )
                .frame(width: 100)
                
            case "Monday":
                TextFieldView(
                    textFieldModel: TextFieldModel(
                        text: String(job.mondaySettings.minimumNumberOfEmployees),
                        label: "",
                        placeholder: "Min",
                        isSecure: false,
                        keyboardType: .numbersAndPunctuation,
                        isDisabled: false,
                        isOptional: false
                    )
                )
                .frame(width: 100)
                
            case "Tuesday":
                TextFieldView(
                    textFieldModel: TextFieldModel(
                        text: String(job.tuesdaySettings.minimumNumberOfEmployees),
                        label: "",
                        placeholder: "Min",
                        isSecure: false,
                        keyboardType: .numbersAndPunctuation,
                        isDisabled: false,
                        isOptional: false
                    )
                )
                .frame(width: 100)
                
            case "Wednesday":
                TextFieldView(
                    textFieldModel: TextFieldModel(
                        text: String(job.wednesdaySettings.minimumNumberOfEmployees),
                        label: "",
                        placeholder: "Min",
                        isSecure: false,
                        keyboardType: .numbersAndPunctuation,
                        isDisabled: false,
                        isOptional: false
                    )
                )
                .frame(width: 100)
                
            case "Thursday":
                TextFieldView(
                    textFieldModel: TextFieldModel(
                        text: String(job.thursdaySettings.minimumNumberOfEmployees),
                        label: "",
                        placeholder: "Min",
                        isSecure: false,
                        keyboardType: .numbersAndPunctuation,
                        isDisabled: false,
                        isOptional: false
                    )
                )
                .frame(width: 100)
                
            case "Friday":
                TextFieldView(
                    textFieldModel: TextFieldModel(
                        text: String(job.fridaySettings.minimumNumberOfEmployees),
                        label: "",
                        placeholder: "Min",
                        isSecure: false,
                        keyboardType: .numbersAndPunctuation,
                        isDisabled: false,
                        isOptional: false
                    )
                )
                .frame(width: 100)
                
            case "Saturday":
                TextFieldView(
                    textFieldModel: TextFieldModel(
                        text: String(job.saturdaySettings.minimumNumberOfEmployees),
                        label: "",
                        placeholder: "Min",
                        isSecure: false,
                        keyboardType: .numbersAndPunctuation,
                        isDisabled: false,
                        isOptional: false
                    )
                )
                .frame(width: 100)
               
                
                
            default:
                Text("-")
            }
            
        }
    }
}

struct WeekdaysModel: Identifiable {
    let id = UUID().uuidString
    let name: WeekdayModel.Weekdays
}

extension WeekdaysModel {
    static var data: [WeekdaysModel] {
        [
            WeekdaysModel(name: .saturday),
            WeekdaysModel(name: .sunday),
            WeekdaysModel(name: .monday),
            WeekdaysModel(name: .tuesday),
            WeekdaysModel(name: .wednesday),
            WeekdaysModel(name: .thursday),
            WeekdaysModel(name: .friday)
        ]
    }
}

#Preview {
    ScheduledSettings()
}
