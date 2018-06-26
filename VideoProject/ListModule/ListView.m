//
//  ListView.m
//  VideoProject
//
//  Created by Weijie He on 2018/6/22.
//  Copyright © 2018年 baostorm. All rights reserved.
//

#import "ListView.h"
#import "ListCell.h"
#import "VideoModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ListView () <UICollectionViewDataSource>

@end

@implementation ListView

-(void) initCell{
    
    NSInteger cellWidth = [[UIScreen mainScreen] bounds].size.width-20;
    
    // 创建一个流式布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置cell的宽高
    layout.itemSize = CGSizeMake(cellWidth, cellWidth*9/16+10);
    // 设置单元格的行间距
    layout.minimumLineSpacing = 10;
    
    // 设置整个collectionview的内边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // 初始化collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    
    // 设置可重用单元格标识与单元格类型
    [self.collectionView registerClass: ListCell.class
            forCellWithReuseIdentifier: @"listCell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // 自己实现数据源协议
    self.collectionView.dataSource = self;
    
    [self addSubview: self.collectionView];
    
}

// 刷新数据
-(void) reloadData : (NestModel *)data {
    self.data = data;
    [self.collectionView reloadData];
}

// 添加更多数据
-(void) laodMoreData : (NestModel *) data {
    [self.data.info_list addObjectsFromArray: data.info_list];
    self.data.end = data.end;
    [self.collectionView reloadData];
}

#pragma mark -- 实现数据源协议
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.data.info_list count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath: indexPath];
    
    VideoModel *model = self.data.info_list[indexPath.section];
    
    cell.title.text = model.title;
    [cell.cover sd_setImageWithURL: [NSURL URLWithString: model.cover]];
    
    return cell;
}


@end
