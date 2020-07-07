//Created  on 2020/7/7 by  LCD:https://github.com/liucaide .

/***** 模块文档 *****
 *
 */




import UIKit
import CaamDauForm

class Header_Rx: UITableViewHeaderFooterView {
    @IBOutlet weak var view_bg: UIView!
    @IBOutlet weak var lab_title: UILabel!
}

extension Header_Rx: RowCellUpdateProtocol {
    typealias ConfigModel = UIColor
    
    typealias DataSource = String
    func row_update(config data: UIColor) {
        view_bg.cd.background(data)
    }
    func row_update(dataSource data: DataSource) {
        lab_title.cd.text(data)
    }
    
    
}




class Cell_Image: UITableViewCell {

    @IBOutlet weak var lab_title: UILabel!
    @IBOutlet weak var lab_time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
}

extension Cell_Image: RowCellUpdateProtocol {
    typealias ConfigModel = Any
    
    typealias DataSource = (String, String)
    
    func row_update(dataSource data: DataSource) {
        lab_title.cd.text(data.0)
        lab_time.cd.text(data.1)
    }
    
    
}
