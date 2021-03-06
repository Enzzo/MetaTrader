//+------------------------------------------------------------------+
//|                                                          TMS.mq4 |
//|                                                           Pipb0y |
//|                                                mac8825@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Pipb0y"
#property link      "mac8825@gmail.com"
#property version   "1.00"
#property strict

#include <Trade.mqh>
CTrade trade;

enum closing{
   none,
   closeOpposite,
   closeOppositeProfit,
   //closeProfit
};

enum F1{   
   f1d1,   //D1
   f1w1,   //W1
   f1mn    //MN
};

enum F2{
   f2m15,  //M15
   f2h1,   //H1
   f2h4,   //H4
   f2d1    //D1 
};

enum crs{
   crm5,   //M5
   crm15,  //M15
   crh1    //H1    
};

input int      magic          = 3000;
input double   volume         = 0.01;
input int      sl             = 20;
input int      tp             = 60;
input F1       filter1        = f1d1;     //Filter #1
input F2       filter2        = f2m15;    //Filter #2
input crs      cross          = crm5;     //Entry signal
input closing  closeType      = closeOpposite;
//input int      offset         = 10;
input ushort   N              = 0;//start from N bar. 0 - current

      datetime time[1];
      
      int      mtp;
      
      double f1Green1;
      double f1Red1;
      double f1Yellow1;
      double f1Green2;
      double f1Red2;
      double f1Yellow2;
      
      double f2Green1;
      double f2Red1;
      double f2Yellow1;
      double f2Green2;
      double f2Red2;
      double f2Yellow2;
      
      double cGreen1;
      double cRed1;
      double cYellow1;
      double cGreen2;
      double cRed2;
      double cYellow2;
      
      ENUM_TIMEFRAMES f1Period;
      ENUM_TIMEFRAMES f2Period;
      ENUM_TIMEFRAMES crossPeriod;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   mtp = 1; 
   if(Digits() == 5 || Digits() == 3)mtp = 10;
   
   switch(filter1){
      case 0:
         f1Period = PERIOD_D1;
      break;
      case 1:
         f1Period = PERIOD_W1;
      break;
      case 2:
         f1Period = PERIOD_MN1;
      break;
   }
   
   switch(filter2){
      case 0:
         f2Period = PERIOD_M15;
      break;
      case 1:
         f2Period = PERIOD_H1;
      break;
      case 2:
         f2Period = PERIOD_H4;
      break;
      case 3:
         f2Period = PERIOD_D1;
      break;
   }
   
   switch(cross){
      case 0:
         crossPeriod = PERIOD_M5;
      break;
      case 1:
         crossPeriod = PERIOD_M15;
      break;
      case 2:
         crossPeriod = PERIOD_H1;
      break;
   }
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
//---
   
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
//---
   //---REPEATING---
   static datetime cTime = 0;
   RefreshRates();
   CopyTime(Symbol(), PERIOD_M1, 0, 1, time);
   if(ArraySize(time)<1)return;
   if(time[0] == cTime)return;   
   cTime = time[0];
   //---END REPEATING---
   
   //---INITIALISATION---
   f1Green1 = NormalizeDouble(iCustom(Symbol(), f1Period,    "TDI Red Green", 4, N),  2);
   f1Red1   = NormalizeDouble(iCustom(Symbol(), f1Period,    "TDI Red Green", 5, N),  2);
   f1Yellow1= NormalizeDouble(iCustom(Symbol(), f1Period,    "TDI Red Green", 2, N),  2);
   f1Green2 = NormalizeDouble(iCustom(Symbol(), f1Period,    "TDI Red Green", 4, N+1),2);
   f1Red2   = NormalizeDouble(iCustom(Symbol(), f1Period,    "TDI Red Green", 5, N+1),2);
   f1Yellow2= NormalizeDouble(iCustom(Symbol(), f1Period,    "TDI Red Green", 2, N+1),2);
   
   f2Green1 = NormalizeDouble(iCustom(Symbol(), f2Period,    "TDI Red Green", 4, N),  2);
   f2Red1   = NormalizeDouble(iCustom(Symbol(), f2Period,    "TDI Red Green", 5, N),  2);
   f2Yellow1= NormalizeDouble(iCustom(Symbol(), f2Period,    "TDI Red Green", 2, N),  2);
   f2Green2 = NormalizeDouble(iCustom(Symbol(), f2Period,    "TDI Red Green", 4, N+1),2);
   f2Red2   = NormalizeDouble(iCustom(Symbol(), f2Period,    "TDI Red Green", 5, N+1),2);
   f2Yellow2= NormalizeDouble(iCustom(Symbol(), f2Period,    "TDI Red Green", 2, N+1),2);
   
   cGreen1  = NormalizeDouble(iCustom(Symbol(), crossPeriod, "TDI Red Green", 4, N),  2);
   cRed1    = NormalizeDouble(iCustom(Symbol(), crossPeriod, "TDI Red Green", 5, N),  2);
   cYellow1 = NormalizeDouble(iCustom(Symbol(), crossPeriod, "TDI Red Green", 2, N),  2);
   cGreen2  = NormalizeDouble(iCustom(Symbol(), crossPeriod, "TDI Red Green", 4, N+1),2);
   cRed2    = NormalizeDouble(iCustom(Symbol(), crossPeriod, "TDI Red Green", 5, N+1),2);
   cYellow2 = NormalizeDouble(iCustom(Symbol(), crossPeriod, "TDI Red Green", 2, N+1),2); 
    
   int dir = LastDeal();
   int sig = Signal();
   //---END INITIALISATION---
   
   switch (sig){
      case 0:
         if(dir != 0)Trade(OP_BUY);
      //break;
      case 2:
         if(closeType == closeOpposite || (closeType == closeOppositeProfit && Profit(1)>0.0))trade.CloseSell();      
      break;
      
      case 1:
         if(dir != 1)Trade(OP_SELL);
      //break;
      case 3:
         if(closeType == closeOpposite || (closeType == closeOppositeProfit && Profit(0)>0.0))trade.CloseBuy();
      break;
   }
   
   /*
   //---REVERSE---
   switch (sig){
      case 0:
         if(dir != 1)Trade(OP_SELL);
      //break;
      case 2:
         if(closeType == closeOpposite || (closeType == closeOppositeProfit && Profit(1)>0.0))trade.CloseBuy();      
      break;
      
      case 1:
         if(dir != 0)Trade(OP_BUY);
      //break;
      case 3:
         if(closeType == closeOpposite || (closeType == closeOppositeProfit && Profit(0)>0.0))trade.CloseSell();
      break;
   }
   //---END REVERSE---
   */
   //if(closeType == closeProfit)if(Profit()>0.0)trade.CloseTrades();
}
//+------------------------------------------------------------------+

