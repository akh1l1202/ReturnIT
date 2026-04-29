import UIKit
import CryptoKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }

    @IBAction func registerButtonTapped(_ sender: UIButton) {
        guard
            let name = nameField.text, !name.isEmpty,
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !email.isEmpty,
            let password = passwordField.text, !password.isEmpty,
            let confirm = confirmPasswordField.text, !confirm.isEmpty
        else {
            showAlert("Please fill in all fields.")
            return
        }

        if password != confirm {
            showAlert("Passwords do not match.")
            return
        }

        if JSONDataManager.shared.users.contains(where: { $0.email == email }) {
            showAlert("A user with this email already exists.")
            return
        }

        let passwordHash = hashPassword(password)
        let newUser = User(fullName: name, email: email, passwordHash: passwordHash)

        JSONDataManager.shared.addUser(newUser)
        JSONDataManager.shared.currentUser = newUser

        proceedToHome()
    }

    private func proceedToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(
            withIdentifier: "HomeViewController"
        )
        navigationController?.pushViewController(homeVC, animated: true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "ReturnIT",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
