//
//  FJCalendarView.h
//  CalendarTest
//
//  Created by Federico Jordán on 25/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FJCalendarViewDelegate <NSObject>
- (void)didChangeToMonth: (NSUInteger)month andYear: (NSUInteger)year;
- (void)didSelectDay: (NSUInteger)day month: (NSUInteger)month andYear: (NSUInteger)year;
@end

@interface FJCalendarView : UIView

@property (nonatomic, weak) id<FJCalendarViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger selectedDay;
@property (nonatomic, assign) NSUInteger selectedMonth;
@property (nonatomic, assign) NSUInteger selectedYear;
@property (nonatomic, assign) NSUInteger actualMonth;
@property (nonatomic, assign) NSUInteger actualYear;

- (void)setDayAsUnavailable: (NSUInteger)day;
- (void)clearUnavailableDays;
- (void)clearSelectedDay;
- (NSString *)selectedDateString;
//- (void)setUnavailableDaysBeforeToday;
- (void)setAllActualMonthDaysAsUnavailable;
- (void)setDayAsAvailable: (NSUInteger)day;
- (void)setAllActualMonthDaysAsUnavailableExcept: (NSArray *)availableDays;
@end