int LastDeal(){
   if(OrdersTotal()>0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            return OrderType();
         }
      }
   }
   return -1;
}

int Signal(){
   if(//f1Green1 > f1Yellow1 && f1Green2 < f1Yellow2 && f1Red1 < f1Yellow1 && f1Red2 < f1Yellow2 &&
      //f2Green1 > f2Yellow1 && f2Green2 < f2Yellow2 && f2Red1 < f2Yellow1 && f2Red2 < f2Yellow2 &&
      cGreen1  > cYellow1  && cGreen2  < cYellow2  && cGreen1  > cRed1)
      return 0;
   /*if(gd11  > rd11  && rd11  > rd12  && gd11  > gd12  &&
      gm151 > rm151 && rm151 > rm152 && gm151 > gm152 &&
      gm51  > rm51  && gm52  < rm52)
      return 0;*/
   else
   if(//f1Green1 < f1Yellow1 && f1Green2 > f1Yellow2 && f1Red1 > f1Yellow1 && f1Red2 > f1Yellow2 &&
      //f2Green1 < f2Yellow1 && f2Green2 > f2Yellow2 && f2Red1 > f2Yellow1 && f2Red2 > f2Yellow2 &&
      cGreen1  < cYellow1  && cGreen2  > cYellow2  && cGreen1  < cRed1)
      return 1;
   /*else 
   if(gd11  < rd11  && rd11  < rd12  && gd11  < gd12  &&
      gm151 < rm151 && rm151 < rm152 && gm151 < gm152 &&
      gm51  < rm51  && gm52  > rm52)
      return 1;
   else*/
   if(//(f1Green1 < f1Red1 && f1Green1 < f1Green2 && f1Green1 > f1Yellow1 && f1Green2 > f1Yellow2)&&
      //(f2Green1 < f2Red1 && f2Green1 < f2Green2 && f2Green1 > f2Yellow1 && f2Green2 > f2Yellow2)&&
      (cGreen1  < cRed1  && cGreen1  < cGreen2  && cGreen1  > cYellow1  && cGreen2  > cYellow2))
      return 2;   //Сигнал на закрытие покупки
   else
   if(//(f1Green1 > f1Red1 && f1Green1 > f1Green2 && f1Green1 < f1Yellow1 && f1Green2 < f1Yellow2)&&
      //(f2Green1 > f2Red1 && f2Green1 > f2Green2 && f2Green1 < f2Yellow1 && f2Green2 < f2Yellow2)&&
      (cGreen1  > cRed1  && cGreen1  > cGreen2  && cGreen1  < cYellow1  && cGreen2  < cYellow2))
      return 3;   //Сигнал на закрытие продажи
   
   return -1;
}

double Profit(int d = -1){
   double profit = 0.0;
   
   if(OrdersTotal()>1){
      
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderType() == d || d == -1)profit += NormalizeDouble(OrderProfit()+OrderCommission()+OrderSwap(), 2);            
         }
      }
   }
   return profit;
}

bool Trade(int d){
   /*if(OrdersTotal()>0){
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
            if(OrderType() == d){
               if(d == 0){
                  if(Ask < OrderOpenPrice()-NormalizeDouble(offset*mtp*Point(), Digits()))return(trade.Buy(Symbol(), volume, sl, tp));
                  else return false;
               }
               else if(d == 1){
                  if(Bid > OrderOpenPrice()+NormalizeDouble(offset*mtp*Point(), Digits()))return(trade.Sell(Symbol(), volume, sl, tp));
                  else return false;
               }
            }
         }
      }
   }*/
   if(d == 0)return(trade.Buy(Symbol(), volume, sl, tp));
   if(d == 1)return(trade.Sell(Symbol(), volume, sl, tp));
   return false;
}