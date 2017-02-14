//
//  NewUserModel.h
//  iMixedTape
//
//  Created by Mustafa Qutbuddin on 1/3/17.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewUserModel : NSObject

+(void)postUserSessionWithName :(NSString *)fname
                          lname:(NSString *)lname
                          email:(NSString *)email
                       password:(NSString *)password
                         gender:(NSString *)gender
                            dob:(NSString *)dob
                       deviceID:(NSString *)deviceID
                    deviceToken:(NSString *)deviceToken
                       platform:(NSString *)platform
                        country:(NSString *)country
                           city:(NSString *)city
                          state:(NSString *)state
                          phone:(NSString *)phone
                 oauth_provider:(NSString *)oauth_provider
                      oauth_uid:(NSString *)oauth_uid
                        zipcode:(NSString *)zipcode
                               : (void (^)(id))callback;


@end
