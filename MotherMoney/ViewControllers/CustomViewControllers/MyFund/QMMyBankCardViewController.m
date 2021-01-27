   //
//  QMMyBankCardViewController.m
//  MotherMoney
//
//  Created by 赵国辉 on 15/6/22.
//  Copyright (c) 2015年 赵国辉. All rights reserved.
//

#import "QMMyBankCardViewController.h"
#import "QMBankCardModel.h"
#import "QMSelectBankViewControllerV2.h"
#import "QMBankInfoCell.h"
#import "QMBankCardModel.h"
#import "QMAddBankCardViewControllerV2.h"
#import "QMIdentityAuthenticationViewController.h"

#define QMSINGLELINECOLLECTIONCELLIDENTIFIER2 @"QMSINGLELINECOLLECTIONCELLIDENTIFIER"

@interface QMMyBankCardViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, QMSelectBankViewControllerV2Delegate>

@end

@implementation QMMyBankCardViewController {
    UICollectionView *myCollectionView;
    QMBankCardModel *cardModel;
    NSArray *cardModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    [self setUpCollectionView];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    // 获取银行卡信息
    [[NetServiceManager sharedInstance] getBankCardListByChannelId:@"2" delegate:self success:^(id responseObject) {
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return;
        }
        
        NSArray *cardList = [responseObject objectForKey:kNetWorkList];
        cardModelArray = [QMBankCardModel getArrayModel:cardList];
        [myCollectionView reloadData];
        
    } failure:^(NSError *error) {
        [CMMUtility showNoteWithError:error];
    }];
}

- (void)setUpCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    
    myCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    myCollectionView.alwaysBounceVertical = YES;
    [myCollectionView registerClass:[QMBankInfoCell class] forCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER2];
    
    myCollectionView.backgroundColor = QM_COMMON_BACKGROUND_COLOR;
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [self.view addSubview:myCollectionView];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QMBankInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QMSINGLELINECOLLECTIONCELLIDENTIFIER2 forIndexPath:indexPath];
    cell.withDraw = YES;
    
    [cell.actionBtn addTarget:self action:@selector(gotoAddBankCardViewController) forControlEvents:UIControlEventTouchUpInside];
    QMBankCardModel *model;
//    [cell configureCellWithBankCardModel:model];
    
    if (indexPath.row < [cardModelArray count])
    {
        model = [cardModelArray objectAtIndex:indexPath.row];
        [cell configureCellWithBankCardModel:model];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor grayColor];
        [cell addSubview:line];
    }else
    {
        [cell configureCellWithBankCardModel:nil];
    }
    
    cell.mPromptLabel.text = @"我的银行卡";
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([cardModelArray count] < 3)
    {
        return [cardModelArray count] + 1;
    }else
    {
        return [cardModelArray count];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [cardModelArray count] && indexPath.section == 0) {
        QMBankCardModel *model = [cardModelArray objectAtIndex:indexPath.row];
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, [QMBankInfoCell getCellHeightWithBankCardModel:model]);
    }
    
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, 44);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 0, 8);
}

- (void)onBack {
    if (self.isModel) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (UIBarButtonItem *)leftBarButtonItem {
    if (self.isModel) {
        return [QMNavigationBarItemFactory createNavigationBackItemWithTarget:self selector:@selector(onBack)];
    }
    
    return nil;
}

- (void)gotoAddBankCardViewController {
    QMIdentityAuthenticationViewController *con = [[QMIdentityAuthenticationViewController alloc] init];
    con.isModel = YES;
    QMAccountInfo *info = [[QMAccountUtil sharedInstance] currentAccount];
    con.isModel = YES;
    con.userIdCard = info.identifierCardId;
    con.userRealName = info.realName;
    con.haveDefaultMessage = YES;
    QMNavigationController *nav = [[QMNavigationController alloc] initWithRootViewController:con];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


- (void)selectBankViewController:(QMSelectBankViewControllerV2 *)con didSelectBank:(QMBankCardModel *)model {
    cardModel = model;
    [myCollectionView reloadData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectBankViewControllerDidCancel:(QMSelectBankViewControllerV2 *)con {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)title {
    return @"我的银行卡";
}

@end


