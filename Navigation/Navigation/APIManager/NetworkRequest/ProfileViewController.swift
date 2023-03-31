//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Александр on 02.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private var modelStar: [[Any]] = [["Photos"], Modelstar.starArray()]

    let networkDataFetcher = NetworkDataFetcher()
    var newData: NewData? = nil

   // var albums = [ItunesAlbum]()



    //MARK: - Add Table View
    private lazy var myTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.sectionHeaderTopPadding = .zero
        tableView.sectionHeaderHeight = .zero
        tableView.sectionFooterHeight = .zero
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupLayoutConstraints()
        let urlString = "https://itunes.apple.com/search?term=jack+johnson&limit=25"

        networkDataFetcher.fetchPost(urlString: urlString) { (newData) in
            guard let newData = newData else {return}
            self.newData = newData
            self.myTableView.reloadData()
        }
    }
    
    //MARK: - Setup Layout Constraints
    private func setupLayoutConstraints() {
        view.addSubview(myTableView)
        
        NSLayoutConstraint.activate([
            
            myTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Extension UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return newData?.results.count ?? 0
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newData?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell: PhotosTableViewCell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as! PhotosTableViewCell
            cell.delegate = self
            return cell
            
        default:
//            if let model: Modelstar = modelStar[indexPath.section][indexPath.row] as? Modelstar {
                let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
                //cell.setupCell(model: model)
            let track = newData?.results[indexPath.row]

            cell.authorLabel.text = track?.artistName
            cell.myImageView.image = UIImage(named: "\(track?.artworkUrl60 ?? "")")
            cell.descriptionLabel.text = track?.collectionCensoredName
            cell.likesLabel.text = "Likes: \(track?.collectionId ?? 0)"
            cell.viewsLabel.text = "Views: \(track?.trackId ?? 0)"
                return cell
            //} else { return UITableViewCell() }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? ProfileHeaderView() : nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Extension UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && editingStyle == .delete {
            modelStar[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if var model: Modelstar = modelStar[indexPath.section][indexPath.row] as? Modelstar {
            let detailVC = DetailedViewController()
            model.views += 1
            detailVC.viewsLabel.text = "Views: \(model.views)"
            detailVC.likesLabel.text = "Likes: \(model.likes)"
            detailVC.detailedImageView.image = UIImage(named: model.image)
            detailVC.descriptionLabel.text = model.description
            detailVC.titleLabel.text = model.author
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

//MARK: - Gallery Button Action
extension ProfileViewController: PhotosTableViewCellDelegate {
    @objc internal func galleryButtonAction() {
        let photosVC = PhotosViewController()
        navigationController?.pushViewController(photosVC, animated: true)
    }
}