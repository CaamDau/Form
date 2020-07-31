//Created  on 2018/12/13  by LCD :https://github.com/liucaide .
/***** 模块文档 *****
* Form : TableView、CollectionView 流式排版协议，
 将 数据源 转化为 RowCell / RowCellClass 模型，即可将排版内容模型化，将 Delegate DataSource 多点关系，转化为单点关系，更便于扩展、维护、数据精准绑定。
 FormProtocol 是为普通MVVM模式准备
*/


import Foundation
import UIKit

public typealias Form = [CellProtocol]
public typealias Forms = [[CellProtocol]]

public typealias FormProtocol = (FormDataSource & FormDelegate)
public typealias FormRowAnimation = UITableView.RowAnimation

public protocol FormDataSource {
    /// 单元格数据组配置
    var _forms:[[CellProtocol]] { get }
    /// 页首数据组配置
    var _formHeaders:[CellProtocol] { get }
    /// 页尾数据组配置
    var _formFooters:[CellProtocol] { get }
}

public protocol FormDelegate {
    /// 数据刷新
    var _reloadData:(()->Void)? { set get }
    /// 指定单元格刷新 Animation 适用于 TableView, CollectionView无效
    var _reloadRows:(([IndexPath],FormRowAnimation)->Void)? { set get }
    /// 指定组刷新  Animation 适用于 TableView, CollectionView无效
    var _reloadSections:((IndexSet,FormRowAnimation)->Void)? { set get }
}


extension FormDataSource {
    public var _forms:[[CellProtocol]] { get{return []} }
    public var _formHeaders:[CellProtocol] { get{return []} }
    public var _formFooters:[CellProtocol] { get{return []} }
}


extension FormDelegate {
    public var _reloadData:(()->Void)? {
        get {
            return nil
        }
        set(newValue) {
            
        }
    }
    public var _reloadRows:(([IndexPath],FormRowAnimation)->Void)? {
        get {
            return nil
        }
        set(newValue) {
            
        }
    }
    public var _reloadSections:((IndexSet,FormRowAnimation)->Void)? {
        get {
            return nil
        }
        set(newValue) {
            
        }
    }
    
}


