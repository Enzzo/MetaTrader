//+------------------------------------------------------------------+
//|                                                       BLADER.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

enum Type{
   mrkt, //рыночные
   stps  //стоповые
};

enum Mode{
   on,   //вкл.
   off   //выкл.
};

enum Profits{
   general,    //общий
   directional,//в одном направлении
   current     //отдельно для ордера
};

input string   comment1             = "     ОБЩИЕ НАСТРОЙКИ";        //.
input int      magic                = 23478978;                      //Магик
input string   comment2             = "ВХОД";                        //.
input int      rsi_top              = 70;                            //RSI TOP
input int      rsi_bottom           = 30;                            //RSI BOTTOM
input int      rsi_period           = 18;                            //RSI PERIOD
input Type     type                 = stps;                          //Типы ордеров
input int      distance             = 70;                            //Дистанция стоповых ордеров (pips)
input int      stepOrders           = 20;                            //Шаг трала отложки (pips)
input string   comment3             = "ТОРГОВЛЯ И МАНИ-МЕНЕДЖМЕНТ";  //.
input double   volume               = 0.01;                          //Размер лота
input double   lotExp               = 2.0;                           //Множитель лотности для последующих колен
input int      pipStepInit          = 30;                            //Шаг выставления колена (pips)
input double   pipStepExp           = .9;                            //Коэффициент размера шага
input int      pipStepDynamicStart  = 3;                             //Номер колена
input double   TP                   = 10.0;                          //Тейкпрофит ($)
input int      SL                   = 10;                            //Стоплос (pips)
input bool     reverse              = true;                          //Реверс
input Profits  profitType           = general;                       //Тип профита
input string   comment4             = "     БЕЗУБЫТОК И ТРАЛ";       //.
input double   bu                   = 10.0;                          //Безубыток (0 - выкл)
input bool     trailing             = true;                          //Трал
input int      tralStart            = 10;                            //Старт трала (pips)
input int      tralPips             = 5;                             //Значение трала (pips)
input int      tralStep             = 5;                             //Шаг трала (pips)
input string   comment5             = "        ВЫКЛЮЧЕНИЕ";          //.
input Mode     mode                 = 0;                             //Работа     

int mtp;
string botName = "BLADER";

int OnInit(){
   trade.SetExpertMagic(magic);   
   mtp = 1;if(Digits() == 5 || Digits() == 3)mtp = 10;
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
   
}

void OnTick(){
   if(pipStepExp >= 1.0){
      Comment("Значение параметра pipStepExp должно быть положительным и меньше единицы.");
   }
   if(mode == on)Start();
   Continue();
   //TakeProfit()
}

int Signal(){
   if(iRSI(Symbol(), PERIOD_CURRENT, rsi_period, PRICE_CLOSE, 1) < rsi_bottom)return 1;
   if(iRSI(Symbol(), PERIOD_CURRENT, rsi_period, PRICE_CLOSE, 1) > rsi_top)   return 0;
   return -1;
}

void Start(){
   int s = Signal();
   switch(s){
      case 0:  
         if(reverse){trade.CloseSell();trade.DeleteType(OP_SELLSTOP);}
         if(type == mrkt && Total(OP_BUY) == 0)trade.Buy(Symbol(), volume, 0.0, 0.0, botName);
         else if(type == stps && Total(OP_BUYSTOP) == 0 && Total(OP_BUY) == 0)trade.BuyStop(Symbol(), volume, NormalizeDouble(Ask + distance*mtp*Point(), Digits()), 0.0, 0.0, botName);
         break;
      case 1:
         if(reverse){trade.CloseBuy(); trade.DeleteType(OP_BUYSTOP);}
         if(type == mrkt && Total(OP_SELL) == 0)trade.Sell(Symbol(), volume, 0.0, 0.0, botName);
         else if(type == stps && Total(OP_SELLSTOP) == 0 && Total(OP_SELL) == 0)trade.SellStop(Symbol(), volume, NormalizeDouble(Bid - distance*mtp*Point(), Digits()), 0.0, 0.0, botName);
         break;
   }
}

