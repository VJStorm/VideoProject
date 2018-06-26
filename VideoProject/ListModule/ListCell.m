//
//  ListCell.m
//  VideoProject
//
//  Created by Weijie He on 2018/6/22.
//  Copyright © 2018年 baostorm. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        // 单元格长度，满屏
        CGFloat cellWidth = self.frame.size.width;
        
        ///添加图片
        CGFloat imageViewWidth = cellWidth - 20;
        CGFloat imageViewHeight = imageViewWidth*9/16;
        CGFloat imageViewTopView = 10;
        self.cover = [[UIImageView alloc] initWithFrame: CGRectMake((cellWidth - imageViewWidth)/2,
                                                                    imageViewTopView,
                                                                    imageViewWidth,
                                                                    imageViewHeight)];
        [self addSubview: self.cover];
        
        ///添加标签
        CGFloat labelWidth = cellWidth - 20;
        CGFloat labelHeight = 16;
        
        self.title = [[UILabel alloc] initWithFrame: CGRectMake((cellWidth - imageViewWidth)/2,
                                                                imageViewTopView + imageViewHeight +5,
                                                                labelWidth,
                                                                labelHeight)];
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont systemFontOfSize: 16];
        self.title.textColor = [UIColor blackColor];
        [self addSubview: self.title];
        
    }
    
    return self;
}

@end
