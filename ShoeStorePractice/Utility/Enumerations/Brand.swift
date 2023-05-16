//
//  Brand.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/16.
//

import Foundation

enum Brand: String, CaseIterable {
    case adidas
    case puma
    case nike
    case crocs
    case skechers
    case reebok

    var title: String {
        switch self {
        case .adidas:
            return "Adidas"
        case .puma:
            return "Puma"
        case .nike:
            return "Nike"
        case .crocs:
            return "Crocs"
        case .skechers:
            return "Skechers"
        case .reebok:
            return "Reebok"
        }
    }
}
