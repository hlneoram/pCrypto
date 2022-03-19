//
//  CoinModel.swift
//  PCrypto
//
//  Created by Ram Sharma on 14/03/22.
//


struct CoinResponseModel: Decodable {
    let data: CoinDataModel?
}

struct CoinDataModel: Decodable {
    let assetCategories: [AssetCategoriesModel]
    let totalCount: Int?
}

struct AssetCategoriesModel: Decodable {
    let assetCategory: String?
    let assetCategoryData: [AssetCategoryDataModel]?
    
    private enum CodingKeys: CodingKey {
        case assetCategory, assetCategoryData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.assetCategory = try? container.decode(String.self, forKey: .assetCategory)
        self.assetCategoryData = try? container.decode([AssetCategoryDataModel].self, forKey: .assetCategoryData)
    }
}

struct AssetCategoryDataModel: Decodable {
    let assetSubcategory: String?
    let assets: [AssetsModel]?
    
    private enum CodingKeys: CodingKey {
        case assetSubcategory, assets
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.assetSubcategory = try? container.decode(String.self, forKey: .assetSubcategory)
        self.assets = try? container.decode([AssetsModel].self, forKey: .assets)
    }
}

struct AssetsModel: Decodable {
    let display: DisplayModel?
    let info: InfoModel?
    
    private enum CodingKeys: CodingKey {
        case display, info
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.display = try? container.decode(DisplayModel.self, forKey: .display)
        self.info = try? container.decode(InfoModel.self, forKey: .info)
    }
}

struct DisplayModel: Decodable {
    let lastPriceAndPercentageChange: PriceChangeModel?
    
    private enum CodingKeys: CodingKey {
        case lastPriceAndPercentageChange
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lastPriceAndPercentageChange = try? container.decode(PriceChangeModel.self, forKey: .lastPriceAndPercentageChange)
    }
}

struct PriceChangeModel: Decodable {
    let arrowIcon: String?
    let percentage: String?
    let percentageColor: String?
    let rawPercentageChange: String?
    let value: String?
    let valueColor: String?
    
    private enum CodingKeys: CodingKey {
        case arrowIcon, percentage, percentageColor, rawPercentageChange, value, valueColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.arrowIcon = try? container.decode(String.self, forKey: .arrowIcon)
        self.percentage = try? container.decode(String.self, forKey: .percentage)
        self.percentageColor = try? container.decode(String.self, forKey: .percentageColor)
        self.rawPercentageChange = try? container.decode(String.self, forKey: .rawPercentageChange)
        self.value = try? container.decode(String.self, forKey: .value)
        self.valueColor = try? container.decode(String.self, forKey: .valueColor)
    }
}

struct InfoModel: Decodable {
    let name: String?
    let icon: String?
    let displaySymbol: String?
    let assetCode: String?
    let subscriptionId: String?
    
    private enum CodingKeys: CodingKey {
        case name, icon, displaySymbol, assetCode, subscriptionId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try? container.decode(String.self, forKey: .name)
        self.icon = try? container.decode(String.self, forKey: .icon)
        self.displaySymbol = try? container.decode(String.self, forKey: .displaySymbol)
        self.assetCode = try? container.decode(String.self, forKey: .assetCode)
        self.subscriptionId = try? container.decode(String.self, forKey: .subscriptionId)
    }
}
