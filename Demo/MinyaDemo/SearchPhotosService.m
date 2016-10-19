//
//  SearchPhotosService.m
//  MinyaDemo
//
//  Created by Konka on 2016/10/13.
//  Copyright © 2016年 Minya. All rights reserved.
//

#import "SearchPhotosService.h"
#import <FlickrKit/FlickrKit.h>

@implementation SearchPhotosService

- (void)requestWithParameters:(NSDictionary *)parameters success:(MIRequestSuccessBlock)success fail:(MIRequestFailBlock)fail {
    
    [[FlickrKit sharedFlickrKit] call:@"flickr.photos.getRecent" args:parameters completion:^(NSDictionary *response, NSError *error) {
        
        NSLog(@"%@", response);
        
        if (!error) {
            NSDictionary *photos = response[@"photos"];
            
            NSArray *photoArray = photos[@"photo"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            [photoArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *photo = @{
                    @"id": [NSString stringWithFormat:@"%@", obj[@"id"] ?: @""],
                    @"title": obj[@"title"] ?: @""
                };
                
                [array addObject:photo];
            }];
            
            NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            data[@"page"] = photos[@"page"];
            data[@"pages"] = photos[@"pages"];
            data[@"total"] = photos[@"total"];
            data[@"photos"] = array;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    success(data);
                }
            });
        }
    }];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end

