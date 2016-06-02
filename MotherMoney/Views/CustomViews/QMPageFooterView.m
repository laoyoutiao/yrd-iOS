//
//  QMPageFooterView.m
//  MotherMoney
//
//

#import "QMPageFooterView.h"

@implementation QMPageFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *superView = self;
        
        actInd = [QMRefreshButton buttonWithType:UIButtonTypeCustom];
        actInd.frame = CGRectMake(71, 7, 33, 33);
        [self addSubview:actInd];
        [actInd mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(superView.mas_top).offset(7.0f);
            make.size.equalTo(CGSizeMake(33.0f, 33.0f));
        }];
        
        showTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        showTitleLabel.textColor = QM_COMMON_SUB_TITLE_COLOR;
        showTitleLabel.textAlignment = NSTextAlignmentCenter;
        showTitleLabel.font = [UIFont systemFontOfSize:14];
        showTitleLabel.text = @"";
        [self addSubview:showTitleLabel];
        [showTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(actInd.mas_right);
            make.top.equalTo(actInd.mas_top);
            make.height.equalTo(33.0f);
            make.centerX.equalTo(superView.mas_centerX);
        }];
    }
    
    return self;
}

- (void)setQMPageFootViewState:(QMPageFootViewState)_state{
    switch (_state) {
        case QMPageFootViewNoneState:
            [actInd stopAnimation];
            actInd.hidden = YES;
            showTitleLabel.text = @"";
            break;
        case QMPageFootViewNormalState:
            [actInd stopAnimation];
            actInd.hidden = YES;
            showTitleLabel.text = QMLocalizedString(@"qm_pull_up_load_more", @"上拉获取更多");
            break;
        case QMPageFootViewLoadingState: {
            [actInd startAnimation];
            actInd.hidden = NO;
            showTitleLabel.text = QMLocalizedString(@"qm_page_foot_view_loading", @"正在读取");
            CGSize s = [showTitleLabel.text boundingRectWithSize:CGSizeMake(200, 40) options:NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:showTitleLabel.font, NSFontAttributeName, nil] context:nil].size;
            CGRect r = actInd.frame;
            r.origin.x = (self.frame.size.width-s.width-r.size.width)/2-10;
            actInd.frame = r;
            break;
        }
        case QMPageFootViewNullDataState:
            [actInd stopAnimation];
            actInd.hidden = YES;
            showTitleLabel.text = QMLocalizedString(@"qm_page_foot_view_nomore", @"没有更多了");
            break;
        default:
            break;
    }
}

-(void)setXMPageFootViewDisplayText:(NSString *)text
{
    if (QM_IS_STR_NIL(text)) {
        return;
    }
    showTitleLabel.text = text;
}

-(void)setActIndState:(BOOL)isStartAnimating
{
    if (isStartAnimating) {
        [actInd startAnimation];
    }
    else
    {
        [actInd stopAnimation];
    }
}

@end
