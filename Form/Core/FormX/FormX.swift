//Created  on 2020/7/14 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import Foundation


public protocol FormDataSourceX {
    var header: CellProtocol? { get }
    var footer: CellProtocol? { get }
    var items: [CellProtocol] { get }
}



public struct FormX:FormDataSourceX {
    
    public var header: CellProtocol?
    
    public var footer: CellProtocol?
    
    public var items: [CellProtocol]
    
    public init(items: [CellProtocol], header: CellProtocol? = nil, footer: CellProtocol? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
    

    public func insert(item:CellProtocol, at i:Int) -> FormX {
        var items = self.items
        items.insert(item, at: i)
        return FormX(items: items, header: header, footer: footer)
    }
    
    public func append(items:[CellProtocol]) -> FormX {
        return FormX(items: self.items + items, header: header, footer: footer)
    }
    
    public func replace(items:[CellProtocol]) -> FormX {
        return FormX(items: items, header: header, footer: footer)
    }
    
    public func replace(header:CellProtocol?) -> FormX {
        return FormX(items: items, header: header, footer: footer)
    }
    
    public func replace(footer:CellProtocol?) -> FormX {
        return FormX(items: items, header: header, footer: footer)
    }
    
    public func move(from f: Int, to t: Int) -> FormX {
        var items = self.items
        items.insert(items.remove(at: f), at: t)
        return FormX(items: items, header: header, footer: footer)
    }
    
    public func delete(idx:Int) -> FormX {
        var items = self.items
        items.remove(at: idx)
        return FormX(items: items, header: header, footer: footer)
    }
    
}


public class FormClassX: FormDataSourceX {
    public var header: CellProtocol?
    
    public var footer: CellProtocol?
    
    public var items: [CellProtocol] = []
    
    public init(items: [CellProtocol], header: CellProtocol? = nil, footer: CellProtocol? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
    
    public func insert(item:CellProtocol, at i:Int) {
        self.items.insert(item, at: i)
    }
    
    public func append(items:[CellProtocol]) {
        self.items += items
    }
    
    public func replace(items:[CellProtocol]) {
        self.items = items
    }
    
    public func replace(header:CellProtocol?) {
        self.header = header
    }
    
    public func replace(footer:CellProtocol?) {
        self.footer = footer
    }
    
    public func move(from f: Int, to t: Int) {
        self.items.insert(self.items.remove(at: f), at: t)
    }
    
    public func delete(idx:Int) {
        self.items.remove(at: idx)
    }
}
