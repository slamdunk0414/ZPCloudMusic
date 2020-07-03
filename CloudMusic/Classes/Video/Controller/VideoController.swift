//
//  VideoController.swift
//  CloudMusic
//
//  Created by 张鹏 on 2020/7/2.
//  Copyright © 2020 张鹏. All rights reserved.
//

import UIKit

class VideoController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataArray:[VideoDetailModel] = []
    
    override func initViews() {
        setTitle("视频")
        
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
    }
    
    override func initDatas(){
        
        super.initDatas()
        
        ///初始化一些数据 用于调试
        let video = VideoDetailModel()
        video.cover = "http://cdnmusic.migu.cn/picture/2020/0612/0000/AL977e777d850e857ef41d7a457021e6c9.jpg"
        video.title = "mojito - 周杰伦"
        video.uri = "http://freevod.nf.migu.cn/DnstR1OsvHd%2BB1UAd1SOtRsMggTIwdiqF7DKuBqSZ3JMYGqenVv0wCPcCtOcGGTBq95W223dOYAH6FF7xz2vlh4iiom9cVVhiHtOQ6EyVCXeSIZLHzMqZDgduQ0KTp7fkTvl9hL81MelDTrh7a%2Fndz4fuGtsoApGNTYe6PqMydZ%2FGMCEAt%2FC1FmGcR3zPCVm/600547Y0013223305.mp4"
        
        dataArray.append(video)

       ///初始化一些数据 用于调试
       let video2 = VideoDetailModel()
       video2.cover = "http://cdnmusic.migu.cn/picture/2019/1031/0318/AL5be7234d71474feca10d2d89ccb4ccc2.jpg"
       video2.title = "等你下课 - 周杰伦"
       video2.uri = "http://freevod.nf.migu.cn/qkQ1gP8TlUI4gkkDZierNCx0q6VdMRJBuijmyvtx8xnd71kh3McZICg3WdC8FFXN2EiYHSkU9PyV309ntWfe9p8gtv89PNmWisJ5P8hDY7rBxZ+dqRBjOv0gjlO7efIKP+AgJDRExML9jwd3atfh8E79dUx8Xv52yPvQs/CEjhvj/2FbI/Mh94tdwCUPvEJJ8qphOOcCF2HL2Wgr6Ez0rw==/600547Y0001.mp4"
       
       dataArray.append(video2)
        
       ///初始化一些数据 用于调试
       let video3 = VideoDetailModel()
       video3.cover = "http://cdnmusic.migu.cn/picture/2019/0514/0907/AL1609221042206684.jpg"
       video3.title = "突然好想你 - 五月天"
       video3.uri = "http://freevod.nf.migu.cn/VcPZQ1HUH34MG8rHQePf64sVvUjlZ6+pRtg/bt6nqZhMrZzltt0WzKQG+t0n0lQ1J/JwtiVmFaD0jB26ugZDkLsuP+vZOe2Tp7onj+NV42ywpHPIqMdKvzMZsnQFkoU7E9sYY6r0dzrtj66aGDulmPO9M83WGzyS8rGKxPcHRfL6ft959MDkIHicnJMrenR3vMJSn5mS5VuLOxCcqzjPUQ==/699119Y9193.mp4"
       
       dataArray.append(video3)
    
       tableView.reloadData()
    
       ///初始化一些数据 用于调试
       let video4 = VideoDetailModel()
       video4.cover = "https://p2.music.126.net/tlAuA-N6s8rQwd49apZqKg==/109951165069075704.jpg"
       video4.title = "Billie Jean - Michael Jackson"
       video4.uri = "http://vodkgeyttp8.vod.126.net/cloudmusic/NTEzMDMzMTE=/058bff39ef94654be617fc47a707cb3c/988bef6cfda908c2fac4857b0d333caf.mp4"
       
       dataArray.append(video4)
    
       tableView.reloadData()
    }

}

extension VideoController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as! VideoCell
        cell.model = dataArray[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = VideoDetailController()
        controller.videoModel = dataArray[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
