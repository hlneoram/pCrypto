//
//  CoinPresenter.swift
//  PCrypto
//
//  Created by Ram Sharma on 14/03/22.
//

import UIKit

protocol CoinPresenterProtocol: AnyObject {
    func updateAssets(_ assets: [AssetsModel], totalPages: Int)
    func fetch(_ refresh: Bool)
    func configureSocket()
    func stopAllSubscribers()
    func setObserverOnPriceChange()
    func alert(title:String, message:String)
}

class CoinPresenter {
    // MARK: - Variables
    weak private var view: CoinViewProtocol?
    private var interactor: CoinInteractorProtocol?
    private let router: CoinRouterProtocol
    
    // MARK: - Methods
    init(interface: CoinViewProtocol, interactor: CoinInteractorProtocol?, router: CoinRouterProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
}

extension CoinPresenter: CoinPresenterProtocol {
    func updateAssets(_ assets: [AssetsModel], totalPages: Int) {
        self.view?.updateAssets(assets, totalPages: totalPages)
    }
    
    func fetch(_ refresh: Bool = false) {
        self.interactor?.fetch(refresh)
    }
    
    func alert(title:String, message:String) {
        self.view?.alert(title: title, message: message)
    }
    
    // MARK: -  Socket Methods
    func configureSocket() {
        self.interactor?.configureSocket()
    }
    
    func stopAllSubscribers() {
        self.interactor?.stopAllSubscribers()
    }
    
    func setObserverOnPriceChange() {
        self.view?.setObserverOnPriceChange()
    }
}

