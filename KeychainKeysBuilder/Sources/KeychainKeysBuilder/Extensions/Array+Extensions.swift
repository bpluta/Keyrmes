//
//  Array+Extensions.swift
//  Keyrmes
//
//  Created by Bartłomiej Pluta
//

extension Array {
    func mapFirst<E>(_ transform: (Element) throws(E) -> Element) throws(E) -> Self where E : Error {
        guard let first else { return self }
        let newElement = try transform(first)
        return [newElement] + Self(dropFirst())
    }
    
    func mapLast<E>(_ transform: (Element) throws(E) -> Element) throws(E) -> Self where E : Error {
        guard let last else { return self }
        let newElement = try transform(last)
        return Self(dropLast()) + [newElement]
    }
}
