//
//  SongList+CoreDataProperties.m
//  TadpoleMusic
//
//  Created by zhangzb on 2017/8/31.
//  Copyright © 2017年 zhangzb. All rights reserved.
//

#import "SongList+CoreDataProperties.h"

@implementation SongList (CoreDataProperties)

+ (NSFetchRequest<SongList *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SongList"];
}

@dynamic title;
@dynamic release_date;
@dynamic score;
@dynamic label;
@dynamic artist;
@dynamic album;
@dynamic status;
@dynamic attr1;
@dynamic attr2;
@dynamic attr3;
@dynamic searchTime;

@end
