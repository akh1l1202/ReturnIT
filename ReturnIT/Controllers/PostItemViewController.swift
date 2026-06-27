import UIKit

class PostItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var uploadView: UIView!
    
    var selectedImageView: UIImageView?
    var selectedImage: UIImage?
    private var dashedBorderLayer: CAShapeLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Post Item"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(submitAction))
        
        setupUploadView()
        setupCategoryPicker()
        setupDatePicker()
        setupDescriptionPlaceholder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupDashedBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUploadView() {
        guard let uploadView = uploadView else { return }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        uploadView.addGestureRecognizer(tap)
        uploadView.isUserInteractionEnabled = true
        
        let imgView = UIImageView(frame: uploadView.bounds)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        uploadView.addSubview(imgView)
        selectedImageView = imgView
    }
    
    private func setupDashedBorder() {
        guard let uploadView = uploadView else { return }
        
        dashedBorderLayer?.removeFromSuperlayer()
        
        let border = CAShapeLayer()
        border.strokeColor = UIColor.systemGray4.cgColor
        border.fillColor = nil
        border.lineDashPattern = [6, 4]
        border.path = UIBezierPath(roundedRect: uploadView.bounds, cornerRadius: 8).cgPath
        border.frame = uploadView.bounds
        
        uploadView.layer.addSublayer(border)
        dashedBorderLayer = border
    }
    
    private func setupCategoryPicker() {
        categoryField?.addTarget(self, action: #selector(categoryFieldTapped), for: .editingDidBegin)
    }
    
    @objc private func categoryFieldTapped() {
        categoryField?.resignFirstResponder()
        
        let categories = ["Electronics", "Keys", "Books", "Accessories", "Stationery", "Clothing", "Other"]
        let alert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        
        for category in categories {
            alert.addAction(UIAlertAction(title: category, style: .default, handler: { [weak self] _ in
                self?.categoryField?.text = category
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func setupDatePicker() {
        dateField?.addTarget(self, action: #selector(dateFieldEditingDidBegin), for: .editingDidBegin)
    }
    
    @objc private func dateFieldEditingDidBegin() {
        dateField?.resignFirstResponder()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
        let alert = UIAlertController(title: "Select Date & Time", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 40),
            datePicker.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -60)
        ])
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { [weak self] _ in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            self?.dateField?.text = formatter.string(from: datePicker.date)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func setupDescriptionPlaceholder() {
        descTextView.delegate = self
        if descTextView.text.isEmpty || descTextView.text == "Distinguishing features, brand, condition..." {
            descTextView.text = "Distinguishing features, brand, condition..."
            descTextView.textColor = .lightGray
        }
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
            dashedBorderLayer?.isHidden = true
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
            imageName = DataLoader.shared.saveImage(image, withName: uniqueName)
        }
        
        let status: ItemStatus = (segControl?.selectedSegmentIndex == 0) ? .lost : .found
        
        let descriptionText = (descTextView.text == "Distinguishing features, brand, condition..." && descTextView.textColor == .lightGray) ? "" : descTextView.text
        
        let newItem = LostFoundItem(
            name: name,
            category: categoryField?.text ?? "Misc",
            status: status,
            location: locationField?.text ?? "Campus",
            date: dateField?.text ?? "Today",
            description: descriptionText ?? "",
            imageFileName: imageName,
            posterEmail: DataLoader.shared.currentUser?.email
        )
        
        DataLoader.shared.addItem(newItem)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        submitAction()
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Distinguishing features, brand, condition..."
            textView.textColor = .lightGray
        }
    }
}
