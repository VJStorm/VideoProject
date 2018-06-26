//
//  PlayerViewController.m
//  VideoProject
//
//  Created by Weijie He on 2018/6/22.
//  Copyright © 2018年 baostorm. All rights reserved.
//

#import "PlayerViewController.h"
#import <ZFPlayer.h>
#import <ZFAVPlayerManager.h>
#import <ZFPlayerControlView.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PlayerViewController ()

@property (nonatomic, strong) ZFPlayerController *player;
/// 初始化时传递的容器视图，用来显示播放器view，和播放器view同等大小
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIImageView *cover;

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.cover];
    [self.containerView addSubview:self.playBtn];
    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.player.isFullScreen) {
            [self.player enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stop];
            });
        } else {
            [self.player stop];
        }
    };
    
    //把flv替换成mp4
    self.urlString = [self.urlString stringByReplacingOccurrencesOfString: @".flv" withString: @".mp4" ];
    
    self.player.assetURLs = @[[NSURL URLWithString: self.urlString]]; //如果是assetURL的话会直接播放，不受playFromIndex控制
}

// 绘制子view
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat x = 0;
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = w*9/16;
    self.containerView.frame = CGRectMake(x, y, w, h);
    
    self.cover.frame = CGRectMake(0, 0, w, h);
    
    w = 44;
    h = w;
    x = (CGRectGetWidth(self.containerView.frame)-w)/2;
    y = (CGRectGetHeight(self.containerView.frame)-h)/2;
    self.playBtn.frame = CGRectMake(x, y, w, h);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playClick:(UIButton *)sender {
    [self.player playTheIndex:0];
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
}

- (UIImageView *) cover {
    if (!_cover) {
        _cover = [[UIImageView alloc] init];
        [_cover sd_setImageWithURL: [NSURL URLWithString: self.coverUrlString]];
    }
    return _cover;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage: [UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    /// the keyborad support orientations
    return UIInterfaceOrientationMaskPortrait;
}

//全屏的时候设置状态栏文字颜色为白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL) shouldAutorotate
{
    return NO;
}

@end
