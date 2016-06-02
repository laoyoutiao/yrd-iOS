//
//  QMOpenChannelAccoutViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/1/3.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMOpenChannelAccoutViewController.h"

@interface QMOpenChannelAccoutViewController ()

@end

@implementation QMOpenChannelAccoutViewController {
    NSString *channelAccountId;
    UILabel *promptLabel;
    
    UIImageView *iconImageView;
}

- (id)initViewControllerWithChannelId:(NSString *)channelId {
    if (self = [super init]) {
        channelAccountId = channelId;
    }
    
    return self;
}

- (void)onBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    
    iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_iphne120.png"]];
    iconImageView.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 60.0f) / 2.0f, 40.0f, 60, 60);
    [self.view addSubview:iconImageView];
    
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(iconImageView.frame) + 40, CGRectGetWidth(self.view.frame) - 2 * 15, 36)];
    promptLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    promptLabel.textAlignment = NSTextAlignmentLeft;
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.numberOfLines = 2;
    promptLabel.text = QMLocalizedString(@"qm_open_channel_account_prompt_text", @"只有开通渠道账户才能进行理财");
    [self.view addSubview:promptLabel];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIButton *btn = [QMControlFactory commonButtonWithSize:CGSizeMake(width - 2 * 15, 40) title:QMLocalizedString(@"qm_open_channel_account_nav_title", @"开通渠道账户") target:self selector:@selector(openChannelAccount)];
    CGRect frame = btn.frame;
    frame.origin.x = 15;
    frame.origin.y = CGRectGetMaxY(promptLabel.frame) + 30;
    btn.frame = frame;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)openChannelAccount {
    [[NetServiceManager sharedInstance] openProductAccountWithProductChannelId:channelAccountId
                                                                      delegate:self
                                                                       success:^(id responseObject) {
                                                                           if (QM_IS_DELEGATE_RSP_SEL(self.delegate, channelAccountDidOpenSuccess:)) {
                                                                               [self.delegate channelAccountDidOpenSuccess:self];
                                                                           }
                                                                       } failure:^(NSError *error) {
                                                                           [CMMUtility showNoteWithError:error];
                                                                       }];
}

- (UIBarButtonItem *)leftBarButtonItem {
    return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
}

#pragma mark -
#pragma mark Override
- (NSString *)title {
    return QMLocalizedString(@"qm_open_channel_account_nav_title", @"开通渠道账户");
}

@end

