import UIKit

class PostItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    var nameField: UITextField?
    var categoryField: UITextField?
    var descTextView: UITextView?
    var locationField: UITextField?
    var dateField: UITextField?
    var segControl: UISegmentedControl?
    var uploadView: UIView?
    var submitButton: UIButton?
    
    var selectedImageView: UIImageView?
    var selectedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Item"
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitAction))
        
        findUIElements(in: view)
        setupUploadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func findUIElements(in parentView: UIView) {
        for subview in parentView.subviews {
            if let tf = subview as? UITextField {
                if let ph = tf.placeholder {
                    if ph.contains("Hydro Flask") || ph.lowercased().contains("name") { nameField = tf }
                    else if ph.lowercased().contains("category") { categoryField = tf }
                    else if ph.lowercased().contains("where") || ph.lowercased().contains("location") { locationField = tf }
                    else if ph.lowercased().contains("today") || ph.lowercased().contains("date") { dateField = tf }
                }
            } else if let tv = subview as? UITextView {
                descTextView = tv
                tv.delegate = self
            } else if let seg = subview as? UISegmentedControl {
                segControl = seg
            } else if let btn = subview as? UIButton, btn.title(for: .normal) == "Submit" || btn.configuration?.title == "Submit" {
                submitButton = btn
            } else if subview.backgroundColor == UIColor(white: 0.96999999999999997, alpha: 1.0) || subview.frame.origin.y > 700 {
                if subview is UIButton == false && subview is UILabel == false {
                    uploadView = subview
                }
            }
            
            if subview.subviews.count > 0 {
                findUIElements(in: subview)
            }
        }
    }
    
    private func setupUploadView() {
        guard let uploadView = uploadView else { return }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        uploadView.addGestureRecognizer(tap)
        uploadView.isUserInteractionEnabled = true
        
        selectedImageView = UIImageView(frame: uploadView.bounds)
        selectedImageView?.contentMode = .scaleAspectFill
        selectedImageView?.clipsToBounds = true
        selectedImageView?.layer.cornerRadius = 8
        uploadView.addSubview(selectedImageView!)
    }
    
    @objc private func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage {
            self.selectedImage = image
            self.selectedImageView?.image = image
        }
    }

    @objc private func submitAction() {
        guard let name = nameField?.text, !name.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter an item name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        var imageName: String? = nil
        if let image = selectedImage {
            let uniqueName = UUID().uuidString + ".jpg"
            imageName = JSONDataManager.shared.saveImage(image, withName: uniqueName)
        }
        
        let status = (segControl?.selectedSegmentIndex == 0) ? "Lost" : "Found"
        
        let newItem = LostItem(
            title: name,
            category: categoryField?.text ?? "Misc",
            status: status,
            location: locationField?.text ?? "Campus",
            date: dateField?.text ?? "Today",
            description: descTextView?.text ?? "",
            imageFileName: imageName,
            posterEmail: JSONDataManager.shared.currentUser?.email
        )
        
        JSONDataManager.shared.addItem(newItem)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        submitAction()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.contains("Distinguishing features") {
            textView.text = ""
            textView.textColor = .black
        }
    }
}
