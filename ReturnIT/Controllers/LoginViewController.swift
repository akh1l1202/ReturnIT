import UIKit
import CryptoKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
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
    
    @IBAction func passwordToggleButton(_ sender: UIButton) {
        passwordField.isSecureTextEntry.toggle()

        let imageName = passwordField.isSecureTextEntry ? "eye.slash" : "eye"
        sender.setImage(UIImage(systemName: imageName), for: .normal)
        let currentText = passwordField.text
        passwordField.text = nil
        passwordField.text = currentText
    }
    

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard
            let email = emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
            !email.isEmpty,
            let password = passwordField.text,
            !password.isEmpty
        else {
            showAlert("Please enter email and password.")
            return
        }

        let passwordHash = hashPassword(password)

        if let user = DataLoader.shared.users.first(
            where: { $0.email == email && $0.passwordHash == passwordHash }
        ) {
            DataLoader.shared.currentUser = user
            proceedToHome()
        } else {
            showAlert("Invalid email or password.")
        }
    }

    private func proceedToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(
            withIdentifier: "HomeFeedViewController"
        )
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    private func proceedToMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarVC = storyboard.instantiateViewController(
            withIdentifier: "MainTabBarController"
        )
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
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
