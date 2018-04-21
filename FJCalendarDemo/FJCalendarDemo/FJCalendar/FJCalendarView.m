//
//  FJCalendarView.m
//  CalendarTest
//
//  Created by Federico Jordán on 25/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

#import "FJCalendarView.h"
#import "FJDayCollectionViewCell.h"

@interface FJCalendarView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *monthYearLabel;
@property (nonatomic, weak) IBOutlet UICollectionView *daysCollectionView;
@property (nonatomic, strong) NSMutableArray *unavailableDays;

@end

@implementation FJCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSBundle mainBundle] loadNibNamed:@"FJCalendarView" owner:self options:nil];
    [self addSubview: self.contentView];
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self configureWithActualDate];
    [self.daysCollectionView registerNib:[UINib nibWithNibName:@"FJDayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FJDayCollectionViewCell"];
    self.unavailableDays = @[].mutableCopy;
}

- (void)configureWithActualDate {
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSString *monthName = [self monthNameForMonthNumber:month];
    self.monthYearLabel.text = [NSString stringWithFormat:@"%@ %ld", monthName, (long)year];
    self.actualMonth = month;
    self.actualYear = year;
}

// MARK:- Actions
- (IBAction)didSelectNextMonth:(id)sender {
    if(self.actualMonth<12) {
        self.actualMonth++;
    } else {
        self.actualYear++;
        self.actualMonth = 1;
    }
    
    NSString *monthName = [self monthNameForMonthNumber:self.actualMonth];
    self.monthYearLabel.text = [NSString stringWithFormat:@"%@ %ld", monthName, (long)self.actualYear];
    [self.daysCollectionView reloadData];
    [self.delegate didChangeToMonth:self.actualMonth andYear:self.actualYear];
}

- (IBAction)didSelectPreviousMonth:(id)sender {
    if(self.actualMonth>1) {
        self.actualMonth--;
    } else {
        self.actualYear--;
        self.actualMonth = 12;
    }
    
    NSString *monthName = [self monthNameForMonthNumber:self.actualMonth];
    self.monthYearLabel.text = [NSString stringWithFormat:@"%@ %ld", monthName, (long)self.actualYear];
    [self.daysCollectionView reloadData];
    [self.delegate didChangeToMonth:self.actualMonth andYear:self.actualYear];
}

// MARK:- Utils
- (NSString *)monthNameForMonthNumber: (NSUInteger)monthNumber {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSString *monthName = [[df monthSymbols] objectAtIndex:(monthNumber-1)];
    return monthName;
}

- (NSUInteger)numberOfDaysForMonth: (NSUInteger)month andYear: (NSUInteger)year {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setMonth:month];
    [dateComponents setDay:1];
    
    NSCalendar *calendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *configuredDate = [calendar dateFromComponents:dateComponents];
    
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:configuredDate];
    return days.length;
}

- (BOOL)dayIsToday: (NSUInteger)day {
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    NSInteger todayDay = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    return todayDay == day && month == self.actualMonth && year == self.actualYear;
}

- (NSUInteger)getWeekDayNumberForFirstDayForActualMonth {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:self.actualYear];
    [dateComponents setMonth:self.actualMonth];
    [dateComponents setDay:1];
    
    NSCalendar *calendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *configuredDate = [calendar dateFromComponents:dateComponents];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:configuredDate];
    
    return components.weekday -1;
}

- (void)setDayAsUnavailable: (NSUInteger)day {
    [self.unavailableDays addObject: [NSNumber numberWithUnsignedInteger: day]];
    [self.daysCollectionView reloadData];
}

- (void)clearUnavailableDays {
    self.unavailableDays = @[].mutableCopy;
    [self.daysCollectionView reloadData];
}

- (BOOL)dayIsUnavailable: (NSUInteger)day {
    for (NSNumber *unavaiableDayNumber in self.unavailableDays) {
        if(unavaiableDayNumber.unsignedIntegerValue == day) {
            return YES;
        }
    }
    return NO;
}

- (void)clearSelectedDay {
    self.selectedDay = 0;
    [self.daysCollectionView reloadData];
}

- (NSDate *)selectedDate {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:self.actualYear];
    [dateComponents setMonth:self.actualMonth];
    [dateComponents setDay:1];
    
    NSCalendar *calendar = [[NSCalendar alloc]  initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *selectedDate = [calendar dateFromComponents:dateComponents];
    return selectedDate;
}

- (NSString *)selectedDateString {
    NSString *monthName = [self monthNameForMonthNumber:self.selectedMonth];
    NSString *dateString = [NSString stringWithFormat:@"%lu de %@", (unsigned long)self.selectedDay, monthName];
    return dateString;
}

