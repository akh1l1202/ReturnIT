import UIKit

class HomeViewController: UIViewController {

    // MARK: - Storyboard Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Data
    var lostItems: [LostItem] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ReturnIT"
        loadMockData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.hidesBackButton = true
        loadMockData()
    }

    // MARK: - Actions
    @IBAction func filterChanged(_ sender: UISegmentedControl) {
        loadMockData()
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        JSONDataManager.shared.currentUser = nil
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Data loading
    private func loadMockData() {
        JSONDataManager.shared.loadItems()
        let allItems = JSONDataManager.shared.items

        switch segmentedControl.selectedSegmentIndex {
        case 1:
            lostItems = allItems.filter { $0.status.lowercased() == "lost" }
        case 2:
            lostItems = allItems.filter { $0.status.lowercased() == "found" }
        default:
            lostItems = allItems
        }

        tableView.reloadData()
    }
}

// MARK: - TableView
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lostItems.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemCell",
            for: indexPath
        )

        let item = lostItems[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = item.title
        content.secondaryText = "\(item.status.uppercased()) • \(item.location)"

        if let imageName = item.imageFileName,
           let image = JSONDataManager.shared.loadImage(named: imageName) {

            content.image = image
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            content.imageProperties.cornerRadius = 8
        } else {
            content.image = UIImage(systemName: "photo")
            content.imageProperties.maximumSize = CGSize(width: 50, height: 50)
            content.imageProperties.tintColor = .lightGray
        }

        cell.contentConfiguration = content
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedItem = lostItems[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(
            withIdentifier: "ItemDetailViewController"
        ) as! ItemDetailViewController

        detailVC.item = selectedItem
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
