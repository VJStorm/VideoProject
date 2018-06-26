//
//  ListView.h
//  VideoProject
//
//  Created by Weijie He on 2018/6/22.
//  Copyright © 2018年 baostorm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NestModel;

@interface ListView : UIView

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NestModel* data;

-(void) initCell;

-(void) reloadData : (NestModel *)data;

-(void) laodMoreData : (NestModel *) data;

@end
