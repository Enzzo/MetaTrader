//+------------------------------------------------------------------+
//|                                                 QuantumLimit.mq4 |
//|                                              Copyright 2017, AM2 |
//|                                      http://www.forexsystems.biz |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, AM2"
#property link      "http://www.forexsystems.biz"
#property version   "1.00"
#property strict

//--- Inputs

extern double Lot1       = 0.01;     // лот
extern double Lot2       = 0.02;     // лот
extern double Lot3       = 0.05;     // лот
extern double Lot4       = 0.13;     // лот
extern double Lot5       = 0.34;     // лот
extern double Lot6       = 0.89;     // лот

extern int Count1        = 12;       // число ордеров 1
extern int Count2        = 21;       // число ордеров 2
extern int Count3        = 29;       // число ордеров 3
extern int Count4        = 36;       // число ордеров 4
extern int Count5        = 39;       // число ордеров 5
extern int Count6        = 40;       // число ордеров 6

extern int StopLoss      = 2000;     // лось
extern int TakeProfit    = 3000;     // язь
extern int Delta         = 100;      // расстояние от цены
extern int Profit        = 30;       // язь в валюте 
extern int Expiration    = 30;       // истечение ордера в часах

extern int StartHour     = 0;        // час начала торговли
extern int StartMin      = 30;       // минута начала торговли
extern int EndHour       = 23;       // час окончания торговли
extern int EndMin        = 30;       // минута окончания торговли

extern int Step          = 200;      // шаг
extern int Slip          = 30;       // реквот
extern int Shift         = 1;        // на каком баре сигнал индикатора
extern int Magic         = 123;      // магик
extern string IndName    = "Quantum";
extern int Depth         = 300;      // настройка Quantum

//----
datetime t=0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   t=Time[0];
   Comment("");
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int CountTrades(int type=-1)
  {
   int count=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
           {
            if(OrderType()==type || type==-1) count++;
           }
        }
     }
   return(count);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool isTradeTimeInt(int hb=0,int mb=0,int he=0,int me=0)
  {
   datetime db, de;           // Время начала и окончания работы
   int      hc;               // Часы текущего времени торгового сервера

   db=StrToTime(TimeToStr(TimeCurrent(), TIME_DATE)+" "+(string)hb+":"+(string)mb);
   de=StrToTime(TimeToStr(TimeCurrent(), TIME_DATE)+" "+(string)he+":"+(string)me);
   hc=TimeHour(TimeCurrent());

   if(db>=de)
     {
      if(hc>=he) de+=24*60*60; else db-=24*60*60;
     }

   if(TimeCurrent()>=db && TimeCurrent()<=de) return(True);
   else return(False);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OOP(int type)
  {
   double oop=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
           {
            if(OrderType()==type) oop=OrderOpenPrice();
            break;
           }
        }
     }
   return(oop);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ModifyOrders()
  {
   double all=0;
   double count=0,tp=0,sl=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
           {
            if(OrderType()==OP_BUY || OrderType()==OP_SELL)
              {
               all+=OrderOpenPrice()*OrderLots();
               count+=OrderLots();
              }
           }
        }
     }
   if(count>0) all=NormalizeDouble(all/count,Digits);

   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
           {
            if(OrderType()==OP_BUY)
              {
               tp=NormalizeDouble(all+TakeProfit*Point,Digits);
               sl=NormalizeDouble(all-StopLoss*Point,Digits);
               if(OrderStopLoss()!=sl && OrderTakeProfit()!=tp)
                  bool mod=OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Yellow);

              }
            else
            if(OrderType()==OP_SELL)
              {
               tp=NormalizeDouble(all-TakeProfit*Point,Digits);
               sl=NormalizeDouble(all+StopLoss*Point,Digits);
               if(OrderStopLoss()!=sl && OrderTakeProfit()!=tp)
               bool mod=OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0,Yellow);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Lot(int type)
  {
   double lot=Lot1;/**/ 
   if(CountTrades(type)<1)lot=Lot1;
   if(CountTrades(type)>Count1)lot=Lot2;
   if(CountTrades(type)>Count2)lot=Lot3;
   if(CountTrades(type)>Count3)lot=Lot3;
   if(CountTrades(type)>Count4)lot=Lot4;
   if(CountTrades(type)>Count5)lot=Lot5;
   if(CountTrades(type)>Count6)lot=Lot6;

   return(lot);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double AllProfit(int type=-1)
  {
   double profit=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
           {
            if(OrderType()==type) profit+=OrderProfit()+OrderCommission()+OrderSwap();
            if(type==-1)
              {
               if(OrderType()<2) profit+=OrderProfit()+OrderCommission()+OrderSwap();
              }
           }
        }
     }
   return (profit);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PutOrder(int type,double price)
  {
   int r=0;
   color clr=Green;
   double sl=0,tp=0,lot=Lot1;

   if(type==1 || type==3 || type==5)
     {
      clr=Red;
      if(StopLoss>0) sl=NormalizeDouble(price+StopLoss*Point,Digits);
      if(TakeProfit>0) tp=NormalizeDouble(price-TakeProfit*Point,Digits);
      if(type==3) lot=Lot(1);
     }

   if(type==0 || type==2 || type==4)
     {
      clr=Blue;
      if(StopLoss>0) sl=NormalizeDouble(price-StopLoss*Point,Digits);
      if(TakeProfit>0) tp=NormalizeDouble(price+TakeProfit*Point,Digits);
      if(type==2) lot=Lot(0);
     }

   r=OrderSend(NULL,type,lot,NormalizeDouble(price,Digits),Slip,sl,tp,"",Magic,TimeCurrent()+Expiration*3600,clr);
   return;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClosePos(int ot=-1)
  {
   bool cl;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
        {
         if(OrderSymbol()==Symbol() && OrderMagicNumber()==Magic)
           {
            if(OrderType()==0 && (ot==0 || ot==-1))
              {
               RefreshRates();
               cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Bid,Digits),Slip,White);
              }
            if(OrderType()==1 && (ot==1 || ot==-1))
              {
               RefreshRates();
               cl=OrderClose(OrderTicket(),OrderLots(),NormalizeDouble(Ask,Digits),Slip,White);
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| OnTick function                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   double red=iCustom(NULL,0,IndName,Depth,1,Shift);
   double blue=iCustom(NULL,0,IndName,Depth,0,Shift);

   if(t!=Time[0] && isTradeTimeInt(StartHour,StartMin,EndHour,EndMin))
     {
      if((CountTrades()<1 && red>0) || (CountTrades()>0 && red>0 && Bid-OOP(1)>Step*Point))
        {
         PutOrder(3,Bid+Delta*Point);
        }

      if((CountTrades()<1 && blue>0) || (CountTrades()>0 && blue>0 && OOP(0)-Bid>Step*Point))
        {
         PutOrder(2,Bid-Delta*Point);
        }
      t=Time[0];
     }

   ModifyOrders();
   if(AllProfit()>Profit && Profit>0) ClosePos();

   Comment("\n Red: ",red,
           "\n Blue: ",blue,
           "\n Profit: ",AllProfit(),
           "\n All Positions: ",CountTrades(),
           "\n Buy Positions: ",CountTrades(0),
           "\n Sell Positions: ",CountTrades(1),
           "\n Buy Lot: ",Lot(0),
           "\n Sell Lot: ",Lot(1),
           "\n Last Buy Open Price: ",OOP(0),
           "\n Last Sell Open Price: ",OOP(1));
  }
//+------------------------------------------------------------------+
