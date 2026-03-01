//
//  CustomLocationView.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

import SwiftUI

struct CustomLocationView: View {
    
    @ObservedObject var viewModel: CustomLocationViewModel
    @FocusState private var focusedField: Field?
    @Environment(\.dismiss) private var dismiss
    
    enum Field {
        case name, latitude, longitude
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    makeFieldRow(
                        icon: "mappin.circle.fill",
                        placeholder: viewModel.placeholderForNameText,
                        text: $viewModel.name,
                        field: .name,
                        keyboardType: .default
                    )
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(viewModel.accessibilityNameText)
                    .accessibilityHint(viewModel.accessibilityNameHint)
                    
                } header: {
                    Text(viewModel.locationNameHeaderText)
                }
                
                Section {
                    makeFieldRow(
                        icon: "location.north.circle.fill",
                        placeholder: viewModel.latitudeFieldPlaceholderText,
                        text: $viewModel.latitude,
                        field: .latitude,
                        keyboardType: .decimalPad
                    )
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(viewModel.accessibilityLatitudeText)
                    .accessibilityHint(viewModel.accessibilityLatitudeHint)
                    
                    makeFieldRow(
                        icon: "location.circle.fill",
                        placeholder: viewModel.longitudeFieldPlaceholderText,
                        text: $viewModel.longitude,
                        field: .longitude,
                        keyboardType: .decimalPad
                    )
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(viewModel.accessibilityLongitudeText)
                    .accessibilityHint(viewModel.accessibilityLongitudeHint)
                } header: {
                    Text(viewModel.coordinatesHeaderText)
                } footer: {
                    Text(viewModel.coordinatesFooterText)
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel(viewModel.accessibilityFormText)
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(viewModel.cancelButtonText) {
                        dismiss()
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(viewModel.cancelButtonText)
                    .accessibilityHint(viewModel.accessibilityCancelHint)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(viewModel.addNewLocationText) {
                        viewModel.onAddTapped()
                        if viewModel.isFormValid {
                            dismiss()
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(viewModel.addNewLocationText)
                    .accessibilityHint(viewModel.accessibilityDoneHint)
                    .bold()
                }
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(viewModel.doneText) {
                        focusedField = nil
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(viewModel.doneText)
                }
            }
            .alert(
                viewModel.invalidCoordinatesErrorText,
                isPresented: $viewModel.showError
            ) {
                Button(viewModel.okButtonText, role: .cancel) {}
                    .accessibilityAddTraits(.isButton)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(viewModel.okButtonText)
            } message: {
                Text(viewModel.errorMessage)
            }
            .onChange(of: viewModel.showError) { _, isShowing in
                guard isShowing else { return }
                AccessibilityNotification.Announcement(viewModel.alertAnnouncementErrorText).post()
            }
        }
    }
    
    private func makeFieldRow(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        field: Field,
        keyboardType: UIKeyboardType
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.tint)
            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .focused($focusedField, equals: field)
                .autocorrectionDisabled()
        }
    }
}

