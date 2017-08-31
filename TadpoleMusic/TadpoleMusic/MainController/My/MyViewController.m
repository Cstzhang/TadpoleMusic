//
//  MyViewController.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/4.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "MyViewController.h"
#import "CircleRippleView.h"

@interface MyViewController ()
/** <#注释#> */
@property (nonatomic,strong) CircleRippleView * rippleView;
/** <#注释#> */
@property (nonatomic,strong) AppDelegate * appDelegate;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"我的"];
    ///拿到appDelegate
    _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ///创建增删改查按钮
    [self createBtns];
    
}

-(void)createBtns
{
    NSArray *butsNameArray = @[@"增",@"删",@"改",@"查"];
    int butW = 50;
    for (int i = 0; i < butsNameArray.count; i++) {
        ///btn name
        NSString * btnName = butsNameArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * butW + 10 * i, 200, butW, butW);
        button.backgroundColor = [UIColor blueColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitle:btnName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(clickBtnAction:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000 + i;
        [self.view addSubview:button];
    }
}

-(void)clickBtnAction:(UIButton *)btn
{
    NSInteger tag = btn.tag - 1000;
    switch (tag) {
        case 0:
           // [self addAction];       ///增
            break;
        case 1:
           // [self deleteAction];    ///删
            break;
        case 2:
            //[self updateAction];    ///改
            break;
        case 3:
            //[self selectAtion];     ///查
             break;
        default:
            break;
    }
    
}

/////增
//-(void)addAction
//{
//    ///此代码等价于 ==  类的 alloc init
//    Student *stu = [NSEntityDescription insertNewObjectForEntityForName:@"Student"
//                                                 inManagedObjectContext:_appDelegate.persistentContainer.viewContext];
//    
//    ///赋值
//    stu.name = [NSString stringWithFormat:@"学生%d",arc4random()%10];
//    stu.sex = arc4random()%2 == 0 ? YES:NO;
//    stu.age = arc4random()%15;
//    
//    ///打印
//    NSLog(@"增加了一个学生 名字是:%@ 性别是:%@ 年龄是:%hd",stu.name,stu.sex == YES ? @"男":@"女",stu.age);
//    
//    [appDelegate saveContext];
//    
//}
//
/////查
//-(void)selectAtion
//{
//    ///先读取这个类 这里有点像字典里面根据 key 查找 value 的意思
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
//                                              inManagedObjectContext:appDelegate.persistentContainer.viewContext];
//    ///创建查询请求
//    NSFetchRequest *request = [[NSFetchRequest alloc]init];
//    ///设置查询请求的 实体
//    [request setEntity:entity];
//    ///获取查询的结果
//    NSArray *resultArray = [appDelegate.persistentContainer.viewContext executeFetchRequest:request
//                                                                                      error:nil];
//    ///打印查询结果
//    for (Student *stu in resultArray) {
//        NSLog(@"查询到一个学生 名字是:%@ 性别是:%@ 年龄是:%hd",stu.name,stu.sex == YES ? @"男":@"女",stu.age);
//    }
//    
//}
//
/////删
//-(void)deleteAction
//{
//    ///读取所有学生的实体
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
//                                              inManagedObjectContext:appDelegate.persistentContainer.viewContext];
//    ///创建请求
//    NSFetchRequest *request = [[NSFetchRequest alloc]init];
//    [request setEntity:entity];
//    
//    ///创建条件 年龄 = 10 的学生
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age=10"];
//    [request setPredicate:predicate];
//    
//    ///获取符合条件的结果
//    NSArray *resultArray = [appDelegate.persistentContainer.viewContext executeFetchRequest:request
//                                                                                      error:nil];
//    if (resultArray.count>0) {
//        for (Student *stu in resultArray) {
//            ///删除实体
//            [appDelegate.persistentContainer.viewContext deleteObject:stu];
//        }
//        ///保存结果并且打印
//        [appDelegate saveContext];
//        NSLog(@"删除年龄为10的学生完成");
//    }else{
//        NSLog(@"没有符合条件的结果");
//    }
//    
//}
//
//
/////改
//-(void)updateAction
//{
//    ///读取所有学生的实体
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student"
//                                              inManagedObjectContext:appDelegate.persistentContainer.viewContext];
//    ///创建请求
//    NSFetchRequest *request = [[NSFetchRequest alloc]init];
//    [request setEntity:entity];
//    
//    ///创建条件 年龄 < 10 的学生
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"age<10"];
//    [request setPredicate:predicate];
//    
//    ///获取符合条件的结果
//    NSArray *resultArray = [appDelegate.persistentContainer.viewContext executeFetchRequest:request
//                                                                                      error:nil];
//    if (resultArray.count>0) {
//        for (Student *stu in resultArray) {
//            ///把年龄 + 10岁
//            stu.age = stu.age + 10;
//            ///并且把名字添加一个修
//            stu.name = [NSString stringWithFormat:@"%@修",stu.name];
//        }
//        ///保存结果并且打印
//        [appDelegate saveContext];
//        NSLog(@"修改学生信息完成");
//    }else{
//        NSLog(@"没有符合条件的结果");
//    }
//}
//



@end
