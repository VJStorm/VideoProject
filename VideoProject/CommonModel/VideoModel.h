//
//  VideoModel.h
//  VideoProject
//
//  Created by Weijie He on 2018/6/22.
//  Copyright © 2018年 baostorm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic, strong) NSString *flv;
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *duration;

@end // end VideoModel


@interface NestModel : NSObject

@property (nonatomic) BOOL end;
@property (nonatomic) NSMutableArray *info_list; //Array<VideoModel>

@end // end NestModel


@interface OriginModel: NSObject

@property (nonatomic, strong) NSString *reason; // Success则为成功获取数据
@property (nonatomic, strong) NestModel *data;

@end // end OriginModel

@protocol ModelDelegate

-(void) modelHandler: (OriginModel *) originModel;

@end

//这是用于和后台进行交互的类
@interface VModel : NSObject

@property id<ModelDelegate> delegate;

-(void) obtainData : (NSInteger) page;

@end
