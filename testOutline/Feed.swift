//
//  Feed.swift
//  Reader
//
//  Created by Jean-Pierre Distler on 19.01.16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Cocoa

struct Datas : Codable {
    var name: String
    var children: [Children]
}

struct Children : Codable {
    var date: String
    var title: String
    var category: String
}

extension Data {
    func decoded<T: Decodable>() throws -> T {
        return try PropertyListDecoder().decode(T.self, from: self)
    }
}

protocol AnyDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension PropertyListDecoder: AnyDecoder {}
