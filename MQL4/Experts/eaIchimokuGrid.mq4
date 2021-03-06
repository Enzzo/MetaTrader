//+------------------------------------------------------------------+
//|                                               eaIchimokuGrid.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property description "Определяем минимальный и максимальный уровень цен за выбранный период"
#property description "и за определенное количество баров. Устанавливаем зоны покупки и про-"
#property description "дажи. Вверху - продаем, внизу - покупаем"

#include <Trade.mqh>

CTrade trade;

input int               magic       = 8888866;     //magic
input ENUM_TIMEFRAMES   periodG     = PERIOD_MN1;  //Старший таймфрейм
input int               barsG       = 100;         //Бары для рассчета мин/макс цены
input ushort            selllevelG  = 80;          //Продавать выше уровня базовой свечи (%)
input ushort            buylevelG   = 20;          //Покупать ниже уровня базовой свечи (%)
input ENUM_TIMEFRAMES   periodJ     = PERIOD_D1;   //Младший таймфрейм
input int               barsJ       = 100;         //Бары для рассчета мин/макс цены
input ushort            selllevelJ  = 80;          //Продавать выше уровня базовой свечи (%)
input ushort            buylevelJ   = 20;          //Покупать ниже уровня базовой свечи (%)
input int               SL          = 30;
input int               TP          = 70;
input double            volume      = 0.01;        
input int               MAperiod    = 200;

      string            botName  = WindowExpertName();
      datetime          cTime[];
      datetime          pTime;
      ENUM_TIMEFRAMES   period   = PERIOD_CURRENT;
      int               mtp      = 1;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(botName);   
   pTime = 0;
   
   if(Digits() == 5 || Digits() == 3)mtp = 10;
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
   if(selllevelG<buylevelG || selllevelG > 100 || selllevelG < 0 || buylevelG > 100 || buylevelG < 0 ||
      selllevelJ<buylevelJ || selllevelJ > 100 || selllevelJ < 0 || buylevelJ > 100 || buylevelJ < 0){
      Comment("Уровни заданы неверно\nАвтоторговля отключена.");
      return;
   }
   CopyTime(Symbol(), periodJ, 0, barsJ>=iBars(Symbol(), periodJ)?iBars(Symbol(), periodJ):barsJ, cTime);
   if(ArraySize(cTime)<1)return;
   
   static double sellPriceG = 0.0;   //уровень, выше которого можно продавать
   static double buyPriceG  = 0.0;   //уровень, ниже которого можно покупать
   static double sellPriceJ = 0.0;   //уровень, выше которого можно продавать
   static double buyPriceJ  = 0.0;   //уровень, ниже которого можно покупать
   
   if(pTime != cTime[0]){
      pTime = cTime[0];
      double highestG = iHigh(Symbol(),periodG, iHighest(Symbol(),periodG, MODE_HIGH,barsG>=iBars(Symbol(), periodG)?iBars(Symbol(), periodG):barsG));
      double lowestG  = iLow(Symbol(), periodG, iLowest(Symbol(), periodG, MODE_LOW, barsG>=iBars(Symbol(), periodG)?iBars(Symbol(), periodG):barsG));
      double highestJ = iHigh(Symbol(),periodJ, iHighest(Symbol(),periodJ, MODE_HIGH,barsJ>=iBars(Symbol(), periodJ)?iBars(Symbol(), periodJ):barsJ));
      double lowestJ  = iLow(Symbol(), periodJ, iLowest(Symbol(), periodJ, MODE_LOW, barsJ>=iBars(Symbol(), periodJ)?iBars(Symbol(), periodJ):barsJ));
      sellPriceG = NormalizeDouble(lowestG + (highestG - lowestG)/100*selllevelG, Digits());
      buyPriceG  = NormalizeDouble(lowestG + (highestG - lowestG)/100*buylevelG,  Digits());
      sellPriceJ = NormalizeDouble(lowestJ + (highestJ - lowestJ)/100*selllevelJ, Digits());
      buyPriceJ  = NormalizeDouble(lowestJ + (highestJ - lowestJ)/100*buylevelJ,  Digits());
      string comm = "";
      
      if(Ask < buyPriceG && Ask < buyPriceJ)
         comm = "Только покупать";
      else if(Bid > sellPriceG && Bid > sellPriceJ)
         comm = "Только продавать";
      Comment("СТАРШИЕ УРОВНИ:\nSELL: "+DoubleToString(sellPriceG)+"\nBUY: "+DoubleToString(buyPriceG)+"\n"+
              "МЛАДШИЕ УРОВНИ:\nSELL: "+DoubleToString(sellPriceJ)+"\nBUY: "+DoubleToString(buyPriceJ)+"\n"+comm);
   }
   else{
      /*MqlRates D1Rates[];
      MqlRates H1Rates[];
      MqlRates M15Rates[];
        
      RefreshRates();
      CopyRates(Symbol(), PERIOD_D1,  0, 3, D1Rates);
      CopyRates(Symbol(), PERIOD_H1,  0, 3, H1Rates);
      CopyRates(Symbol(), PERIOD_M15, 0, 3, M15Rates);
         
      ArraySetAsSeries(D1Rates,  true);
      ArraySetAsSeries(H1Rates,  true);
      ArraySetAsSeries(M15Rates, true);
         
      double ma200 = iMA(Symbol(), PERIOD_MN1, 200, 0, MODE_EMA, PRICE_CLOSE, 1);
      double ma50  = iMA(Symbol(), PERIOD_MN1,  50, 0, MODE_EMA, PRICE_CLOSE, 1);
    //double atr   = iATR(Symbol(), PERIOD_D1, 14, 1);
      */if(Total() == 0){      
         /*if(ArraySize(D1Rates)!=3 || ArraySize(H1Rates)!=3 || ArraySize(M15Rates)!=3)return;
         
         if(      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
                  iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
                  iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
                  iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)<D1Rates[0].low  &&
                  iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 1)<D1Rates[1].low  &&
                  iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 2)<D1Rates[2].low  &&
                  iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)<H1Rates[0].low  &&
                  iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 1)<H1Rates[1].low  &&
                  iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 2)<H1Rates[2].low  &&
                  iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)<M15Rates[0].low &&
                  iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)<M15Rates[1].low &&
                  iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 2)<M15Rates[2].low &&
                  iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1)>50){
                     */if(Ask < buyPriceG && Ask < buyPriceJ){//High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-(High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-Low[iLowest(Symbol(), PERIOD_MN1, MODE_LOW, 4, 0)])/2)
                        /*trade.BuyStop(Symbol(), AutoLot(), 20, 50);
                        trade.CloseSell();*/
                         SendOrders(0);
                  }
         
         /*else if( iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
                  iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
                  iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
                  iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)>D1Rates[0].high  &&
                  iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 1)>D1Rates[1].high  &&
                  iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 2)>D1Rates[2].high  &&
                  iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)>H1Rates[0].high  &&
                  iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 1)>H1Rates[1].high  &&
                  iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 2)>H1Rates[2].high  &&
                  iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)>M15Rates[0].high &&
                  iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)>M15Rates[1].high &&
                  iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 2)>M15Rates[2].high &&
                  iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1)<50){
                     */if(Bid > sellPriceG && Bid > sellPriceJ){//High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-(High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-Low[iLowest(Symbol(), PERIOD_MN1, MODE_LOW, 4, 0)])/2)
                     /*trade.SellStop(Symbol(), AutoLot(), 20, 50);
                     trade.CloseBuy();*/
                     SendOrders(1);
                  }
         
      }
      else {
         TralOrders();
         //BuildGrid();
         //TakeProfit();
      }
   }
}
//+------------------------------------------------------------------+

