//
//  VideoModel.m
//  VideoProject
//
//  Created by Weijie He on 2018/6/22.
//  Copyright © 2018年 baostorm. All rights reserved.
//

#import "VideoModel.h"
#import <YYModel.h>
#import <AFNetworking.h>



@implementation VideoModel

@end

@implementation NestModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{@"info_list" : [VideoModel class]};
}

@end

@implementation OriginModel

@end


@implementation VModel

//请求数据，首先得到响应的json，然后用YYModel转换为响应的model
- (void) obtainData : (NSInteger) page {
    
    // 初始化AFN相关配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration: configuration];
    // 修改支持的conent-type
    AFHTTPResponseSerializer* serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/javascript", nil];
    manager.responseSerializer = serializer;
    // 初始化request
    NSString *address = [NSString stringWithFormat: @"http://mdiscover.cc.163.com/discover/waterfall_list?client=ios&page=%lu&size=15&videoid=5a0cfb2c7a2059547de69ac4", page];
    NSURL *url = [NSURL URLWithString: address];
    NSURLRequest *requst = [NSURLRequest requestWithURL: url];
    //执行请求
    NSURLSessionDataTask * dataTask = [manager dataTaskWithRequest: requst
                                                    uploadProgress: nil
                                                  downloadProgress: nil
                                                 completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                     // 响应处理
                                                     if (!error) {
                                                         // YYModel解析json成model
                                                         OriginModel *model = [OriginModel yy_modelWithJSON: responseObject];
                                                         // 回调，让代理类对model进行操作
                                                         [self.delegate modelHandler: model];
                                                     } else {
                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
    [dataTask resume];
    
}

@end
