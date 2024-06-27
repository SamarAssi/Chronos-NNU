//
//  ShiftsSuggestionsView.swift
//  Chronos
//
//  Created by Bassam Hillo on 24/06/2024.
//

import SwiftUI
import SimpleToast

struct ShiftsSuggestionsView: View {

    @Environment(\.presentationMode) var presentationMode
    @State var text = ""
    @State var isSubmitting = false
    @State var showShiftsView = false

    @State var errorMsg: LocalizedStringKey = ""
    @State var showToast = false
    @State var suggestedShifts: [Shift] = []

    var body: some View {
        NavigationStack {
            ZStack {
                contentView
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .theme))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                        .ignoresSafeArea()
                        .animation(.easeInOut, value: isSubmitting)
                }
            }
            .navigationTitle("Suggest Shifts")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Close")
                            .foregroundStyle(.theme)
                    }
                }
            }
            .navigationDestination(isPresented: $showShiftsView) {
                //SuggestedShiftsView(shifts: suggestedShifts)
            }
            .simpleToast(
                isPresented: $showToast,
                options: SimpleToastOptions(
                    alignment: .top,
                    hideAfter: 5,
                    animation: .linear(duration: 0.3),
                    modifierType: .slide,
                    dismissOnTap: true
                )) {
                    ToastView(
                        type: .error,
                        message: errorMsg
                    )
                    .padding(.horizontal, 30)
                }
        }
    }

    private var contentView: some View {
        VStack(spacing: 30) {

            Text("Give me a brief description about the shifts you want to create.")
                .font(.subheadline)

            TextEditor(text: $text)
                .font(.system(size: 15))
                .textInputAutocapitalization(.never)
                .tint(Color.theme)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(height: 200)

            Spacer()

            MainButton(
                isLoading: .constant(false),
                isEnable: .constant(true),
                buttonText: "Submit",
                backgroundColor: .theme) {
                    submit()
                }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    private func submit() {
        isSubmitting = true
        Task {
            do {
                self.suggestedShifts = try await ScheduleClient.suggestShifts(message: text).shifts
                if suggestedShifts.isEmpty {
                    self.errorMsg = LocalizedStringKey(
                        "No result, please try again."
                    )
                    self.showToast.toggle()
                } else {
                    showShiftsView.toggle()
                }
            } catch {
                self.errorMsg = LocalizedStringKey( error.localizedDescription
                )
                self.showToast.toggle()
            }
            isSubmitting = false
        }
    }
}

#Preview {
    ShiftsSuggestionsView()
}