void SendOrders(int d = -1){
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), period, 1, 1, rates);
   if(ArraySize(rates) < 1)
      return;
   
   double ma0 = iMA(Symbol(), period, MAperiod,  0, MODE_EMA, PRICE_CLOSE, 0);
   double ma1 = iMA(Symbol(), period, MAperiod,  0, MODE_EMA, PRICE_CLOSE, 1);
   if(rates[0].low > ma0 && Bid > ma1 && d == 1){
      trade.SellStop(Symbol(), volume, NormalizeDouble(ma1, Digits()), SL==0?0.0:NormalizeDouble(ma1 + SL*Point()*mtp, Digits()), TP==0?0.0:NormalizeDouble(ma1  - TP*Point()*mtp, Digits()), 0, botName+"_MA_21");
      ObjectSetInteger(0, "Send", OBJPROP_STATE, false);
      //Print("Buy ",NormalizeDouble(ma1, Digits())," SL: ",NormalizeDouble(ma1 - SL*Point()*mtp, Digits()), " TP: ",NormalizeDouble(ma1  + TP*Point()*mtp, Digits()));
      return;
   }
   if(rates[0].high < ma0 && Ask < ma1 && d == 0){
      trade.BuyStop(Symbol(), volume, NormalizeDouble(ma1, Digits()), SL==0?0.0:NormalizeDouble(ma1 - SL*Point()*mtp, Digits()), TP==0?0.0:NormalizeDouble(ma1 + TP*Point()*mtp, Digits()), 0, botName+"_MA_21");
      ObjectSetInteger(0, "Send", OBJPROP_STATE, false);
      //Print("Sell ",NormalizeDouble(ma1, Digits())," SL: ",NormalizeDouble(ma1 + SL*Point()*mtp, Digits()), " TP: ",NormalizeDouble(ma1  - TP*Point()*mtp, Digits()));
      return;
   }
}

