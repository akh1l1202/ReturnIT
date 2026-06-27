import UIKit

class ItemCardCell: UITableViewCell {
    
    let cardContainer = UIView()
    let thumbnailImageView = UIImageView()
    let statusBadgeView = UIView()
    let statusBadgeLabel = UILabel()
    let titleLabel = UILabel()
    let detailsLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Card Container
        cardContainer.backgroundColor = .white
        cardContainer.layer.cornerRadius = 16
        cardContainer.layer.shadowColor = UIColor.black.cgColor
        cardContainer.layer.shadowOpacity = 0.06
        cardContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardContainer.layer.shadowRadius = 8
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardContainer)
        
        // Thumbnail Image View
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(thumbnailImageView)
        
        // Status Badge View (Pill shape)
        statusBadgeView.layer.cornerRadius = 6
        statusBadgeView.clipsToBounds = true
        statusBadgeView.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(statusBadgeView)
        
        // Status Badge Label
        statusBadgeLabel.textColor = .white
        statusBadgeLabel.font = .systemFont(ofSize: 10, weight: .bold)
        statusBadgeLabel.textAlignment = .center
        statusBadgeLabel.translatesAutoresizingMaskIntoConstraints = false
        statusBadgeView.addSubview(statusBadgeLabel)
        
        // Title Label
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = UIColor(red: 0.09, green: 0.11, blue: 0.20, alpha: 1.0)
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(titleLabel)
        
        // Details Label (Category & Location)
        detailsLabel.font = .systemFont(ofSize: 13, weight: .regular)
        detailsLabel.textColor = UIColor(red: 0.46, green: 0.48, blue: 0.56, alpha: 1.0)
        detailsLabel.numberOfLines = 1
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(detailsLabel)
        
        // Date Label
        dateLabel.font = .systemFont(ofSize: 12, weight: .medium)
        dateLabel.textColor = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(dateLabel)
        
        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Card Container relative to cell content view
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Thumbnail Image inside card
            thumbnailImageView.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 12),
            thumbnailImageView.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            thumbnailImageView.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Status Badge (Top Right)
            statusBadgeView.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),
            statusBadgeView.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            statusBadgeView.heightAnchor.constraint(equalToConstant: 22),
            
            // Badge Label padding
            statusBadgeLabel.leadingAnchor.constraint(equalTo: statusBadgeView.leadingAnchor, constant: 8),
            statusBadgeLabel.trailingAnchor.constraint(equalTo: statusBadgeView.trailingAnchor, constant: -8),
            statusBadgeLabel.centerYAnchor.constraint(equalTo: statusBadgeView.centerYAnchor),
            
            // Title Label
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: statusBadgeView.leadingAnchor, constant: -8),
            
            // Details Label
            detailsLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailsLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),
            
            // Date Label
            dateLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            dateLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 6),
            dateLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -12),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardContainer.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with item: LostFoundItem) {
        titleLabel.text = item.name
        detailsLabel.text = "\(item.category) • \(item.location)"
        dateLabel.text = item.date
        
        // Status Badge configuration
        statusBadgeLabel.text = item.status.title.uppercased()
        statusBadgeView.backgroundColor = item.status.badgeColor
        
        // Image loading
        if let imageName = item.imageFileName,
           let image = DataLoader.shared.loadImage(named: imageName) {
            thumbnailImageView.image = image
            thumbnailImageView.contentMode = .scaleAspectFill
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
            thumbnailImageView.tintColor = .lightGray
            thumbnailImageView.contentMode = .center
        }
    }
}
