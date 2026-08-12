//
//  Avatar.swift
//  AppleMarket
//
//  Created by Дмитрий Ильинский on 22.07.2026.
//

import UIKit

enum Avatar: String, CaseIterable, Codable {
    case avatar1
    case avatar2
    case avatar3
    case avatar4
    case avatar5
    case avatar6
    case avatar7
    case avatar8
    case avatar9
}

extension Avatar {
    var image: UIImage {
        UIImage(named: rawValue) ?? UIImage(systemName: "person.circle")!
    }
}