void Continue(){
   TralOrders();
   for(ushort i = 0; i < 1; i++){
      BuildGrid(i);
      switch(profitType){
         case 0:TakeProfitGeneral();break;
         case 1:TakeProfitDirectional(i);break;
         case 2:TakeProfit();break;
      }      
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

void TralOrders(){
   if(OrdersTotal() == 0)
      return;
   bool x = false;
   
   if(Total(OP_BUYSTOP) == 1){
      for(int i = OrdersTotal() - 1; i >= 0; i--){
         x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == OP_BUYSTOP){
            if(OrderOpenPrice() > NormalizeDouble(Ask + stepOrders * mtp * Point() + distance * mtp * Point(), Digits()))
               x = OrderModify(OrderTicket(), NormalizeDouble(Ask+distance*mtp*Point(), Digits()), SL == 0 ? 0.0 : NormalizeDouble(Ask+distance*mtp*Point()-SL*mtp*Point(), Digits()), 0.0/*TP == 0 ? 0.0 : NormalizeDouble(Ask + distance*mtp*Point() + TP*mtp*Point(), Digits())*/, OrderExpiration());
         }
      }
   }
   
   if(Total(OP_SELLSTOP) == 1){
      for(int i = OrdersTotal() - 1; i >= 0; i--){
         x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == OP_SELLSTOP){
            if(OrderOpenPrice() < NormalizeDouble(Bid - stepOrders * mtp * Point() - distance * mtp * Point(), Digits()))
               x = OrderModify(OrderTicket(), NormalizeDouble(Bid-distance*mtp*Point(), Digits()), SL == 0 ? 0.0 : NormalizeDouble(Bid- distance*mtp*Point()+SL*mtp*Point(), Digits()), 0.0/*TP == 0 ? 0.0 : NormalizeDouble(Bid - distance*mtp*Point() - TP*mtp*Point(), Digits())*/, OrderExpiration());
         }
      }
   }  
}

void BuildGrid(ushort i){
   if(OrdersTotal() == 0)
      return;
   
   if(type == stps){
      switch(i){
         case 0:if(Total(OP_BUYSTOP)  > 0)return;break;
         case 1:if(Total(OP_SELLSTOP) > 0)return;break;
      }
   }
   
   double price = 0.0;
   bool x = false;
   for(int j = OrdersTotal() - 1; j >= 0; j--){
      x = OrderSelect(j, SELECT_BY_POS);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && OrderType() == i){
         if(type == mrkt){
            if(OrderType() == OP_BUY){
               if(Ask < (OrderOpenPrice() - NormalizeDouble(pipStepInit*pipStepExp*mtp*Point(), Digits())))trade.Buy(Symbol(), OrderLots(), 0.0, 0.0, botName);
               //return;         
            }
            if(OrderType() == OP_SELL){
               if(Bid > (OrderOpenPrice() + NormalizeDouble(pipStepInit*pipStepExp*mtp*Point(), Digits())))trade.Sell(Symbol(), OrderLots(), 0.0, 0.0, botName);
               //return;
            }    
            //return;        
         }
         else if(type == stps){
            if(OrderType() == OP_BUY){
               if(Ask < (OrderOpenPrice() - NormalizeDouble(pipStepInit*mtp*Point(), Digits())))trade.BuyStop(Symbol(), OrderLots(), OrderOpenPrice() - NormalizeDouble(pipStepInit*pipStepExp*mtp*Point(), Digits()), 0.0, 0.0, botName);
               //return;         
            }
            if(OrderType() == OP_SELL){
               if(Bid > (OrderOpenPrice() + NormalizeDouble(pipStepInit*mtp*Point(), Digits())))trade.SellStop(Symbol(), OrderLots(), OrderOpenPrice() + NormalizeDouble(pipStepInit*pipStepExp*mtp*Point(), Digits()), 0.0, 0.0, botName);
               //return;
            } 
            //return;
         }
         return;
      }
   }
}

void TakeProfitGeneral(){
   if(OrdersTotal() == 0)
      return;
   double profit = 0.0;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()/* && OrderType() == j*/){
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
      }
   }
   if(profit >= TP && profit != 0.0){
      trade.CloseTrades();
      trade.DeletePendings();
   }
}

void TakeProfitDirectional(ushort j){
   if(OrdersTotal() == 0)
      return;
   double profit = 0.0;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == j){
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
      }
   }
   if(profit >= TP && profit != 0.0){
      switch(j){
         case 0:
            trade.CloseBuy();
            trade.DeleteType(OP_BUYSTOP);
            break;
         case 1:
            trade.CloseSell();
            trade.DeleteType(OP_SELLSTOP);
            break;
      }
   }
}

void TakeProfit(){
   if(OrdersTotal() == 0)
      return;
   double profit = 0.0;
   bool x = false;
   for(int i = OrdersTotal() - 1; i >= 0; i--){
      x = OrderSelect(i, SELECT_BY_POS);
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
         if(profit >= TP && profit != 0.0){
            
            if(OrderType() == 0){
               x = OrderClose(OrderTicket(), OrderLots(), Bid, 5);
               trade.DeleteType(OP_BUYSTOP);
            }
            if(OrderType() == 1){
               x = OrderClose(OrderTicket(), OrderLots(), Ask, 5);
               trade.DeleteType(OP_SELLSTOP);
            }
         }
      }
   }
}