// Example
//{
//    photos =     {
//        page = 1;
//        pages = 20;
//        perpage = 50;
//        photo =         (
//                         {
//                             farm = 6;
//                             id = 29793347113;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "30771818@N06";
//                             secret = 44d621d1a6;
//                             server = 5671;
//                             title = "";
//                         },
//                         {
//                             farm = 6;
//                             id = 29793348123;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "145174360@N05";
//                             secret = 56cc825160;
//                             server = 5340;
//                             title = "Bethany GunungSari";
//                         },
//                         {
//                             farm = 6;
//                             id = 29793348453;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "145793440@N04";
//                             secret = 48deb4b418;
//                             server = 5725;
//                             title = "#Pin -ned Vix Swimwear Aisha Triangle Bikini Top - Multi on #Pinterest Board : ML Swimwear";
//                         },
//                         {
//                             farm = 9;
//                             id = 29793349443;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "124883576@N05";
//                             secret = cddcc19f69;
//                             server = 8135;
//                             title = "\U304f\U307e\U30e2\U30f3\U306e\U30dc\U30fc\U30ea\U30f3\U30b0\U30dc\U30a6\U30eb\U3082\U3042\U3063\U305f\Uff01 #\U304f\U307e\U30e2\U30f3";
//                         },
//                         {
//                             farm = 6;
//                             id = 29793351143;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "8946624@N08";
//                             secret = a6e4d42657;
//                             server = 5610;
//                             title = "20161017_165735_Richtone(HDR)";
//                         },
//                         {
//                             farm = 9;
//                             id = 29793351413;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "142923068@N03";
//                             secret = 76d2453104;
//                             server = 8137;
//                             title = "Kota Palangka Raya adalah sebuah kota sekaligus merupakan ibu kota Provinsi Kalimantan Tengah. Kota ini memiliki luas wilayah 2678,51 km\U00b2 dan berpenduduk sebanyak 168.449 jiwa dengan kepadatan penduduk rata-rata 62,89 jiwa tiap km\U00b2 (sensus 2003). Sebelum";
//                         },
//                         {
//                             farm = 6;
//                             id = 29793351853;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "22084572@N07";
//                             secret = 2bb3083752;
//                             server = 5625;
//                             title = "Bourgogne Tanlay 161005 929.jpg";
//                         },
//                         {
//                             farm = 6;
//                             id = 29793352023;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "58735077@N05";
//                             secret = 8f23104e01;
//                             server = 5616;
//                             title = upload;
//                         },
//                         {
//                             farm = 6;
//                             id = 29793352243;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "68731317@N07";
//                             secret = 2a0fa1aa9b;
//                             server = 5673;
//                             title = "20161019_093058";
//                         },
//                         {
//                             farm = 8;
//                             id = 29793352683;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "144525823@N06";
//                             secret = 72b6b7680e;
//                             server = 7779;
//                             title = "Kebersamaan Jasmine Tour dan Komisariat Tresna ...  #nambahsaudarabukannambahteman  \Ud83d\Ude07\Ud83d\Ude07\Ud83d\Ude07\Ud83d\Ude07\Ud83d\Ude07\Ud83d\Ude07";
//                         },
//                         {
//                             farm = 9;
//                             id = 29793354033;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "145462289@N03";
//                             secret = 65b9ae86a1;
//                             server = 8274;
//                             title = "\U3059\U3079\U3066\U306e\U5199\U771f-580";
//                         },
//                         {
//                             farm = 9;
//                             id = 29793354373;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "58636469@N06";
//                             secret = 4f065b597d;
//                             server = 8128;
//                             title = "IMG_1284";
//                         },
//                         {
//                             farm = 6;
//                             id = 29793354413;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "144261394@N07";
//                             secret = 8eaa82b6a6;
//                             server = 5670;
//                             title = "2016-10-19_06-16-58";
//                         },
//                         {
//                             farm = 9;
//                             id = 29793354543;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "49118647@N08";
//                             secret = 80926e3bf5;
//                             server = 8271;
//                             title = "CamGrab [LW2-20161019111630.jpg]";
//                         },
//                         {
//                             farm = 9;
//                             id = 29793354813;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "8895347@N05";
//                             secret = 4bdf47c1dd;
//                             server = 8408;
//                             title = "IMG_7720";
//                         },
//                         {
//                             farm = 9;
//                             id = 29794189974;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "140964130@N05";
//                             secret = 1afb9bf488;
//                             server = 8130;
//                             title = "New Hakka Culture Park. Oct 2016";
//                         },
//                         {
//                             farm = 6;
//                             id = 29794191034;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "115617834@N04";
//                             secret = 6bb07074fd;
//                             server = 5722;
//                             title = "\U7a32\U8377\U753a\U306e\U591c\U3002\U4f55\U3060\U304b\U8eab\U4f53\U304c\U3050\U3063\U305f\U308a\U3057\U307e\U3059  www.hamakouichi.jp";
//                         },
//                         {
//                             farm = 6;
//                             id = 29794191134;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "146984919@N08";
//                             secret = b64d4a7b5c;
//                             server = 5590;
//                             title = "**SPECIAL BOOK TOUR + GIVEAWAY** FOSTER AN AUTHOR DAY 3 Author: Railyn Stone -Author Genre: Contemporary, Romance Event: Foster An Author #FAA #FAA2 Hosted by : Teaser Addicts Book Blog ***************************************** **Title: A Secret To Keep P";
//                         },
//                         {
//                             farm = 9;
//                             id = 29794192104;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "52616549@N07";
//                             secret = 2f6e6be096;
//                             server = 8280;
//                             title = "DSC00299.jpg";
//                         },
//                         {
//                             farm = 6;
//                             id = 29794192394;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "7862959@N02";
//                             secret = 9233db173f;
//                             server = 5341;
//                             title = "\U5c4b\U5f62\U8239\U3068\U77f3\U57a3\U3068\U5929\U5b88\U95a3";
//                         },
//                         {
//                             farm = 6;
//                             id = 30127966990;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "77278536@N02";
//                             secret = dc50dc25a7;
//                             server = 5479;
//                             title = "Falling leaves  #bb8 #bb8sphero #bb8awakens #bb8droid #sphero #spherobb8 #spherobb8droid #stuckinplastic  #toyslagram #toyunion #toycrewbuddies #toycrewbuddies #stormtrozzhead #toyhumor  #exclucollective #Click_Vision  #rogueone";
//                         },
//                         {
//                             farm = 9;
//                             id = 30127968170;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "26352926@N07";
//                             secret = f2d7d3f77f;
//                             server = 8548;
//                             title = "";
//                         },
//                         {
//                             farm = 6;
//                             id = 30127969520;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "143630318@N03";
//                             secret = 57895826f5;
//                             server = 5445;
//                             title = "Ivanna&Jake + Sarahlin&Matt @ hoco 2k16";
//                         },
//                         {
//                             farm = 9;
//                             id = 30308123732;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "135654783@N08";
//                             secret = 1e53b53ce1;
//                             server = 8127;
//                             title = upload;
//                         },
//                         {
//                             farm = 6;
//                             id = 30308125982;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "72396314@N00";
//                             secret = 4bd3dfa098;
//                             server = 5536;
//                             title = "Architecture Built Structure City Urban Bridge Buildings";
//                         },
//                         {
//                             farm = 9;
//                             id = 30308126712;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "135896601@N02";
//                             secret = d8c6268741;
//                             server = 8410;
//                             title = "25 Settembre 2016 - Next 100 Festival -100 Anni di BMW - Autodromo di Monza #motormaniaci #webtv #sbandy #auto #automotive #car #moto #instamoto #motorcycle #instamotorcycle #monza #next100 #bmw #mini #bmwmotorrad";
//                         },
//                         {
//                             farm = 6;
//                             id = 30308126862;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "120929564@N04";
//                             secret = 1db52c2353;
//                             server = 5826;
//                             title = "Westfield Place - 19 Oct 2016 11:12";
//                         },
//                         {
//                             farm = 6;
//                             id = 30338718481;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "130677041@N02";
//                             secret = 567b86d680;
//                             server = 5775;
//                             title = "Anna Grace Responsive WordPress Theme - Angie Makes";
//                         },
//                         {
//                             farm = 6;
//                             id = 30338718671;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "30036284@N00";
//                             secret = 63bebdd492;
//                             server = 5348;
//                             title = "DSC08700.jpg";
//                         },
//                         {
//                             farm = 9;
//                             id = 30338718851;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "97879984@N02";
//                             secret = c6e53f59a5;
//                             server = 8557;
//                             title = "D50_3623.jpg";
//                         },
//                         {
//                             farm = 9;
//                             id = 30338718861;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "68274956@N04";
//                             secret = 5559dccb3e;
//                             server = 8624;
//                             title = "#\U043a\U043e\U0432\U0435\U0440# \U0432 \U0434\U0435\U0442\U0441\U043a\U0443\U044e #\U043a\U043e\U0432\U0435\U0440\U043a\U0440\U044e\U0447\U043a\U043e\U043c#\U043f\U0440\U044f\U0436\U0430#spagetti#\U0438\U0441\U043f\U043e\U043b\U043d\U0435\U043d\U0438\U0435\U0436\U0435\U043b\U0430\U043d\U0438\U0439# \U043b\U044e\U0431\U0438\U043c\U044b\U0445 \U0434\U0435\U0432\U043e\U0447\U0435\U043a";
//                         },
//                         {
//                             farm = 9;
//                             id = 30338720831;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "110244216@N05";
//                             secret = b0d6a7e69e;
//                             server = 8417;
//                             title = "20150907_204628_Richtone(HDR)";
//                         },
//                         {
//                             farm = 6;
//                             id = 30388861696;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "143395462@N07";
//                             secret = 4daf029915;
//                             server = 5812;
//                             title = "DSC_0800";
//                         },
//                         {
//                             farm = 9;
//                             id = 30388862576;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "35684082@N05";
//                             secret = 06a346f063;
//                             server = 8417;
//                             title = "\U831c\U8272\U306b\U67d3\U307e\U308b\U79cb\U685c #\U79cb\U685c #\U30b3\U30b9\U30e2\U30b9 #\U831c\U8272 #\U5915\U713c\U3051 #\U5915\U713c\U3051 #\U5915\U65b9 #\U5915\U666f #\U30b3\U30b9\U30e2\U30b9\U7551 #cosmos #cosmosfield #flower #flowergarden #eveningglow #sunsetglow #sunset #pentaxk1 #dfa100 #pentaxian #pentax";
//                         },
//                         {
//                             farm = 6;
//                             id = 30388862686;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "125825329@N05";
//                             secret = a5748683bf;
//                             server = 5714;
//                             title = image;
//                         },
//                         {
//                             farm = 6;
//                             id = 30388862956;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "50088007@N03";
//                             secret = 608d02bc37;
//                             server = 5647;
//                             title = "10_20_17_12_5";
//                         },
//                         {
//                             farm = 9;
//                             id = 30388863006;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "13811316@N08";
//                             secret = b8bd63c563;
//                             server = 8133;
//                             title = "DSC00140.jpg";
//                         },
//                         {
//                             farm = 6;
//                             id = 30388863686;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "145171844@N04";
//                             secret = 31ae638f84;
//                             server = 5343;
//                             title = "ny city \Ud83d\Udc9a";
//                         },
//                         {
//                             farm = 6;
//                             id = 30388864696;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "14790526@N06";
//                             secret = 8f07daf7a3;
//                             server = 5325;
//                             title = "DSC_0721XX";
//                         },
//                         {
//                             farm = 9;
//                             id = 30388865126;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "8250364@N03";
//                             secret = 74037895a1;
//                             server = 8654;
//                             title = "";
//                         },
//                         {
//                             farm = 6;
//                             id = 30424991595;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "84509016@N03";
//                             secret = 71cfb52e31;
//                             server = 5540;
//                             title = "Loch Tay from Kenmore";
//                         },
//                         {
//                             farm = 6;
//                             id = 30424991825;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "144512256@N07";
//                             secret = 4a8bda1f5e;
//                             server = 5565;
//                             title = "\U00a9Alejandro Hernandez Look my web for more informativa  #tree #people #photogram #person #blackandwhite #nature #love #art #photooftheday #padlock #streetphotography #free #park #paisaje #landscape #nature #natural #statue #city #follow #freedom";
//                         },
//                         {
//                             farm = 6;
//                             id = 30424992365;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "110850398@N06";
//                             secret = 29fe6ef483;
//                             server = 5603;
//                             title = upload;
//                         },
//                         {
//                             farm = 6;
//                             id = 30424993525;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "56315420@N02";
//                             secret = 0a988d23b1;
//                             server = 5673;
//                             title = "monster-426993_640";
//                         },
//                         {
//                             farm = 9;
//                             id = 30424994515;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "142846214@N06";
//                             secret = 54c460f92b;
//                             server = 8133;
//                             title = "_CER8149.jpg";
//                         },
//                         {
//                             farm = 6;
//                             id = 30424994525;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "24597348@N03";
//                             secret = 2c107c4b09;
//                             server = 5801;
//                             title = "FCI Agility WC 2016 Zaragoza - Training / Entrenamientos 2016 08 22";
//                         },
//                         {
//                             farm = 6;
//                             id = 30424995195;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "55732233@N07";
//                             secret = fd71b3efa1;
//                             server = 5820;
//                             title = "The Revival Tour at Trix, Antwerpen 2012";
//                         },
//                         {
//                             farm = 6;
//                             id = 30424995215;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "50058453@N00";
//                             secret = a55b6cc85d;
//                             server = 5513;
//                             title = "Buckingham Palace.";
//                         },
//                         {
//                             farm = 6;
//                             id = 30424995235;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "146624035@N05";
//                             secret = f084b0e779;
//                             server = 5523;
//                             title = "2016-10-19_01-17-45";
//                         },
//                         {
//                             farm = 6;
//                             id = 30424995255;
//                             isfamily = 0;
//                             isfriend = 0;
//                             ispublic = 1;
//                             owner = "145719025@N07";
//                             secret = db588bd527;
//                             server = 5503;
//                             title = "#reservacion #online #reservacionesporinternet #ricardobonifazpeluquer\U00eda #ricardobonifazpeluqueria #ricardobonifaz #peluqueria";
//                         }
//                         );
//        total = 1000;
//    };
//    stat = ok;
//}

