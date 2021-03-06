//+------------------------------------------------------------------+
//|                                               FrakTrak XonaX.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//--- input parameters
input ENUM_TIMEFRAMES Tfr=240;        //TimeFrame
input double   Lots=0.01;     //Lots size
input int      Tprof=1000;     //TakeProfit
input int      TreilSt=100;    //Trailing Stop
input int      TrStKor=10;     //The size of the correction Trailing Stop
input int      Magik=1001012;  //Magic Number
input ushort   count=5;          //Количество свечей фрактала
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   if((count % 2) == 0){
      Alert(Symbol()," количество баров для рассчета фрактала должно быть нечетным и больше нуля");
      return 0.0;
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
void OnTick()
  {
//---
   static double Upf,Lowf;
   double Tupf=0.0,Tlowf=0.0;
   int i,k;
   for(i=1; i<100; i++)
     {
      //Tupf=/*iFractals(Symbol(),Tfr,MODE_UPPER,i);*/ 
      Tupf = Fractal(MODE_UPPER, count, i);
      if(Tupf>0.0)
         break;
     }
   for(k=1; k<100; k++)
     {
      //Tlowf=/*iFractals(Symbol(),Tfr,MODE_LOWER,k);*/
      Tlowf = Fractal(MODE_LOWER, count, k);
      if(Tlowf>0.0)
         break;
     }
//----Open position
//if(i>0) Print("i = ", i, " k = ",k);
   int total=OrdersTotal();
/*if(total<1)
      {*/
   if(Ask>Tupf/*+15*_Point*/ && Tupf!=Upf)
     {
      double StL=0.0;//NormalizeDouble(Tlowf,_Digits);
      int ticket=OrderSend(NULL,OP_BUY,Lots,Ask,30,StL,Bid+Tprof*_Point,NULL,Magik,0,clrBlue);
      if(ticket<0)
        {
         Print("OrderSend error #",GetLastError());
        }
      else {Print("Ask=",Ask,"Upf=",Upf," StL=",StL); Upf=Tupf;}
     }
   if(Bid<Tlowf/*-15*_Point*/ && Tlowf!=Lowf)
     {
      double StL=NormalizeDouble(Tupf,_Digits);
      int ticket=OrderSend(NULL,OP_SELL,Lots,Bid,30,StL,Ask-Tprof*_Point,NULL,Magik,0,clrRed);
      if(ticket<0)
        {
         Print("OrderSend error #",GetLastError());
        }
      else {Print("Bid=",Bid,"Lowf=",Lowf," StL=",StL);   Lowf=Tlowf;}
     }
// }
//----Trailing Stop operation
   for(int cni=0;cni<total;cni++)
     {
      if(!OrderSelect(cni,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderMagicNumber()==Magik && TreilSt>0)
        {
         if(OrderType()==OP_BUY)
           {
            if(Bid-OrderOpenPrice()>_Point*TreilSt)
              {
               if(OrderStopLoss()<Bid-_Point*TreilSt-TrStKor*_Point)
                 {
                  //--- modify order and exit
                  if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-_Point*TreilSt,OrderTakeProfit(),0,clrBlue))
                     Print("OrderModify error ",GetLastError());
                  return;
                 }
              }
           }
         if(OrderType()==OP_SELL)
           {
            if((OrderOpenPrice()-Ask)>_Point*TreilSt)
              {
               if(OrderStopLoss()>Ask+_Point*TreilSt+_Point*TrStKor)
                 {
                  //--- modify order and exit
                  if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TreilSt,OrderTakeProfit(),0,clrRed))
                     Print("OrderModify error ",GetLastError());
                  return;
                 }
              }
           }
        }
     }
  }

//md - режим (1 - UPPER, 2 - LOWER)
//cnt - количество свечей для рассчета
//shft - сдвиг
double Fractal(ushort md, ushort cnt = 5, int shft = 0){
   if(Bars < cnt+shft)
      return 0.0;
      
   MqlRates rates[];
   RefreshRates();
   CopyRates(Symbol(), Tfr, shft, cnt, rates);
   if(ArraySize(rates)<cnt)
      return 0.0;
   double fractal = 0.0;
   uint n = 0;
   double max = 0.0;
   double min = 0.0;
   switch(md){
      case 1:
         for(int i = 0; i < cnt-1; i++){
            if(max < rates[i].high){
               max = rates[i].high;
               n = i;
            }
         }
         if(n == (cnt-1)/2)fractal = max;         
      break;
      case 2:
         for(int i = 0; i < cnt-1; i++){
            if(min == 0.0 || min > rates[i].low){
               min = rates[i].low;
               n = i;
            }
         }
         if(n == (cnt-1)/2)fractal = min;
      break;
   }   
   return fractal;
}
//+------------------------------------------------------------------+
