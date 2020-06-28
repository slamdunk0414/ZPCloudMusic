//
//  SelectLyricController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/28.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class SelectLyricController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var ivLyric: UIButton!
    
    @IBOutlet weak var ivBackground: UIImageView!
    
    /// 歌曲
    var song:Song!
    
    /// 歌词
    var lyric:Lyric!
    
    override func initViews() {
        super.initViews()
        setTitle("选择歌词")
        
        ivLyric.setRaduis(15)
        ivLyric.showColorPrimaryBorder()

        tableView.register(UINib(nibName: SelectLyricCell.NAME, bundle: nil), forCellReuseIdentifier: SelectLyricCell.NAME)
    }
    
    override func initDatas() {
        super.initDatas()
        
        //显示背景图片
        ImageUtil.show(ivBackground, song.banner)
    }
    
    @IBAction func onClickLyricImage(_ sender: Any) {
        
        //获取选中的歌词
        let lyricString = getSelectLyricString("\n")
        
        if lyricString.isEmpty {
            ToastUtil.short("请选择歌词！")
            return
        }
        
        print("SelectLyricController onShareLyricImageClick:\(lyricString)")
        
        ShareLyricImageController.start(navigationController!, song, lyricString)
        
    }
    
    /// 获取选择的歌词
    func getSelectLyricString(_ separator:String) -> String {
        var lyricStringArray:[String] = []
        
        //获取选中的歌词索引
        var indexPaths = tableView.indexPathsForSelectedRows
        
        if indexPaths == nil {
            return ""
        }
        
        //排序
        //由于该方法获取的indexPath是选择顺序
        //而我们需要的是列表顺序
        //所以按照row从小到大排序
        indexPaths = indexPaths!.sorted { (obj1, obj2) -> Bool in
            return obj1.row<obj2.row
        }
        
        //遍历
        for indexPath in indexPaths! {
            let line = lyric.datas[indexPath.row]
            
            //把歌词添加到数组中
            lyricStringArray.append(line.data)
        }
        
        //将字符串使用分隔符连接
        return lyricStringArray.joined(separator: separator)
    }
    
    /// 界面即将显示
    ///
    /// - Parameter animated: <#animated description#>
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //设置标题栏为亮色
        setTitleBarLight()
    }
    
    /// 界面即将消失
    ///
    /// - Parameter animated: <#animated description#>
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //设置标题栏为暗色
        setTitleBarDefault()
    }
}

// MARK: - 启动界面
extension SelectLyricController {
    
    /// 启动界面
    static func start(_ navigationController:UINavigationController,_ song:Song,_ lyric:Lyric) {
        //创建控制器
        let controller = SelectLyricController()
        
        //传递数据
        controller.song = song
        controller.lyric = lyric
        
        navigationController.pushViewController(controller, animated: false)
        
    }
}

// MARK: - 列表数据源和代理
extension SelectLyricController:UITableViewDataSource,UITableViewDelegate {
    
    /// 有多少个
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyric.datas.count
    }
    
    /// 返回当前位置的Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //获取Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectLyricCell.NAME, for: indexPath) as! SelectLyricCell
        
        //绑定数据
        cell.bindData(lyric.datas[indexPath.row])
        
        return cell
    }
    
    
}
