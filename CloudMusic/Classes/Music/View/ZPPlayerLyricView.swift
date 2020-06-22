//
//  ZPPlayerLyricView.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/6/22.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class ZPPlayerLyricView: UIView ,NibLoadable{
    
    ///选中的当前行
    var lineNumber:Int?{
        didSet{
            
            print("设置了\(lineNumber)")
            
            let indexPaht = IndexPath(item: lineNumber ?? 0, section: 0)
             tableView.selectRow(at: indexPaht, animated: true, scrollPosition: .middle)
            
        }
    }
    
    ///是不是用于在拖拽
    var isUserMoving = false
    
    ///由控制器传来的进度
    var progress:Float = 0{
        didSet{
            if dataArray.count == 0 {
                return
            }
            
            if isUserMoving {
                return
            }
            
            //获取当前时间对应的歌词索引
            let newLineNumber = LyricUtil.getLineNumber(lyric!, progress)
            
            if newLineNumber != lineNumber {
                
                lineNumber = newLineNumber
            }
        }
    }
    
    /// 滚动到当前歌词行
    ///
    /// - Parameter position: <#position description#>
    func scrollLyricPosition(_ position:Int) {
       let indexPaht = IndexPath(item: position, section: 0)
        tableView.selectRow(at: indexPaht, animated: true, scrollPosition: .middle)
    }
    
    ///设置歌词的本地地址
    var lrcUrl:String?{
        didSet{
            
            if let lrcUrl = lrcUrl{
                
                let path = Bundle.main.path(forResource: lrcUrl, ofType: "lrc")
                let lrcString = try! String(contentsOfFile: path!, encoding: .utf8)
                let lyric = LyricParser.parse(.lrc, lrcString)
                self.lyric = lyric
                
                dataArray = lyric.datas
                
            }else{
                
                lyric = nil
                dataArray = []
                
            }
        }
    }
    
    ///歌词对象
    var lyric:Lyric?
    
    ///单个歌词的数组
    var dataArray:[LyricLine] = [] {
        didSet{
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scrollToControlView: UIStackView!
    
    @IBOutlet weak var dragStartTime: UILabel!
    
    /// 延迟滚动歌词异步任务
    var task:DispatchWorkItem?
    
    /// 当前歌词拖拽位置的歌词
    var scrollSelectedLyricLine:LyricLine?
    
    override func awakeFromNib() {
        print("awakeFromNib")
        tableView.register(UINib(nibName: "ZPPlayerLyricLineCell", bundle: nil), forCellReuseIdentifier: "ZPPlayerLyricLineCell")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        scrollToControlView.isHidden = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("layoutSubviews")
        
        if tableView.contentInset == UIEdgeInsets.zero {
            tableView.contentInset = UIEdgeInsets(top: height/2.0 - 22, left: 0, bottom: height/2.0 - 22, right: 0)
            tableView.setContentOffset(CGPoint(x: 0, y: -tableView.contentInset.top), animated: false)
        }
    }
    
    
    var onClickDragPlayBlock:((_ progress:CGFloat)->Void)?
    
    @IBAction func onClickDragPlay(_ sender: Any) {
        
        if let line = scrollSelectedLyricLine{
            
            //将开始时间转为秒
            let floatTime = Float(line.startTime) + 50

            let startTime = floatTime / 1000
            
            print("点击的跳转时间是\(floatTime)")
            
            //从当前位置开始播放
            PlayListManager.shared().seekTo(startTime)
            
            let arr = dataArray as NSArray
            let index = arr.index(of: line)
            
            self.lineNumber = index

            //马上滚动歌词
            enableScrollLyric()
        }
    }
    
}

extension ZPPlayerLyricView:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZPPlayerLyricLineCell", for: indexPath) as! ZPPlayerLyricLineCell
        
        let line = dataArray[indexPath.row]
        
        cell.bindData(line)
        cell.tag = indexPath.row
        
        return cell
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let contentY = scrollView.contentOffset.y
        
        let index = tableView.indexPathForRow(at: CGPoint(x: 0, y: contentY + tableView.contentInset.top))
        
        if let row = index?.row , row >= 0 , row < dataArray.count{
             let line = dataArray[row]
            
             //真实歌词数据
             //保存到一个字段上
             scrollSelectedLyricLine = line
             
             //将开始时间转为秒
             let startTime = Float( scrollSelectedLyricLine!.startTime / 1000)
             
             //格式化开始时间
             dragStartTime.text = TimeUtil.second2MinuteAndSecond(startTime)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserMoving = true
        
        scrollToControlView.isHidden = false
        print("将isusermoving设置为true")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        ///倒计时开启滚动歌词
        prepareScrollLyricView()

    }
    
    /// 倒计时开启滚动歌词
    func prepareScrollLyricView() {
        cancelTask()
        
        task = DispatchWorkItem {
            self.enableScrollLyric()
        }
        
        //创建一个延迟任务
        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: task!)
    }
    
    func enableScrollLyric(){
        print("延迟将isusermoving设置为false")
        self.isUserMoving = false
        self.scrollToControlView.isHidden = true
        let lineNumber = self.lineNumber
        self.lineNumber = lineNumber
    }
    
    /// 取消倒计时开启滚动歌词延迟
    func cancelTask() {
        if let task = task {
            task.cancel()
            self.task=nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
        
    }
    
}
