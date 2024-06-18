//
//  PasswordValidationManager.swift
//  Chronos
//
//  Created by Samar Assi on 02/06/2024.
//

import Foundation

@Observable
class PasswordValidationManager: ObservableObject {
    static var shared = PasswordValidationManager()

    var constraints = ConstraintTextModel.data
    var passwordConstraintsModel = PasswordConstraintsModel()

    func isPasswordValid() -> Bool {
        return passwordConstraintsModel.containsUppercase &&
        passwordConstraintsModel.containsLowercase &&
        passwordConstraintsModel.containsNumber &&
        passwordConstraintsModel.containsSpecialChar &&
        passwordConstraintsModel.hasMinLength
    }

    func validatePassword(password: String) {
        passwordConstraintsModel.containsUppercase = validateUppercase(for: password)
        passwordConstraintsModel.containsLowercase = validateLowercase(for: password)
        passwordConstraintsModel.containsNumber = validateNumber(for: password)
        passwordConstraintsModel.containsSpecialChar = validateSpecialCharacter(for: password)
        passwordConstraintsModel.hasMinLength = validateLengthPassword(for: password)

        updateConstraints()
    }

    private func validateUppercase(for password: String) -> Bool {
        let uppercasePattern = try? NSRegularExpression(
            pattern: "[A-Z]+",
            options: []
        )

        return uppercasePattern?.numberOfMatches(
            in: password,
            options: [],
            range: NSRange(
                location: 0,
                length: password.count
            )
        ) ?? 0 > 0
    }

    private func validateLowercase(for password: String) -> Bool {
        let lowercasePattern = try? NSRegularExpression(
            pattern: "[a-z]+",
            options: []
        )

        return lowercasePattern?.numberOfMatches(
            in: password,
            options: [],
            range: NSRange(
                location: 0,
                length: password.count
            )
        ) ?? 0 > 0
    }

    private func validateNumber(for password: String) -> Bool {
        let numberPattern = try? NSRegularExpression(
            pattern: "\\d+",
            options: []
        )

        return numberPattern?.numberOfMatches(
            in: password,
            options: [],
            range: NSRange(
                location: 0,
                length: password.count
            )
        ) ?? 0 > 0
    }

    private func validateSpecialCharacter(for password: String) -> Bool {
        let specialCharPattern = try? NSRegularExpression(
            pattern: "[!@#$%^&*(),.?\":{}|<>]+",
            options: []
        )

        return specialCharPattern?.numberOfMatches(
            in: password,
            options: [],
            range: NSRange(
                location: 0,
                length: password.count
            )
        ) ?? 0 > 0
    }

    private func validateLengthPassword(for password: String) -> Bool {
        return password.count >= 8
    }

    private func updateConstraints() {
        constraints = ConstraintTextModel.data.map { constraint in
            let updatedConstraint = constraint

            switch constraint.text {
            case "• At least 8 characters":
                updatedConstraint.passwordConstraint = passwordConstraintsModel.hasMinLength

            case "• Contain at least one uppercase letter":
                updatedConstraint.passwordConstraint = passwordConstraintsModel.containsUppercase

            case "• Contain at least one lowercase letter":
                updatedConstraint.passwordConstraint = passwordConstraintsModel.containsLowercase

            case "• Contain at least one number":
                updatedConstraint.passwordConstraint = passwordConstraintsModel.containsNumber

            case "• Contain at least one special character":
                updatedConstraint.passwordConstraint = passwordConstraintsModel.containsSpecialChar

            default:
                break
            }

            return updatedConstraint
        }
    }
}
