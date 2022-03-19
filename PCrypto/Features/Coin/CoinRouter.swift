//
//  CoinViewController.swift
//  PCrypto
//
//  Created by Ram Sharma on 14/03/22.
//

import UIKit

protocol CoinRouterProtocol {
    
}

class CoinRouter: CoinRouterProtocol {
    // MARK: - Variables
    fileprivate weak var viewController: UIViewController?
    
    // MARK: - Methods
    static func createModule() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle:nil )
        if let controller = storyboard.instantiateInitialViewController() as? CoinViewController {
            let view = controller
            let interactor = CoinInteractor()
            let router = CoinRouter()
            let presenter = CoinPresenter(interface: view, interactor: interactor, router: router)
            
            view.presenter = presenter
            interactor.presenter = presenter
            router.viewController = view
            
            return view
        }
        return nil
    }
}

