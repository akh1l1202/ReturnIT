import UIKit

class HomeFeedViewController: UIViewController {

    // MARK: - Storyboard Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fabButton: UIButton!

    // MARK: - Data
    var lostItems: [LostFoundItem] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ReturnIT"
        
        // Setup table view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        // Register custom cell
        tableView.register(ItemCardCell.self, forCellReuseIdentifier: "ItemCardCell")
        
        setupFAB()
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
        DataLoader.shared.currentUser = nil
        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Setup
    private func setupFAB() {
        guard let fab = fabButton else { return }
        fab.layer.cornerRadius = 28
        fab.layer.shadowColor = UIColor.black.cgColor
        fab.layer.shadowOpacity = 0.2
        fab.layer.shadowOffset = CGSize(width: 0, height: 4)
        fab.layer.shadowRadius = 6
        fab.backgroundColor = UIColor(red: 0.15, green: 0.39, blue: 0.92, alpha: 1.0)
    }

    // MARK: - Data loading
    private func loadMockData() {
        DataLoader.shared.loadItems()
        let allItems = DataLoader.shared.items

        switch segmentedControl.selectedSegmentIndex {
        case 1:
            lostItems = allItems.filter { $0.status == .lost }
        case 2:
            lostItems = allItems.filter { $0.status == .found }
        default:
            lostItems = allItems
        }

        tableView.reloadData()
    }
}

// MARK: - TableView
extension HomeFeedViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lostItems.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ItemCardCell",
            for: indexPath
        ) as! ItemCardCell

        let item = lostItems[indexPath.row]
        cell.configure(with: item)
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
