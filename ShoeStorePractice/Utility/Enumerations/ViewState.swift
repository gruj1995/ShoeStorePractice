//
//  ViewState.swift
//  ShoeStorePractice
//
//  Created by 李品毅 on 2023/5/13.
//

import Foundation

// MARK: - ViewState

enum ViewState {
    case loading
    case success
    case failed(error: Error)
    case none
}
