//
//  CoinInteractor.swift
//  PCrypto
//
//  Created by Ram Sharma on 14/03/22.
//

import Foundation

protocol CoinInteractorProtocol {
    func fetch(_ refresh: Bool)
    func configureSocket()
    func stopAllSubscribers()
}

class CoinInteractor {
    // MARK: - Variables
    weak var presenter: CoinPresenterProtocol?
    private var page = 0
    init() {
        fetch(true)
    }
    
    // MARK: -  Socket Methods
    func configureSocket() {
        if SocketService.shared.isConnected != true {
            SocketService.shared.connect(completion: {
                print(SocketService.shared.isConnected)
                self.presenter?.setObserverOnPriceChange()
            })
        }
    }
    
    func stopAllSubscribers() {
        SocketService.shared.stopAllSubscribers()
    }
}

extension CoinInteractor: CoinInteractorProtocol {
    func fetch(_ refresh: Bool = false) {
        if refresh {
            page = 0
        }
        page += 1
        NetworkManager().request(endPoint: .coins(page: page), success: { response in
            let decoder = JSONDecoder()
            do {
                if  let response = response {
                    let model = try decoder.decode(CoinResponseModel.self , from: response)
                    if let marks = model.data?.assetCategories.map({ return $0.assetCategoryData?.first?.assets }).first, let assets = marks {
                        self.presenter?.updateAssets(assets, totalPages: model.data?.totalCount ?? 0)
                    }
                }}
            catch {
                
            }
        }, failure: {error in
            DispatchQueue.main.async {
                if error.code == -1009 {
                    self.presenter?.alert(title: "No internet found", message: error.localizedDescription)
                } else {
                    self.presenter?.alert(title: "Something went Wrong", message: error.localizedDescription)
                }
            }
        })
    }
}

