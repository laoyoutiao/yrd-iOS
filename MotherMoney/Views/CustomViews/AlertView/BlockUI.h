//
//  BlockUI.h
//
//  Created by Gustavo Ambrozio on 14/2/12.
//

#ifndef BlockUI_h
#define BlockUI_h

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
#define NSTextAlignmentCenter       UITextAlignmentCenter
#define NSLineBreakByWordWrapping   UILineBreakModeWordWrap
#define NSLineBreakByClipping       UILineBreakModeClip

#endif

#ifndef IOS_LESS_THAN_6
#define IOS_LESS_THAN_6 !([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)

#endif

#define NeedsLandscapePhoneTweaks (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) && UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)


// Action Sheet constants

#define kActionSheetAnimationDuration   0.25

#define kActionSheetBounce              10
#define kActionSheetButtonHeight        46
#define kActionSheetTopMargin           0
#define kActionSheetBorderHorizontal    13
#define kActionSheetBorderVertical      0

#define kActionSheetTitleVerticalMargin     14
#define kActionSheetTitleFont               [UIFont systemFontOfSize:16]
#define kActionSheetTitleTextColor          [UIColor grayColor]
#define kActionSheetTitleShadowColor        [UIColor grayColor]
#define kActionSheetTitleShadowOffset       CGSizeMake(0, 0)

#define kActionSheetButtonFont          [UIFont systemFontOfSize:18]
#define kActionSheetButtonTextColor     [UIColor colorWithWhite:0.235 alpha:1.0f]
#define kActionSheetButtonTextColorHighlighted     [UIColor whiteColor]
#define kActionSheetButtonShadowColor   [UIColor whiteColor]
#define kActionSheetButtonShadowOffset  CGSizeMake(0, 0)

#define kActionSheetButtonBackgroundHighlightedBoth     @"alert-action-btn-bg-highlighted-both"
#define kActionSheetButtonBackgroundHighlightedMiddle   @"alert-action-btn-bg-highlighted-middle"
#define kActionSheetButtonBackgroundHighlightedTop      @"alert-action-btn-bg-highlighted-top"
#define kActionSheetButtonBackgroundHighlightedBottom   @"alert-action-btn-bg-highlighted-bottom"

#define kActionSheetCancelButtonTextColor           [UIColor colorWithRed:42/255.0f green:137/255.0f blue:204/255.0f alpha:1.0f]
#define kActionSheetDestructiveButtonTextColor      [UIColor redColor]

#define kActionSheetBackground              @"action-sheet-panel"
#define kActionSheetBackgroundCapHeight     5
#define kActionSheetBackgroundCapWidth      5


// Alert View constants

#define kAlertViewBackgroundWidth   261

#define kAlertViewTopMargin      18
#define kAlertViewBounce         20
#define kAlertButtonHeight       (NeedsLandscapePhoneTweaks ? 32 : 42)
#define kAlertViewBorderHorizontal          (NeedsLandscapePhoneTweaks ? 4 : 8)
#define kAlertViewBorderVertical            0

#define kAlertViewButtonPartTopMargin       12
#define kAlertViewMessageBottomMargin       8
#define kAlertViewTitleBottomMargin         6

#define kAlertViewTitleFont             [UIFont boldSystemFontOfSize:18]
#define kAlertViewTitleTextColor        [UIColor whiteColor]
#define kAlertViewTitleShadowColor      [UIColor whiteColor]
#define kAlertViewTitleShadowOffset     CGSizeMake(0, 0)

#define kAlertViewMessageFont           [UIFont systemFontOfSize:15]
#define kAlertViewMessageTextColor      [UIColor blackColor]
#define kAlertViewMessageShadowColor    [UIColor whiteColor]
#define kAlertViewMessageShadowOffset   CGSizeMake(0, 0)

#define kAlertViewButtonFont            [UIFont boldSystemFontOfSize:16]
#define kAlertViewButtonTextColor       [UIColor colorWithWhite:0.235 alpha:1.0f]
#define kAlertViewButtonTextColorHighlighted      QM_THEME_COLOR
#define kAlertViewButtonShadowColor     [UIColor whiteColor]
#define kAlertViewButtonShadowOffset    CGSizeMake(0, 0)

#define kAlertViewButtonBackgroundHighlightedMiddle         @"alert-action-btn-bg-highlighted-middle"
#define kAlertViewButtonBackgroundHighlightedBottom         @"alert-action-btn-bg-highlighted-bottom"
#define kAlertViewButtonBackgroundHighlightedBottomLeft     @"alert-action-btn-bg-highlighted-bottom-left"
#define kAlertViewButtonBackgroundHighlightedBottomRight    @"alert-action-btn-bg-highlighted-bottom-right"

#define kAlertViewCancelButtonTextColor         [UIColor colorWithWhite:0.235 alpha:1.0f]
#define kAlertViewDestructiveButtonTextColor    [UIColor colorWithRed:42/255.0f green:137/255.0f blue:204/255.0f alpha:1.0f]

#define kAlertViewBackground            @"alert-window"
#define kAlertViewBackgroundLandscape   @"alert-window"
#define kAlertViewBackgroundCapHeight   5
#define kAlertViewBackgroundCapWidth    5

#endif
