//
//  Feed.swift
//  Reader
//
//  Created by Jean-Pierre Distler on 19.01.16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Cocoa

class Datas        : Codable {
    var name       : String
    var amount     : String
    var identifier : String
    var children   : [Children]
}

class Children     : Codable {
    var date       : String
    var mode       : String
    var comment    : String
    var category   : String
    var identifier : String
    var split      : [Split]
}

class Split        : Codable {
    var rubric     : String
    var amount     : String
    var identifier : String
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
