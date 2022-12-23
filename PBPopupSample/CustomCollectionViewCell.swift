//
//  CustomCollectionViewCell.swift
//  PBPopupSample
//
//  Created by Oleksandr Balabon on 22.12.2022.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.lightGray
        imageView.tintColor = UIColor.darkGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func initialize() {
        self.addSubview(imageView)
        self.addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.bottom).offset(-5)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
}

extension CustomCollectionViewCell {
    
    func setupTextLabel(labelText: String) {
        label.text = labelText.truncate(14)
    }
}

extension String {
    func truncate(_ length: Int, trailing: String = "…") -> String {
        (self.count > length) ? self.prefix(max(0, length - trailing.count)) + trailing : self
    }
}