- (void)setAllActualMonthDaysAsUnavailable {
    self.unavailableDays = @[].mutableCopy;
    NSUInteger lastDayNumberForActualMonth = [self numberOfDaysForMonth:self.actualMonth andYear:self.actualYear];
    for (int i = 1; i<=lastDayNumberForActualMonth; i++) {
        [self.unavailableDays addObject: [NSNumber numberWithUnsignedInteger: i]];
    }
    [self.daysCollectionView reloadData];
}

- (void)setDayAsAvailable: (NSUInteger)day {
    NSMutableArray *daysToRemove = [NSMutableArray new];
    for (NSNumber *unavailableDay in self.unavailableDays) {
        if([unavailableDay unsignedIntegerValue] == day) {
            [daysToRemove addObject:unavailableDay];
        }
    }
    [self.unavailableDays removeObjectsInArray:daysToRemove];
    [self.daysCollectionView reloadData];
}

- (void)setAllActualMonthDaysAsUnavailableExcept: (NSArray *)availableDays {
    self.unavailableDays = @[].mutableCopy;
    NSUInteger lastDayNumberForActualMonth = [self numberOfDaysForMonth:self.actualMonth andYear:self.actualYear];
    for (int i = 1; i<=lastDayNumberForActualMonth; i++) {
        BOOL isUnavailable = true;
        
        for (NSNumber *availableDay in availableDays) {
            if([availableDay unsignedIntegerValue] == i) {
                isUnavailable = false;
            }
        }
        
        if(isUnavailable) {
            [self.unavailableDays addObject: [NSNumber numberWithUnsignedInteger: i]];
        }
    }
    [self.daysCollectionView reloadData];
}

// MARK:- UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FJDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FJDayCollectionViewCell" forIndexPath:indexPath];
    
    NSUInteger firstDayOfActualMonthWeekDay = [self getWeekDayNumberForFirstDayForActualMonth];
    NSUInteger daysForActualMonth = [self numberOfDaysForMonth:self.actualMonth andYear:self.actualYear];
    
    if([self indexPathIsForPreviousMonth:indexPath]) {
        NSUInteger daysForPreviousMonth;
        if(self.actualMonth>1) {
            daysForPreviousMonth = [self numberOfDaysForMonth:self.actualMonth - 1 andYear:self.actualYear];
        } else {
            daysForPreviousMonth = [self numberOfDaysForMonth:12 andYear:self.actualYear - 1];
        }
        NSUInteger previousMonthDay = daysForPreviousMonth - firstDayOfActualMonthWeekDay + indexPath.item + 1;
        [cell setupWithDay: previousMonthDay];
        [cell setupWithOtherMonthDay];
    } else if([self indexPathIsForNextMonth:indexPath]) {
        NSUInteger nextMonthDay = indexPath.item - daysForActualMonth - firstDayOfActualMonthWeekDay + 1;
        [cell setupWithDay: nextMonthDay];
        [cell setupWithOtherMonthDay];
    } else {
        NSUInteger day = indexPath.item+1-firstDayOfActualMonthWeekDay;
        [cell setupWithDay:day];
        [cell setupWithActualMonthDay];
        if([self dayIsToday: day]) {
            [cell setupToday];
        }
        if([self dayIsUnavailable: day]) {
            [cell setupDayAsUnavailable];
        } else if([self dayIsSelected: day]) {
            [cell setupAsSelected];
        }
        
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 35;
}

- (BOOL)indexPathIsForPreviousMonth: (NSIndexPath *)indexPath {
    NSUInteger firstDayOfActualMonthWeekDay = [self getWeekDayNumberForFirstDayForActualMonth];
    return indexPath.item < firstDayOfActualMonthWeekDay;
}

- (BOOL)indexPathIsForNextMonth: (NSIndexPath *)indexPath {
    NSUInteger firstDayOfActualMonthWeekDay = [self getWeekDayNumberForFirstDayForActualMonth];
    NSUInteger daysForActualMonth = [self numberOfDaysForMonth:self.actualMonth andYear:self.actualYear];
    return indexPath.item > daysForActualMonth + firstDayOfActualMonthWeekDay - 1;
}

- (BOOL)dayIsSelected: (NSUInteger)day {
    return day == self.selectedDay && self.actualMonth == self.selectedMonth && self.actualYear == self.selectedYear;
}


// MARK:- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.daysCollectionView.frame.size.width / 7;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger firstDayOfActualMonthWeekDay = [self getWeekDayNumberForFirstDayForActualMonth];
    NSUInteger day = indexPath.item+1- firstDayOfActualMonthWeekDay;
    
    if([self indexPathIsForNextMonth:indexPath] == NO &&
       [self indexPathIsForPreviousMonth:indexPath] == NO &&
       [self dayIsUnavailable:day] == NO) {
        [self.delegate didSelectDay:day month:self.actualMonth andYear:self.actualYear];
        self.selectedDay = day;
        self.selectedMonth = self.actualMonth;
        self.selectedYear = self.actualYear;
        [self.daysCollectionView reloadData];
    }
}


@end
