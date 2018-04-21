//
//  FJDayCollectionViewCell.m
//  CalendarTest
//
//  Created by Federico Jordán on 25/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

#import "FJDayCollectionViewCell.h"

@interface FJDayCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *dayLabel;

@end

@implementation FJDayCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.dayLabel.layer.cornerRadius = self.dayLabel.frame.size.width/2.0f;
    self.dayLabel.layer.masksToBounds = YES;
}


- (void)setupWithDay: (NSUInteger)day {
    self.dayLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)day];
    self.dayLabel.backgroundColor = [UIColor clearColor];
}

- (void)setupToday {
    self.dayLabel.textColor = [UIColor redColor];
}

- (void)setupWithOtherMonthDay {
    self.dayLabel.textColor = [UIColor lightGrayColor];
}

- (void)setupWithActualMonthDay {
    self.dayLabel.textColor = [self activeColor];
}

- (void)setupDayAsUnavailable {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:self.dayLabel.text attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
    self.dayLabel.attributedText = attributedText;
    self.dayLabel.textColor = [UIColor lightGrayColor];
}

- (UIColor *)activeColor {
    return [UIColor colorWithRed:78.0f/255.0f green:176.0f/255.0f blue:223.0f/255.0f alpha:1.0f];
}

- (void)setupAsSelected {
    self.dayLabel.backgroundColor = [self activeColor];
    self.dayLabel.textColor = [UIColor whiteColor];
}

@end
