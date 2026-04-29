import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var item: LostItem?
    var mainImageView: UIImageView?
    var resolvedButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Item Details"
        
        findImageView()
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func findImageView() {
        for subview in view.subviews {
            if let imgView = subview as? UIImageView {
                mainImageView = imgView
            } else {
                for nested in subview.subviews {
                    if let imgView = nested as? UIImageView {
                        mainImageView = imgView
                    }
                }
            }
        }
    }
    
    private func findContactButton(in parentView: UIView) -> UIButton? {
        for subview in parentView.subviews {
            if let button = subview as? UIButton, button.title(for: .normal)?.contains("@") == true || button.configuration?.title?.contains("@") == true {
                return button
            }
            if let found = findContactButton(in: subview) {
                return found
            }
        }
        return nil
    }
    
    private func populateData() {
        guard let item = item else { return }
        
        titleLabel?.text = item.title
        statusLabel?.text = item.status.uppercased()
        locationLabel?.text = item.location
        dateLabel?.text = item.date
        descriptionLabel?.text = item.description
        
        if let imageName = item.imageFileName, let image = JSONDataManager.shared.loadImage(named: imageName) {
            mainImageView?.image = image
            mainImageView?.contentMode = .scaleAspectFill
        } else {
            mainImageView?.image = UIImage(systemName: "photo")
            mainImageView?.tintColor = .lightGray
            mainImageView?.contentMode = .center
        }
        
        for subview in view.subviews {
            if let button = subview as? UIButton, button.titleLabel?.text?.contains("Resolved") == true {
                resolvedButton = button
                button.addTarget(self, action: #selector(markResolvedTapped), for: .touchUpInside)
            }
        }
        
        if let contactButton = findContactButton(in: view) {
            let emailString = item.posterEmail ?? "Contact"
            contactButton.setTitle(emailString, for: .normal)
            if contactButton.configuration != nil {
                contactButton.configuration?.title = emailString
            }
        }
        
        // Add location, date, and poster email display programmatically since they are missing from storyboard
        if let descLabel = descriptionLabel {
            let locLabel = UILabel()
            locLabel.text = "📍 Location: \(item.location)"
            locLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            locLabel.textColor = .darkGray
            locLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(locLabel)
            self.locationLabel = locLabel
            
            let dLabel = UILabel()
            dLabel.text = "📅 Date: \(item.date)"
            dLabel.font = .systemFont(ofSize: 15, weight: .medium)
            dLabel.textColor = .gray
            dLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(dLabel)
            self.dateLabel = dLabel
            
            let posterLabel = UILabel()
            posterLabel.text = "👤 Posted by: \(item.posterEmail ?? "Unknown")"
            posterLabel.font = .systemFont(ofSize: 15, weight: .medium)
            posterLabel.textColor = .gray
            posterLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(posterLabel)
            
            NSLayoutConstraint.activate([
                locLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
                locLabel.leadingAnchor.constraint(equalTo: descLabel.leadingAnchor),
                
                dLabel.topAnchor.constraint(equalTo: locLabel.bottomAnchor, constant: 8),
                dLabel.leadingAnchor.constraint(equalTo: descLabel.leadingAnchor),
                
                posterLabel.topAnchor.constraint(equalTo: dLabel.bottomAnchor, constant: 8),
                posterLabel.leadingAnchor.constraint(equalTo: descLabel.leadingAnchor)
            ])
        }
        
        updateResolvedUI()
    }
    
    private func updateResolvedUI() {
        guard let item = item else { return }
        
        if item.status.lowercased() == "resolved" {
            resolvedButton?.setTitle("Item Fully Resolved", for: .normal)
            resolvedButton?.backgroundColor = .systemGreen
            resolvedButton?.isEnabled = false
            statusLabel?.text = "RESOLVED"
            statusLabel?.backgroundColor = .systemGreen
            statusLabel?.textColor = .white
            return
        }
        
        var resolvedCount = 0
        if item.posterResolved { resolvedCount += 1 }
        if item.finderResolvedEmail != nil { resolvedCount += 1 }
        
        resolvedButton?.setTitle("Mark as Resolved (\(resolvedCount)/2)", for: .normal)
        
        // If current user already marked it, disable it to prevent spam clicks
        if let currentUser = JSONDataManager.shared.currentUser {
            if currentUser.email == item.posterEmail && item.posterResolved {
                resolvedButton?.isEnabled = false
                resolvedButton?.setTitle("Waiting for Finder...", for: .normal)
                resolvedButton?.backgroundColor = .systemGray
            } else if currentUser.email != item.posterEmail && item.finderResolvedEmail != nil {
                resolvedButton?.isEnabled = false
                resolvedButton?.setTitle("Waiting for Poster...", for: .normal)
                resolvedButton?.backgroundColor = .systemGray
            }
        }
    }
    
    @objc private func markResolvedTapped(_ sender: UIButton) {
        guard var item = self.item, let currentUser = JSONDataManager.shared.currentUser else {
            let alert = UIAlertController(title: "Error", message: "You must be logged in to mark this.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        if currentUser.email == item.posterEmail {
            item.posterResolved = true
        } else {
            item.finderResolvedEmail = currentUser.email
        }
        
        if item.posterResolved && item.finderResolvedEmail != nil {
            item.status = "Resolved"
        }
        
        self.item = item
        
        if let index = JSONDataManager.shared.items.firstIndex(where: { $0.id == item.id }) {
            JSONDataManager.shared.items[index] = item
            JSONDataManager.shared.saveItems()
        }
        
        updateResolvedUI()
    }
}
