//Created  on 2020/7/14 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import Foundation

public protocol FormViewModelProtocol {
    associatedtype Input
    associatedtype Output
    func input(_ input:Input)
    var output:((Output)->Void)? { set get }
}


public protocol FormXDataSource {
    var header: CellProtocol? { get }
    var footer: CellProtocol? { get }
    var rows: [CellProtocol] { get }
}



public struct FormX:FormXDataSource {
    public var header: CellProtocol?
    
    public var footer: CellProtocol?
    
    public var rows: [CellProtocol]
    

    public func insert(row:CellProtocol, at i:Int) -> FormX {
        var rows = self.rows
        rows.insert(row, at: i)
        return FormX(header: header, footer: footer, rows: rows)
    }
    
    public func append(rows:[CellProtocol]) -> FormX {
        return FormX(header: header, footer: footer, rows: self.rows + rows)
    }
    
    public func replace(rows:[CellProtocol]) -> FormX {
        return FormX(header: header, footer: footer, rows: rows)
    }
    
    public func replace(header:CellProtocol?) -> FormX {
        return FormX(header: header, footer: footer, rows: rows)
    }
    
    public func replace(footer:CellProtocol?) -> FormX {
        return FormX(header: header, footer: footer, rows: rows)
    }
    
    public func move(from f: Int, to t: Int) -> FormX {
        var rows = self.rows
        rows.insert(rows.remove(at: f), at: t)
        return FormX(header: header, footer: footer, rows: rows)
    }
    
    public func delete(idx:Int) -> FormX {
        var rows = self.rows
        rows.remove(at: idx)
        return FormX(header: header, footer: footer, rows: rows)
    }
    
}


public class FormXClass:FormXDataSource {
    public var header: CellProtocol?
    
    public var footer: CellProtocol?
    
    public var rows: [CellProtocol] = []
    
    
    public func insert(row:CellProtocol, at i:Int) {
        self.rows.insert(row, at: i)
    }
    
    public func append(rows:[CellProtocol]) {
        self.rows += rows
    }
    
    public func replace(rows:[CellProtocol]) {
        self.rows = rows
    }
    
    public func replace(header:CellProtocol?) {
        self.header = header
    }
    
    public func replace(footer:CellProtocol?) {
        self.footer = footer
    }
    
    public func move(from f: Int, to t: Int) {
        self.rows.insert(self.rows.remove(at: f), at: t)
    }
    
    public func delete(idx:Int) {
        self.rows.remove(at: idx)
    }
}
