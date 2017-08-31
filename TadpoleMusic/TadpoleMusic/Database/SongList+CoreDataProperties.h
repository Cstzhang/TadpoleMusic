//
//  SongList+CoreDataProperties.h
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/31.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SongList+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SongList (CoreDataProperties)

+ (NSFetchRequest<SongList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *release_date;
@property (nonatomic) double score;
@property (nullable, nonatomic, copy) NSString *label;
@property (nullable, nonatomic, copy) NSString *artist;
@property (nullable, nonatomic, copy) NSString *album;
@property (nonatomic) int16_t status;
@property (nullable, nonatomic, copy) NSString *attr1;
@property (nullable, nonatomic, copy) NSString *attr2;
@property (nullable, nonatomic, copy) NSString *attr3;
@property (nullable, nonatomic, copy) NSDate *searchTime;

@end

NS_ASSUME_NONNULL_END
