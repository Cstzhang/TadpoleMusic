//
//  HummingListController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/28.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "HummingListController.h"
#import "HummingModel.h"
#import "HummingSongViewCell.h"

@interface HummingListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *firstSongBackView;
@property (weak, nonatomic) IBOutlet UIImageView *songImage;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (weak, nonatomic) IBOutlet UITableView *hummingSongTabelView;

@end

@implementation HummingListController
#pragma mark - **************** UI初始化
-(void)setBaseUI{
    //nav
    [self.navigationItem setTitle:@"识别列表"];
    [self.view setBackgroundColor:[UIColor yellowColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:TITLE_FONT,NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSLog(@"humming data %@",self.hummingArray);
   
 
   
    //tableview
    [self.hummingSongTabelView registerNib:[UINib nibWithNibName:@"HummingSongViewCell" bundle:nil] forCellReuseIdentifier:@"HummingSongViewCell"];
    self.hummingSongTabelView.delegate = self;
    self.hummingSongTabelView.dataSource = self;
  
    if (self.hummingArray.count!=0) {
        HummingModel *model = self.hummingArray[0];
         //firt view
        self.songName.text = model.title;
        self.albumLabel.text = [NSString stringWithFormat:@"《%@》",model.album];
        self.artistLabel.text = [NSString stringWithFormat:@"作者：%@",model.artist];
        self.scoreLabel.text = [NSString stringWithFormat:@"识别度：%@",model.score];
        
       
         [self.hummingSongTabelView reloadData];
    }
    
}

#pragma mark - **************** 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBaseUI];
}



#pragma tableView--delegate
#pragma tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.hummingArray.count-1;
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HummingSongViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HummingSongViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HummingSongViewCell" owner:nil options:nil][0];
    }
    if (self.hummingArray.count!=0) {
        HummingModel *model = self.hummingArray[indexPath.row+1];
        cell.songNameLabel.text = model.title;
        cell.albumLabel.text = [NSString stringWithFormat:@"《%@》",model.album];
        cell.artistLabel.text = [NSString stringWithFormat:@"作者：%@",model.artist];
        cell.scoreLabel.text = [NSString stringWithFormat:@"识别度：%@",model.score];
    }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
