import UIKit

class ItemDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var resolvedButton: UIButton!
    @IBOutlet weak var contactButton: UIButton!
    
    // Programmatic labels (missing from storyboard layout)
    var locationLabel: UILabel?
    var dateLabel: UILabel?
    var posterLabel: UILabel?
    
    var item: LostFoundItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Item Details"
        
        setupActions()
        populateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupActions() {
        resolvedButton?.addTarget(self, action: #selector(markResolvedTapped), for: .touchUpInside)
        contactButton?.addTarget(self, action: #selector(contactButtonTapped), for: .touchUpInside)
    }
    
    @objc private func contactButtonTapped() {
        guard let item = item, let email = item.posterEmail else { return }
        
        if let url = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                let alert = UIAlertController(title: "Contact Poster", message: "Send email to \(email)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Copy Email", style: .default, handler: { _ in
                    UIPasteboard.general.string = email
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alert, animated: true)
            }
        }
    }
    
    private func populateData() {
        guard let item = item else { return }
        
        titleLabel?.text = item.name
        statusLabel?.text = item.status.title.uppercased()
        statusLabel?.backgroundColor = item.status.badgeColor
        statusLabel?.textColor = .white
        statusLabel?.layer.cornerRadius = 14
        statusLabel?.clipsToBounds = true
        
        descriptionLabel?.text = item.description
        
        if let imageName = item.imageFileName, let image = DataLoader.shared.loadImage(named: imageName) {
            mainImageView?.image = image
            mainImageView?.contentMode = .scaleAspectFill
        } else {
            mainImageView?.image = UIImage(systemName: "photo")
            mainImageView?.tintColor = .lightGray
            mainImageView?.contentMode = .center
        }
        
        if let emailString = item.posterEmail {
            contactButton?.setTitle(emailString, for: .normal)
            if contactButton?.configuration != nil {
                contactButton?.configuration?.title = emailString
            }
        }
        
        // Add location, date, and poster email display programmatically
        if let descLabel = descriptionLabel {
            locationLabel?.removeFromSuperview()
            dateLabel?.removeFromSuperview()
            posterLabel?.removeFromSuperview()
            
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
            
            let pLabel = UILabel()
            pLabel.text = "👤 Posted by: \(item.posterEmail ?? "Unknown")"
            pLabel.font = .systemFont(ofSize: 15, weight: .medium)
            pLabel.textColor = .gray
            pLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(pLabel)
            self.posterLabel = pLabel
            
            NSLayoutConstraint.activate([
                locLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
                locLabel.leadingAnchor.constraint(equalTo: descLabel.leadingAnchor),
                locLabel.trailingAnchor.constraint(equalTo: descLabel.trailingAnchor),
                
                dLabel.topAnchor.constraint(equalTo: locLabel.bottomAnchor, constant: 8),
                dLabel.leadingAnchor.constraint(equalTo: descLabel.leadingAnchor),
                dLabel.trailingAnchor.constraint(equalTo: descLabel.trailingAnchor),
                
                pLabel.topAnchor.constraint(equalTo: dLabel.bottomAnchor, constant: 8),
                pLabel.leadingAnchor.constraint(equalTo: descLabel.leadingAnchor),
                pLabel.trailingAnchor.constraint(equalTo: descLabel.trailingAnchor)
            ])
        }
        
        updateResolvedUI()
    }
    
    private func updateResolvedUI() {
        guard let item = item else { return }
        
        if item.status == .resolved {
            resolvedButton?.setTitle("Item Fully Resolved", for: .normal)
            resolvedButton?.backgroundColor = .systemGreen
            resolvedButton?.tintColor = .white
            resolvedButton?.layer.borderWidth = 0
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
        resolvedButton?.backgroundColor = .clear
        resolvedButton?.layer.borderWidth = 1.5
        resolvedButton?.layer.borderColor = UIColor.systemGreen.cgColor
        resolvedButton?.setTitleColor(.systemGreen, for: .normal)
        resolvedButton?.isEnabled = true
        
        if let currentUser = DataLoader.shared.currentUser {
            if currentUser.email == item.posterEmail && item.posterResolved {
                resolvedButton?.isEnabled = false
                resolvedButton?.setTitle("Waiting for Finder...", for: .normal)
                resolvedButton?.backgroundColor = .systemGray5
                resolvedButton?.setTitleColor(.gray, for: .normal)
                resolvedButton?.layer.borderColor = UIColor.gray.cgColor
            } else if currentUser.email != item.posterEmail && item.finderResolvedEmail != nil {
                resolvedButton?.isEnabled = false
                resolvedButton?.setTitle("Waiting for Poster...", for: .normal)
                resolvedButton?.backgroundColor = .systemGray5
                resolvedButton?.setTitleColor(.gray, for: .normal)
                resolvedButton?.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
    
    @objc private func markResolvedTapped(_ sender: UIButton) {
        guard var item = self.item, let currentUser = DataLoader.shared.currentUser else {
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
            item.status = .resolved
        }
        
        self.item = item
        
        if let index = DataLoader.shared.items.firstIndex(where: { $0.id == item.id }) {
            DataLoader.shared.items[index] = item
            DataLoader.shared.saveItems()
        }
        
        updateResolvedUI()
    }
}
