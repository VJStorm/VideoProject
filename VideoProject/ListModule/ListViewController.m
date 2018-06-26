//
//  ListViewController.m
//  VideoProject
//
//  Created by Weijie He on 2018/6/22.
//  Copyright © 2018年 baostorm. All rights reserved.
//

#import "ListViewController.h"
#import "ListView.h"
#import "VideoModel.h"
#import "PlayerViewController.h"
#import <MJRefresh.h>

@interface ListViewController () <ModelDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) VModel* vModel;
@property (nonatomic, strong) ListView *listView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) NSInteger requestPage;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listView = [[ListView alloc] initWithFrame: CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    // 设置navigationbar
    self.title = @"视频列表";
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self initListView];
    /// 设置下拉刷新， 使用UIKit原生控件UIRefreshControl
//    self.refreshControl = [[UIRefreshControl alloc] init];
//    self.refreshControl.tintColor = [UIColor blackColor];
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
//    [self.refreshControl addTarget:self
//                            action:@selector(handleRefreshOrLoadMore)
//                  forControlEvents:UIControlEventValueChanged];
    
    
//    self.listView.collectionView.refreshControl = self.refreshControl;
    
    /// 设置下拉刷新， 使用MJRefresh
    self.listView.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 下拉刷新
        self.requestPage = 1;
        [self handleRefreshOrLoadMore];
        [self.listView.collectionView.mj_footer resetNoMoreData];
    }];
    self.listView.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多, 如果end为1则说明没有更多了
        if (!self.listView.data.end) {
            self.requestPage ++;
            [self handleRefreshOrLoadMore];
        } else {
            [self.listView.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    
    self.vModel = [[VModel alloc] init];
    self.vModel.delegate = self;
    // 请求数据
    self.requestPage = 1;
    [self.vModel obtainData : self.requestPage];
}

// 初始化展示列表
-(void) initListView{
    
    [self.listView initCell];
    // 被委托实现代理
    self.listView.collectionView.delegate = self;
    [self.view addSubview: self.listView];
    
}

-(void) handleRefreshOrLoadMore{
    [self.vModel obtainData : self.requestPage];
}

#pragma mark -- 实现ModelDelegate协议
// 请求完成之后，对model数据进行展示
-(void) modelHandler: (OriginModel *) originModel {
    
    NSLog(@"%@", originModel.reason);
    // 结束刷新
    if ([self.listView.collectionView.mj_footer isRefreshing]) {
        [self.listView.collectionView.mj_footer endRefreshing];
    }
    if ([self.listView.collectionView.mj_header isRefreshing]) {
        [self.listView.collectionView.mj_header endRefreshing];
    }
    
    if (self.requestPage == 1) {
        [self.listView reloadData: originModel.data];
    } else {
        [self.listView laodMoreData: originModel.data];
    }
    
}

#pragma  mark -- 实现委托协议, 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了%lu", indexPath.section);
    PlayerViewController * player = [[PlayerViewController alloc] init];
    VideoModel *video = self.listView.data.info_list[indexPath.section];
    player.urlString = video.flv;
    player.coverUrlString = video.cover;
    [self.navigationController pushViewController:player animated:YES];
}


@end
