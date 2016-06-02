//
//  QMProductImageCell.m
//  MotherMoney
//

#import "QMProductImageCell.h"
#import "UIImageView+AFNetworking.h"

#define NORMAL_IMAGE_CELL_BOTTOM_PADDING 5
#define LAST_IMAGE_CELL_BOTTOM_PADDING 15

NSString *const PRODUCTIMAGECELL_IMAGE_DOWNLOAD_SUCCESS = @"productimagecell_image_download_success";

@implementation QMProductImageCell {
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView = bgView;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(frame) - 2 * 15, CGRectGetHeight(frame) - NORMAL_IMAGE_CELL_BOTTOM_PADDING)];
        [self.contentView addSubview:imageView];
    }
    
    return self;
}

+ (CGSize)getCellSizeWithProductImageItem:(QMProductImageItemModel *)model
                                isLastOne:(BOOL)lastOne {
    model.image = [UIImageView getCachedImageForURL:[NSURL URLWithString:model.imagePath]];
    CGSize size = model.image.size;
    
    CGFloat height = 100;
    if (size.width > 0 && size.height > 0) {
        if (size.width > [UIScreen mainScreen].bounds.size.width - 2 * (15 + 8)) {
            CGFloat ratio = ([UIScreen mainScreen].bounds.size.width - 2 * (15 + 8)) / size.width;
            height = size.height * ratio;
        }else {
            height = size.height;
        }
    }
    
    if (lastOne) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 8, height + LAST_IMAGE_CELL_BOTTOM_PADDING);
    }else {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width - 2 * 8, height + NORMAL_IMAGE_CELL_BOTTOM_PADDING);
    }
}

- (void)configureCellWithProductImageItem:(QMProductImageItemModel *)model
                                isLastOne:(BOOL)lastOne {
    if (!QM_IS_STR_NIL(model.imagePath)) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.imagePath]];
        
        if (model.image) {
            imageView.image = model.image;
            [self updateImageViewFrame:lastOne];
            return;
        }
        
        __weak UIImageView *weakImageView = imageView;
        __weak QMProductImageCell *weakSelf = self;
        [imageView setImageWithURLRequest:request
                         placeholderImage:nil
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                      NSString *strUrl = request.URL.path;
                                      if (!QM_IS_STR_NIL(strUrl) && !QM_IS_STR_NIL(model.imagePath) && [strUrl isEqualToString:model.imagePath]) {
                                          model.image = image;
                                          weakImageView.image = image;
                                          [weakSelf updateImageViewFrame:lastOne];
                                      }
                                      
                                      [[NSNotificationCenter defaultCenter] postNotificationName:PRODUCTIMAGECELL_IMAGE_DOWNLOAD_SUCCESS object:nil];
                                  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                      
                                  }];
        [self updateImageViewFrame:lastOne];
    }
}

- (void)updateImageViewFrame:(BOOL)lastOne {
    if (lastOne) {
        imageView.frame = CGRectMake(15, 0, CGRectGetWidth(self.frame) - 2 * 15, CGRectGetHeight(self.frame) - LAST_IMAGE_CELL_BOTTOM_PADDING);
    }else {
        imageView.frame = CGRectMake(15, 0, CGRectGetWidth(self.frame) - 2 * 15, CGRectGetHeight(self.frame) - NORMAL_IMAGE_CELL_BOTTOM_PADDING);
    }
}

- (void)prepareForReuse {
    imageView.image = nil;
    UIImageView *imgView = (UIImageView *)self.backgroundView;
    imgView.image = nil;
}

@end
