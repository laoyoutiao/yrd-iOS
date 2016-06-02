//
//  QMGoodsListItemCell.m
//  MotherMoney
//

#import "QMGoodsListItemCell.h"

@implementation QMGoodsListItemCell {
    UILabel *goodNameLabel;
    UILabel *goodDetailLabel;
    UIButton *mExchangeGoodBtn;
    UIImageView* imageIcon;
    NSMutableAttributedString* goodDetailTitle;
}
@synthesize exchangeGoodBtn = mExchangeGoodBtn;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:[QMImageFactory commonBackgroundImage]];
        self.backgroundView = bgView;
        float btnWidth =frame.size.width/3.0f;
        float width=frame.size.width-btnWidth/2-30;
        float height=frame.size.height/2;
//        self.prizeIcon=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//        [self.contentView addSubview:self.prizeIcon];

        goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, width, height)];
        
        goodNameLabel.font = [UIFont systemFontOfSize:14];
        
        goodNameLabel.textAlignment = NSTextAlignmentLeft;
        
        goodNameLabel.textColor =[UIColor colorWithRed:103.0f/255.0f green:103.0f/255.0f blue:103.0f/255.0f alpha:1];
        [self.contentView addSubview:goodNameLabel];
        goodDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(goodNameLabel.frame)-5, width,height)];
        goodDetailLabel.font = [UIFont systemFontOfSize:14];
        goodDetailLabel.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:goodDetailLabel];
        mExchangeGoodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mExchangeGoodBtn.layer.masksToBounds=YES;
        mExchangeGoodBtn.layer.cornerRadius=5.0f;
        mExchangeGoodBtn.frame=CGRectZero;
        [mExchangeGoodBtn setTitle:@"兑换" forState:UIControlStateNormal];
        mExchangeGoodBtn.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:34.0f/255.0f blue:48.0f/255.0f alpha:1];
        [mExchangeGoodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:mExchangeGoodBtn];
//      [goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                      make.left.equalTo(self.prizeIcon.mas_left).offset(10.f);
//                      make.top.equalTo(self.prizeIcon.mas_top).offset(13.0f);
//                      make.bottom.equalTo(self.prizeIcon.mas_bottom).offset(-13.0f);
//                      make.width.mas_offset(4*width/5);
//      }];
//        imageIcon=[[UIImageView alloc] init];
//        [self.prizeIcon addSubview:imageIcon];
//        [imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.prizeIcon.mas_left).offset(10.f);
//            make.top.equalTo(self.prizeIcon.mas_top).offset(13.0f);
//            make.bottom.equalTo(self.prizeIcon.mas_bottom).offset(-13.0f);
//            make.width.mas_offset(4*width/5);
//        }];
        
        
        
//        goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, width, 20)];
//        goodNameLabel.font = [UIFont systemFontOfSize:11];
//        goodNameLabel.textAlignment=NSTextAlignmentCenter;
//        goodNameLabel.textColor=[UIColor colorWithRed:103.0f/255.0f green:103.0f/255.0f blue:103.0f/255.0f alpha:1];
//        [self.contentView addSubview:goodNameLabel];
//        [goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.prizeIcon.mas_right);
//            make.top.equalTo(self.mas_top).offset(20.0f);
//            make.height.mas_offset(20.0f);
//            make.width.mas_offset(width);
//        }];
        
        
//        goodDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(goodNameLabel.frame), CGRectGetMaxY(goodNameLabel.frame), CGRectGetWidth(goodNameLabel.frame), 14)];
//        goodDetailLabel.font = [UIFont systemFontOfSize:11];
//        goodDetailLabel.textAlignment=NSTextAlignmentCenter;
//        [self.contentView addSubview:goodDetailLabel];
//        [goodDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_offset(CGSizeMake(width, 20.0f));
//            make.right.equalTo(goodNameLabel.mas_right);
//            make.top.equalTo(goodNameLabel.mas_bottom);
//            
//            
//        }];
//        
//        mExchangeGoodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        mExchangeGoodBtn.layer.masksToBounds=YES;
//        mExchangeGoodBtn.layer.cornerRadius=5.0f;
//        mExchangeGoodBtn.frame=CGRectZero;
//        [mExchangeGoodBtn setTitle:@"兑换" forState:UIControlStateNormal];
//        mExchangeGoodBtn.backgroundColor=[UIColor colorWithRed:236.0f/255.0f green:34.0f/255.0f blue:48.0f/255.0f alpha:1];
//        [mExchangeGoodBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.contentView addSubview:mExchangeGoodBtn];
        [mExchangeGoodBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-10.0f);
            make.top.equalTo(self.contentView.mas_top).offset(14.0f);
            make.height.mas_offset(30.f);
            make.width.mas_offset(btnWidth*0.5);
        }];
        
//
    }
    
    return self;
}

+ (CGFloat)getGoodsItemCellHeightWithGoodsListItem:(QMGoodsListItem *)item {
    return 58.0f;
}

- (void)configureCellWithGoodsListItem:(QMGoodsListItem *)item {
    self.goodsItem = item;

        NSString *str1 = item.prizeName;
        
        NSString *str = [NSString stringWithFormat:@"%@",str1];

        goodDetailTitle=[[NSMutableAttributedString alloc] initWithString:str];
    
    if (!QM_IS_STR_NIL(item.prizeName)) {
        goodNameLabel.text =[NSString stringWithFormat:@"%@金币",item.needScore];
        
    }else {
        goodNameLabel.text = @"";
    }
    
    if (!QM_IS_STR_NIL(item.needScore)) {
//        [goodDetailTitle  addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/255.0f green:103.0f/255.0f blue:103.0f/255.0f alpha:1] range:NSMakeRange(0, 2)];
//        [goodDetailTitle addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236.0f/255.0f green:110.0f/255.0f blue:101.0f/255.0f alpha:1] range:NSMakeRange(0, 7)];
//        [goodDetailTitle  addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:103.0f/255.0f green:103.0f/255.0f blue:103.0f/255.0f alpha:1] range:NSMakeRange(5, 2)];
        goodDetailLabel.attributedText=goodDetailTitle;
        
    }else {
        goodDetailLabel.text = @"";
    }
}

@end
