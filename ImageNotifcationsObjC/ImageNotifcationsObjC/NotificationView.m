//
//  NotificationView.m
//  notif10objc
//
//  Created by Chandra Rao on 05/09/17.
//  Copyright © 2017 Chandra Rao. All rights reserved.
//

#import "NotificationView.h"

@implementation NotificationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UIView* mainView;
    if (self)
    {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"NotificationView" owner:self options:nil];
        mainView = [subviewArray objectAtIndex:0];
        mainView.frame = self.bounds;
        [self addSubview:mainView];
    }
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
}
@end
