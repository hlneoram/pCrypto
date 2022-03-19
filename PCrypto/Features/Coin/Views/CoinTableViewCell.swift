//
//  CoinTableViewCell.swift
//  PCrypto
//
//  Created by Ram Sharma on 14/03/22.
//

import Foundation
import UIKit
import SDWebImageSVGKitPlugin

class CoinTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var assetCode: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var rpValue: UILabel!
    @IBOutlet weak var gainImage: UIImageView!
    @IBOutlet weak var gainPercentage: UILabel!
    private let completion: (() -> Void)? = nil
    private var model: AssetsModel?
    private var subId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func updateUI(_ model: AssetsModel){
        if let sId = subId {
            SocketService.shared.emit(subscriberType: .unsubscibe, subId: sId)
            self.subId = nil
        }
        self.model = model
        self.assetCode.text = model.info?.assetCode
        self.name.text = model.info?.name
        self.rpValue.text = model.display?.lastPriceAndPercentageChange?.value
        if let color = model.display?.lastPriceAndPercentageChange?.valueColor {
            self.rpValue.textColor = UIColor.init(hexString: color)
        }
        self.gainPercentage.text = model.display?.lastPriceAndPercentageChange?.percentage
        if let color = model.display?.lastPriceAndPercentageChange?.percentageColor {
            self.gainPercentage.textColor = UIColor.init(hexString: color)
        }
        let svgURL = URL(string: model.info?.icon ?? "")!
        if model.display?.lastPriceAndPercentageChange?.arrowIcon == "GREEN" {
            gainImage.image =  UIImage.init(systemName: "arrowtriangle.up.fill")
            gainImage.tintColor = .green
        } else {
            gainImage.image = UIImage.init(systemName: "arrowtriangle.down.fill")
            gainImage.tintColor = .red
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            let svgCoder = SDImageSVGKCoder.shared
            SDImageCodersManager.shared.addCoder(svgCoder)
            self?.profileImage.sd_setImage(with: svgURL)
            // this arg is optional, if don't provide, use the viewport size instead
            let svgImageSize = CGSize(width: 100, height: 100)
            self?.profileImage.sd_setImage(with: svgURL, placeholderImage: nil, options: [], context: [.imageThumbnailPixelSize : svgImageSize])
        }
    }
    
    func observePriceChange() {
        if let sId = subId {
            SocketService.shared.emit(subscriberType: .unsubscibe, subId: sId)
            self.subId = nil
        }
        if let subId = self.model?.info?.subscriptionId {
            self.subId = subId
            SocketService.shared.emit(subscriberType: .subscribe, subId: subId)
            SocketService.shared.startListening(name: subId, completion: { [weak self] response in
                let dataArray = response as NSArray
                if let socketModel = self?.getModel(dataArray) {
                    let cryptocurrencySymbol = socketModel.currentPrice?.cryptocurrencySymbol
                    guard cryptocurrencySymbol?.uppercased() == self?.model?.info?.assetCode?.uppercased() else { return }
                    let priceChangePercent = socketModel.currentPrice?.priceChangePercent
                    self?.calculateRPValue(priceChangePercent)
                }
            })
        }
    }
    
    private func getModel(_ dataArray: NSArray) -> SocketPriceChangeResponseModel? {
        do {
            let json = try JSONSerialization.data(withJSONObject: dataArray)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let dataModel = try decoder.decode([SocketPriceChangeResponseModel].self, from: json)
            if let socketModel = dataModel.first {
             return socketModel
            }
        } catch {
            return nil
        }
        return nil
    }
    
    private func calculateRPValue(_ priceChangePercent: Double?) {
        if let changePercentage = priceChangePercent {
            self.gainPercentage.text = "\(changePercentage)"
            let lastRpValue = self.model?.display?.lastPriceAndPercentageChange?.value?.replacingOccurrences(of: "Rp", with: "")
            if let lastValue = lastRpValue, let rpValue = Double(lastValue) {
                let changedRpValue = rpValue * changePercentage / 100
                let newValue = rpValue + changedRpValue
                self.rpValue.text = "Rp\(newValue.rounded(toPlaces: 3))"
            }
            if changePercentage > 0 {
                self.gainImage.image =  UIImage.init(systemName: "arrowtriangle.up.fill")
                self.gainImage.tintColor = .green
            } else {
                self.gainImage.image = UIImage.init(systemName: "arrowtriangle.down.fill")
                self.gainImage.tintColor = .red
            }
        }
    }
}

