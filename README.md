<p>
  <img src="https://github.com/liucaide/Images/blob/master/CaamDau/caamdau.png" align=centre />
</p>

[![CI Status](https://img.shields.io/travis/CaamDau/Form.svg?style=flat)](https://travis-ci.org/CaamDau/Form)
[![Version](https://img.shields.io/cocoapods/v/CaamDauForm.svg?style=flat)](https://cocoapods.org/pods/CaamDauForm)
[![License](https://img.shields.io/cocoapods/l/CaamDauForm.svg?style=flat)](https://cocoapods.org/pods/CaamDauForm)
[![Platform](https://img.shields.io/cocoapods/p/CaamDauForm.svg?style=flat)](https://cocoapods.org/pods/CaamDauForm)
[![](https://img.shields.io/badge/Swift-4.0~5.0-orange.svg?style=flat)](https://cocoapods.org/pods/CaamDauForm)

# Form  （[OC版本在这里](https://github.com/liucaide/CaamDauObjC)）

```ruby
pod 'CaamDau/Form'
pod 'CaamDauForm'

pod 'CaamDauForm/Rx' // 支持RxSwift
```
> 目标：用一点点代码 实现 高耦合的 UI 排版解耦，增强排版随机、变更、扩展能力，增强 UI-Data 关联强度；解决TableView/CollectionView 混合排版 Delegate/DataSource 中 section row height didselect 等多点关系的灾难

> 无论界面多复杂，都是一样的代码，使用这种方式即可轻松完成复杂的 UI 排版，编写可读性、扩展性、维护性强的代码

> 原理：这是一个UI排版模型，将UI排版逻辑 事先转换为 Row 模型单元！
- [如何做到不需要再维护Delegate/DataSource协议的代码](#如何做到不需要再维护Delegate和DataSource协议的代码)
- [Form / FormX / FormRx的区别](#几个Form的区别)
- [如何构建一个单元格模型Row](#如何构建一个单元格模型Row)
- [如何构建一个单元格组模型FormX](#如何构建一个单元格组模型FormX)
- [如何构建一个支持 RxSwift 单元格组模型FormRx](#如何构建支持RxSwift单元格组模型FormRx)
- [如何应对混合排版](#如何应对混合排版)
- [如何扩展实现自定义功能](#如何扩展实现自定义功能)
- [对比：以前混乱的代码](#以前混乱的代码)
- [对比：现在有序的代码](#现在有序的代码)

## 如何做到不需要再维护Delegate和DataSource协议的代码
- 首先要明白 Delegate/DataSource 中 section row height didselect 的多点关系是有迹可循的，是可以模型化的，因此可以转化为单个模型单元，即可将多点关系转化为了单点关系
- 了解 CellProtocol 协议
- 了解为 TableView/CollectionView 而定制的RowCell/RowCellClass
- 了解 FormDelegateDataSource / FormDelegateDataSourceX

## 几个Form的区别
- 都基于 CellProtocol 单元格协议
- Form: 离散的 单元格组组装协议
- FormX: 集中的，组模型
- FormRx: RxSwift 支持的，组模型

## 如何构建一个单元格模型Row
```
let row = RowCell<Cell_***>()
```
示例：
```
do{// 倒计时 - 新的协议
    let row = RowCell<Cell_MineCountDown>(data: model, frame: CGRect(h:100))
    self.forms[Section.countdown.rawValue].append(row)
}
        
do{// 倒计时 点击回调didSelect 与内部事件回调 callBack
    let row = RowCell<Cell_MineCountDown>(data: model, frame: CGRect(h:100), callBack:{_ in}, didSelect:{})
    self.forms[Section.countdown.rawValue].append(row)
}
```
## 如何构建一个单元格组模型FormX
```
FormX(items: rows, header: header, footer: footer)
```
```
// 随机混排
let header = RowCell<Header_Rx>(data: "组头", config: .red, frame: CGRect(h:40))

let footer:CellProtocol = RowCell<Header_Rx>(data: "组尾", config: .gray, frame: CGRect(h:30))

let rows = (0..<100).map { (i) -> CellProtocol in
    switch Int(arc4random() % 2) {
    case 0:
        let data = RowTableViewCellBase.Model(title: "title-\(i)")
        return RowCell<RowTableViewCellBase>(data: data, frame: CGRect(h:50))
    default:
        return RowCell<Cell_Image>(data: image, frame: CGRect(h:CGFloat(60)))
    }
}

forms.append(FormX(items: rows, header: header, footer: footer))
```
## 如何构建一个支持RxSwift单元格组模型FormRx
```
FormRx(items: rows, header:header, footer: footer)
```
```
var forms = BehaviorRelay<[FormRx]>(value: (0..<Section.end.rawValue).map{ _ in FormRx(items: []) })


let header = RowCell<CollectionReusableViewHeader>(data: "组头", config: .red, frame: CGRect(x:1, y:1, h: 45), insets: UIEdgeInsets(t: 1, l: 1, b: 1, r: 1))
let footer = RowCell<CollectionReusableViewHeader>(data: "组尾", frame: CGRect(h: 45))

// 发送 CollectionView注册元素指令
output?(.register([
    .tView(CollectionReusableViewHeader.self, nil, .tHeader, nil),
    .tView(CollectionReusableViewHeader.self, nil, .tFooter, nil)
]))
            
let w = (CD.screenW-6)/4
let rows = (0..<12).map {
    RowCell<Item_Title>(data: "title-\($0)", frame: CGRect(w:w, h: 60))
}

forms.accept([FormRx(items: rows, header:header, footer: footer)])
```

## 如何应对混合排版
- 当混合排版的时候 section row height didselect 等多点关系简直就是灾难
- 而使用Row 就是如此简单
- [**示例**](#如何构建一个单元格组模型FormX)

## 如何扩展实现自定义功能
- Form *** DelegateDataSource 内已实现的 Delegate/DataSource 是普遍通用代码，当无法满足需求时，可继承 Form *** DelegateDataSource 实现
```
/// 继承 Form***DelegateDataSource / Form***DelegateDataSourceX 自行实现 左滑删除功能
class CustomListTableViewDelegateDataSource: FormTableViewDelegateDataSourceX {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // 特定状态 特定Cell 具备左滑删除
        guard form?[indexPath.section].items[indexPath.row].cellClass == Cell_Image.self else {
            return false
        }
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}

```

## 以前混乱的代码
- 以往你的TableView/CollectionView可能是如下这样的； 无论是开发、维护、修改都是灾难，section row height didselect 等必须相应维护，而且每个TableView/CollectionView都需要重复编写这些灾难性的代码

示例：
```
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == * {return *} 
        else if section == * {return *} 
        else if section == * {return *} 
        // 自动忽略几十行代码
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case **:
            switch indexPath.row {
              case **:
               return cell
               // 自动忽略几十行代码
            }
            // 自动忽略几十行代码
        }
    }
    // 自动忽略几十行代码
```
## 现在有序的代码
- 现在代码可以是这样的，不需要维护Delegate/DataSource代理，将任务交给Form***DelegateDataSource（可继承实现未完成的）
```
/// 组模型FormX
var forms:[FormDataSourceX]?
/// tableView Delegate DataSource 代理类
var proxy:FormTableViewDelegateDataSourceX?

proxy = FormTableViewDelegateDataSourceX(nil)
proxy?.makeDelegateDataSource(tableView)
    
proxy?.form = forms
```
- RxSwift
```
var forms = BehaviorRelay<[FormRx]>(value: (0..<Section.end.rawValue).map{ _ in FormRx(items: []) })

var proxy:FormRxCollectionViewDelegateDataSource?

proxy = FormRxCollectionViewDelegateDataSource(forms: forms, collectionView: collectionView)
```

- 此时 一个单元格信息 全部包含在 RowCell 模型中，无需理会 Delegate DataSource 中的代码
```
let row = RowCell<Cell_***>.init(data: "数据" config:"配置", frame: CGRect(h:45), callBack: { _ in
    /// Cell 内事件回调处理
}) {
    /// Cell 点击事件处理
}
```
```
// Form: 
forms[0] += [row]
```
```
// FormX: 
forms[0] = forms[0].append(items: rows)
```
```
// FormRx: 
forms.accept([forms.value[0]] + [self.forms.value[1].append(rows: rows)])
```

- 更多全面的示例请运行Demo查看

## Author

liucaide, 565726319@qq.com

## License

CaamDau is available under the MIT license. See the LICENSE file for more info.
