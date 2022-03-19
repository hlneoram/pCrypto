//
//  CoinViewController.swift
//  PCrypto
//
//  Created by Ram Sharma on 14/03/22.
//

import UIKit

protocol CoinViewProtocol: AnyObject {
    func updateAssets(_ assets: [AssetsModel], totalPages: Int)
    func setObserverOnPriceChange()
    func alert(title:String, message:String)
}

class CoinViewController: UIViewController {
    // MARK: - Variables
    var presenter: CoinPresenterProtocol?
    private var assets = [AssetsModel]()
    private var totalPages = 0
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    @IBOutlet weak var viewLoadMore: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var dragged = false
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView?.register(UINib.init(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinTableViewCell")
    }
    
    private func showLoader() {
        self.viewLoadMore.isHidden = false
    }
    
    private func hideLoader() {
        self.viewLoadMore.isHidden = true
    }
}

// MARK: - CoinViewProtocol
extension CoinViewController: CoinViewProtocol {
    func updateAssets(_ assets: [AssetsModel], totalPages: Int) {
        self.assets.append(contentsOf: assets)
        self.totalPages = totalPages
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.hideLoader()
            self?.presenter?.configureSocket()
        }
    }
    
    func setObserverOnPriceChange() {
        if let allVisibleIndexPaths = self.tableView.indexPathsForVisibleRows {
            for indexPath in allVisibleIndexPaths {
                if let cell = self.tableView.cellForRow(at: indexPath) as? CoinTableViewCell {
                    cell.observePriceChange()
                }
            }
        }
    }
    
    func alert(title:String, message:String) {
        self.showAlert(title: title, message: message)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CoinViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell", for: indexPath) as! CoinTableViewCell
        cell.updateUI(self.assets[indexPath.row])
        if indexPath.row == self.assets.count - 2 {
            if self.totalPages > self.assets.count {
                showLoader()
                self.presenter?.fetch(false)
            }
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.dragged = true
        self.presenter?.stopAllSubscribers()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.dragged = false
        self.presenter?.stopAllSubscribers()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.dragged == false {
             setObserverOnPriceChange()
        }
        self.dragged = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if self?.dragged == true {
                self?.setObserverOnPriceChange()
            }
        }
    }
}
