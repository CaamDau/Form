//Created  on 2020/7/8 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import Foundation
import RxDataSources

public struct FormRx {
    public var header: Item?
    public var footer: Item?
    public var items: [Item]
}

extension FormRx: SectionModelType {
    public typealias Item = CellProtocol
    public init(original: FormRx, items: [Item], header: Item? = nil, footer: Item? = nil) {
        self.init(original: original, items: items)
        self.header = header
        self.footer = footer
    }
    public init(original: FormRx, items: [Item]) {
        self = original
        self.items = items
    }
    
    
    public func insert(row:Item, at i:Int) -> FormRx {
        var items = self.items
        items.insert(row, at: i)
        return FormRx(header: header, footer: footer, items: items)
    }
    
    public func append(rows:[Item]) -> FormRx {
        return FormRx(header: header, footer: footer, items: self.items + rows)
    }
    
    public func replace(rows:[Item]) -> FormRx {
        return FormRx(header: header, footer: footer, items: rows)
    }
    
    public func replace(header:Item?) -> FormRx {
        return FormRx(header: header, footer: footer, items: items)
    }
    
    public func replace(footer:Item?) -> FormRx {
        return FormRx(header: header, footer: footer, items: items)
    }
    
    public func move(from f: Int, to t: Int) -> FormRx {
        var items = self.items
        items.insert(items.remove(at: f), at: t)
        return FormRx(header: header, footer: footer, items: items)
    }
    
    public func delete(idx:Int) -> FormRx {
        var items = self.items
        items.remove(at: idx)
        return FormRx(header: header, footer: footer, items: items)
    }
}


