//
//  SideMenuViewController.swift
//  Meteo
//
//  Created by Josue Muhiri Cizungu on 2024/03/06.
//

import UIKit

protocol SideMenuViewControllerDelegate: NSObjectProtocol {
    func selectedCell(_ row: Int)
    func selectedFavorites(_ data: FavoritesModel)
    func setTheme(_ theme: WeatherTheme)
    func addFavorite()
    func saveFavorites()
}

class SideMenuViewController: UIViewController {
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var sideMenuTableView: UITableView! {
        didSet {
            sideMenuTableView.register(UINib(nibName: "SideMenuOptionTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: SideMenuOptionTableViewCell.identifier)
            sideMenuTableView.rowHeight = UITableView.automaticDimension
            sideMenuTableView.estimatedRowHeight = 44
            sideMenuTableView.scrollsToTop = true
            sideMenuTableView.separatorStyle = .none
            sideMenuTableView.dataSource = self
            sideMenuTableView.delegate = self
        }
    }
    @IBOutlet weak var favoritesButton: UIButton! {
        didSet {
            favoritesButton.accessibilityIdentifier = "sideMenuFavoritesButton"
        }
    }
    @IBOutlet weak var favoritesTableView: UITableView! {
        didSet {
            favoritesTableView.register(UINib(nibName: "FavoritesTableViewCell", bundle: nil),
                                        forCellReuseIdentifier: FavoritesTableViewCell.identifier)
            favoritesTableView.rowHeight = UITableView.automaticDimension
            favoritesTableView.estimatedRowHeight = 44
            favoritesTableView.scrollsToTop = true
            favoritesTableView.dataSource = self
            favoritesTableView.delegate = self
        }
    }
    @IBOutlet weak var themeSelectorSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mainTitleLabel: UILabel!
    weak var delegate: SideMenuViewControllerDelegate?
    private var defaultHighlightedCell: Int = 0

    private var sideMenuOptions: [SideMenuOptionModel] = [
        SideMenuOptionModel(image: UIImage(systemName: "house")!, title: "Home"),
        SideMenuOptionModel(image: UIImage(systemName: "map")!, title: "Map")
    ]
    var favorites: [FavoritesModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        highlightSelectedRow()
        sideMenuTableView.reloadData()
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        themeSelectorSegmentedControl.setTitleTextAttributes(titleTextAttributes,
                                                             for: [.normal, .selected])
        getSavedFavorites()
    }

    private func getSavedFavorites() {

        if let favoritesJSON = Defaults.getFavoritesJSON(),
           let data = favoritesJSON.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                self.favorites = try decoder.decode([FavoritesModel].self, from: data)
                favoritesTableView.reloadData()
            } catch {
                print("Unable to parse saved favorites data")
            }
        }
    }

    private func highlightSelectedRow() {
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
    }
    
    @IBAction func favoritesButtonAction(_ sender: Any) {
        delegate?.addFavorite()
    }

    @IBAction func themeValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            delegate?.setTheme(.forest)
        } else {
            delegate?.setTheme(.sea)
        }
    }
}

extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sideMenuTableView {
            return sideMenuOptions.count
        } else {
            return favorites.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sideMenuTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuOptionTableViewCell.identifier,
                                                           for: indexPath)
                    as? SideMenuOptionTableViewCell else {
                fatalError("SideMenuOptionTableViewCell XIB was not found")
            }

            cell.fillUIWith(sideMenuOptions[indexPath.row])

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier,
                                                           for: indexPath)
                    as? FavoritesTableViewCell else {
                fatalError("FavoritesTableViewCell XIB was not found")
            }
            cell.fillUIWith(favorites[indexPath.row])

            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sideMenuTableView {
            self.delegate?.selectedCell(indexPath.row)

            if indexPath.row == 1 {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } else {
            self.delegate?.selectedFavorites(favorites[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == sideMenuTableView {
            return false
        }
        return true
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard tableView == favoritesTableView else {
            return
        }
        if editingStyle == .delete {
            favoritesTableView.beginUpdates()
            favorites.remove(at: indexPath.row)
            favoritesTableView.deleteRows(at: [indexPath], with: .automatic)
            favoritesTableView.endUpdates()
            delegate?.saveFavorites()
        }
    }
}
