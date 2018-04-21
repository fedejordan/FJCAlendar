//
//  ViewController.m
//  CalendarTest
//
//  Created by Federico Jordán on 25/3/18.
//  Copyright © 2018 Federico Jordán. All rights reserved.
//

#import "ViewController.h"
#import "FJCalendarView.h"

@interface ViewController () <FJCalendarViewDelegate>

@property (nonatomic, weak) IBOutlet FJCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.calendarView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didChangeToMonth:(NSUInteger)month andYear:(NSUInteger)year {
    [self.calendarView clearUnavailableDays];
    if(month==5) {
        [self.calendarView setDayAsUnavailable:15];
    }
    NSLog(@"didChangeToMonth: %lu andYear: %d", (unsigned long)month, year);
}

- (void)didSelectDay:(NSUInteger)day month:(NSUInteger)month andYear:(NSUInteger)year {
    NSLog(@"didSelectDay: %lu month: %d andYear: %d", (unsigned long)day, month, year);
}


@end

