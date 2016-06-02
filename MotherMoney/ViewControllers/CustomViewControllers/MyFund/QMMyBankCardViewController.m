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

#define QMSINGLELINECOLLECTIONCELLIDENTIFIER2 @"QMSINGLELINECOLLECTIONCELLIDENTIFIER"

@interface QMMyBankCardViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, QMSelectBankViewControllerV2Delegate>

@end

@implementation QMMyBankCardViewController {
    UICollectionView *myCollectionView;
    QMBankCardModel *cardModel;
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
        if (cardList && [cardList isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in cardList) {
                QMBankCardModel *model = [[QMBankCardModel alloc] initWithDictionary:dict];
                
                cardModel = model;
                break;
            }
            
            [myCollectionView reloadData];
        }
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
    [cell configureCellWithBankCardModel:cardModel];
    
    cell.mPromptLabel.text = @"我的充值提现银行卡";
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame) - 2 * 8, [QMBankInfoCell getCellHeightWithBankCardModel:cardModel]);
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
    QMAddBankCardViewControllerV2 *con = [[QMAddBankCardViewControllerV2 alloc] init];
    con.isModel = YES;
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


