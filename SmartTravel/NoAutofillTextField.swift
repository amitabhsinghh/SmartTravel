//
//  NoAutofillTextField.swift
//  SmartTravel
//
//  Created by Amitabh Singh on 4/19/25.
//


import SwiftUI
import UIKit

struct NoAutofillTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let isSecure: Bool

    func makeUIView(context: Context) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.isSecureTextEntry = isSecure
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.textContentType = .none  // disables any content‑type hints
        tf.delegate = context.coordinator

        // THIS disables the “Automatic Strong Password” / QuickType bar entirely:
        tf.inputAssistantItem.leadingBarButtonGroups = []
        tf.inputAssistantItem.trailingBarButtonGroups = []

        return tf
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let binding: Binding<String>
        init(_ binding: Binding<String>) { self.binding = binding }

        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String
        ) -> Bool {
            let current = textField.text ?? ""
            guard let r = Range(range, in: current) else { return false }
            let updated = current.replacingCharacters(in: r, with: string)
            binding.wrappedValue = updated
            return true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