void TralOrders(){
   bool t = false;
   double level  = 0.0;
   for(int i = OrdersTotal()-1; i >= 0; i--){
      t = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUYSTOP){
            level = NormalizeDouble(iMA(Symbol(), period, MAperiod, 0,  MODE_EMA, PRICE_CLOSE, 1), Digits());
            if(OrderOpenPrice() > level){
               t = OrderModify(OrderTicket(), level, NormalizeDouble(level - SL*Point()*mtp, Digits()), NormalizeDouble(level + TP*Point()*mtp, Digits()), OrderExpiration());
               //Print("Buy mod");
            }
         }
         if(OrderType() == OP_SELLSTOP){
            level = NormalizeDouble(iMA(Symbol(), period, MAperiod, 0,  MODE_EMA, PRICE_CLOSE, 1), Digits());
            if( OrderOpenPrice() < level){
               t = OrderModify(OrderTicket(), level, NormalizeDouble(level + SL*Point()*mtp, Digits()), NormalizeDouble(level - TP*Point()*mtp, Digits()), OrderExpiration());
               //Print("Sell mod");
            }
         //Print("Sell sl: ",OrderStopLoss(),"   Sell tp: ",OrderTakeProfit());
         }
      }
   }   
}

void BuildGrid(){
   int type = -1;
   double price = 0.0;
   for(int i = OrdersTotal() - 1; i>=0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         type = OrderType();
         price = OrderOpenPrice();
         
         if((Bid < OrderOpenPrice() && Bid > NormalizeDouble(OrderOpenPrice()-iATR(Symbol(), PERIOD_D1, 14, 1)/*offset*mtp*Point()*/, Digits())) ||
            (Bid > OrderOpenPrice() && Bid < NormalizeDouble(OrderOpenPrice()+iATR(Symbol(), PERIOD_D1, 14, 1)/*offset*mtp*Point()*/, Digits())) ||
            (Ask < OrderOpenPrice() && Ask > NormalizeDouble(OrderOpenPrice()-iATR(Symbol(), PERIOD_D1, 14, 1)/*offset*mtp*Point()*/, Digits())) ||
            (Ask > OrderOpenPrice() && Ask < NormalizeDouble(OrderOpenPrice()+iATR(Symbol(), PERIOD_D1, 14, 1)/*offset*mtp*Point()*/, Digits()))){
               //Print(iATR(Symbol(), PERIOD_D1, 14, 1));
            return;
         }
      }
   }
   //Print("Try build");
   MqlRates D1Rates[];
   MqlRates H1Rates[];
   MqlRates M15Rates[];
   MqlRates MN1Rates[];
   
   RefreshRates();
   CopyRates(Symbol(), PERIOD_D1,  0, 3, D1Rates);
   CopyRates(Symbol(), PERIOD_H1,  0, 3, H1Rates);
   CopyRates(Symbol(), PERIOD_M15, 0, 3, M15Rates);
   CopyRates(Symbol(), PERIOD_MN1, 1, 1, MN1Rates);
   
   ArraySetAsSeries(D1Rates,  true);
   ArraySetAsSeries(H1Rates,  true);
   ArraySetAsSeries(M15Rates, true);
   ArraySetAsSeries(MN1Rates, true);
   
   if(ArraySize(D1Rates)<3 || ArraySize(H1Rates)<3 || ArraySize(M15Rates)<3 || ArraySize(MN1Rates)<1)return;
   if(type == 0 && 
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)<Bid &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)<D1Rates[0].low  &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 1)<D1Rates[1].low  &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 2)<D1Rates[2].low  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)<H1Rates[0].low  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 1)<H1Rates[1].low  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 2)<H1Rates[2].low  &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)<M15Rates[0].low &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)<M15Rates[1].low &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 2)<M15Rates[2].low &&
      iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1)>50){
      //if(Ask > iMA(Symbol(), PERIOD_MN1, 50, 0, MODE_EMA, PRICE_CLOSE, 1))//High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-(High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-Low[iLowest(Symbol(), PERIOD_MN1, MODE_LOW, 4, 0)])/2)
         //if(price != 0.0 && Ask < price - iATR(Symbol(), PERIOD_D1, 14, 1))
            trade.Buy(Symbol(), AutoLot(), 0, 0);
      }
   else if(type == 1 && 
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)>Ask &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 0)>D1Rates[0].high  &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 1)>D1Rates[1].high  &&
      iMA(Symbol(), PERIOD_D1,  12, 0, MODE_EMA, PRICE_CLOSE, 2)>D1Rates[2].high  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 0)>H1Rates[0].high  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 1)>H1Rates[1].high  &&
      iMA(Symbol(), PERIOD_H1,  8,  0, MODE_EMA, PRICE_CLOSE, 2)>H1Rates[2].high  &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 0)>M15Rates[0].high &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)>M15Rates[1].high &&
      iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 2)>M15Rates[2].high &&
      iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1)<50){
      //if(Bid < iMA(Symbol(), PERIOD_MN1, 50, 0, MODE_EMA, PRICE_CLOSE, 1))//High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-(High[iHighest(Symbol(), PERIOD_MN1, MODE_HIGH, 4, 0)]-Low[iLowest(Symbol(), PERIOD_MN1, MODE_LOW, 4, 0)])/2)
         //if(price != 0.0 && Bid > price + iATR(Symbol(), PERIOD_D1, 14, 1))
         trade.Sell(Symbol(), AutoLot(), 0, 0);
      }
   /*int buy = Total(0);
   int sell = Total(1);
   
   if(buy > 0 && MN1Rates[0].high < iMA(Symbol(), PERIOD_MN1, 50, 0, MODE_EMA, PRICE_CLOSE, 1))trade.CloseBuy();
   if(sell > 0 && MN1Rates[0].low > iMA(Symbol(), PERIOD_MN1, 50, 0, MODE_EMA, PRICE_CLOSE, 1))trade.CloseSell();*/
}

void TakeProfit(){
   double p = 0.0;
   int    type = -1;
   for(int i = OrdersTotal()-1; i>=0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         p += OrderSwap()+OrderCommission()+OrderProfit();
         type = OrderType();
      }
   }
   if(p > 0.0){
      if((type == 0) && (iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1) < 40) && (iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)<Low[1]) ||
         (type == 1) && (iRSI(Symbol(), PERIOD_M5, 8, PRICE_CLOSE, 1) > 60) && (iMA(Symbol(), PERIOD_M15, 20, 0, MODE_EMA, PRICE_CLOSE, 1)>High[1]))
         trade.CloseTrades();
   }
}

short Total(short t = -1){
   if(OrdersTotal() == 0)
      return 0;
   bool x = false;
   short count = 0;
   for(int i = OrdersTotal() - 1; i>= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(t == -1 || OrderType() == t)count++;
      }
   }
   return count;
}


double AutoLot(){
   double Free =AccountFreeMargin();
   double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
   double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
   double Lot = Free/100000;
   if (Lot<Min_Lot) Lot=Min_Lot;
   if (Lot>Max_Lot) Lot=Max_Lot;
   return Lot;
}
