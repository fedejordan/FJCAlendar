//
//  FJDayCollectionViewCell.h
//  CalendarTest
//
//  Created by Federico Jordán on 25/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FJDayCollectionViewCell : UICollectionViewCell
- (void)setupWithDay: (NSUInteger)day;
- (void)setupToday;
- (void)setupWithOtherMonthDay;
- (void)setupWithActualMonthDay;
- (void)setupDayAsUnavailable;
- (void)setupAsSelected;
@end
