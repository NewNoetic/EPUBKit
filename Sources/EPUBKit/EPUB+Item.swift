//
//  File.swift
//  
//
//  Created by Jaehong Kang on 2020/01/10.
//

import Foundation
import XMLKit

extension EPUB {
    public struct Item: Hashable {
        public var ref: Ref
        public var relativePath: String
        public var mimeType: String
    }
}

extension EPUB.Item: Identifiable {
    public var id: Ref.ID {
        return ref.id
    }
}

extension EPUB.Item {
    public struct Ref: Identifiable, Hashable {
        public var id: String
    }
}

extension EPUB.Item {
    static func items(manifestXMLElement: XMLKit.XMLElement) throws -> [Self] {
        return try manifestXMLElement.childeren.map {
            guard
                let id = $0.attributes["id"],
                let relativePath = $0.attributes["href"],
                let mimeType = $0.attributes["media-type"]
            else {
                throw EPUB.Error.invalidEPUB
            }

            return .init(ref: .init(id: id), relativePath: relativePath, mimeType: mimeType)
        }
    }
}

extension Array where Element == EPUB.Item {
    public subscript(_ ref: Element.Ref) -> Element? {
        first(where: { $0.id == ref.id })
    }

    public subscript(_ id: Element.Ref.ID) -> Element? {
        first(where: { $0.id == id })
    }
}
