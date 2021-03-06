//+------------------------------------------------------------------+
//|                                                         Grid.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

enum cents{
   _1 = 1,  //  1%
   _2,      //  2%
   _3,      //  3%
   _4,      //  4%
   _5,      //  5%
   _6,      //  6%
   _7,      //  7%
   _8,      //  8%
   _9,      //  9%
   _10,     // 10%
   _11,     // 11%
   _12,     // 12%
   _13,     // 13%
   _14,     // 14%
   _15,     // 15%
   _16,     // 16%
   _17,     // 17%
   _18,     // 18%
   _19,     // 19%
   _20,     // 20%
   _21,     // 21%
   _22,     // 22%
   _23,     // 23%
   _24,     // 24%
   _25,     // 25%
   _26,     // 26%
   _27,     // 27%
   _28,     // 28%
   _29,     // 29%
   _30,     // 30%
   _31,     // 31%
   _32,     // 32%
   _33,     // 33%
   _34,     // 34%
   _35,     // 35%
   _36,     // 36%
   _37,     // 37%
   _38,     // 38%
   _39,     // 39%
   _40,     // 40%
   _41,     // 41%
   _42,     // 42%
   _43,     // 43%
   _44,     // 44%
   _45,     // 45%
   _46,     // 46%
   _47,     // 47%
   _48,     // 48%
   _49,     // 49%
   _50,     // 50%
   _51,     // 51%
   _52,     // 52%
   _53,     // 53%
   _54,     // 54%
   _55,     // 55%
   _56,     // 56%
   _57,     // 57%
   _58,     // 58%
   _59,     // 59%
   _60,     // 60%
   _61,     // 61%
   _62,     // 62%
   _63,     // 63%
   _64,     // 64%
   _65,     // 65%
   _66,     // 66%
   _67,     // 67%
   _68,     // 68%
   _69,     // 69%
   _70,     // 70%
   _71,     // 71%
   _72,     // 72%
   _73,     // 73%
   _74,     // 74%
   _75,     // 75%
   _76,     // 76%
   _77,     // 77%
   _78,     // 78%
   _79,     // 79%
   _80,     // 80%
   _81,     // 81%
   _82,     // 82%
   _83,     // 83%
   _84,     // 84%
   _85,     // 85%
   _86,     // 86%
   _87,     // 87%
   _88,     // 88%
   _89,     // 89%
   _90,     // 90%
   _91,     // 91%
   _92,     // 92%
   _93,     // 93%
   _94,     // 94%
   _95,     // 95%
   _96,     // 96%
   _97,     // 97%
   _98,     // 98%
   _99,     // 99%
   _100     //100%
};
enum lotTypes{
   fixedLot,   //фиксированный
   autoLot     //автоматический
};
enum gridTypes{
   fixedGrid,  //фиксированная
   autoGrid    //по ATR
};
enum sgnls{
   gnrl,       //в совокупности
   indp        //независимо друг от друга
};

input string            comment0    = "ОБЩИЕ НАСТРОЙКИ";//.
input int               magic       = 53124312;       //magic
input ENUM_TIMEFRAMES   tf          = PERIOD_CURRENT; //Timeframe
input bool              onTrend     = true;           //работать по тренду
input sgnls             sgnl        = gnrl;           //использовать сигналы

input string            comment1    = "НАСТРОЙКИ ТРАЛА";//.
input bool              useTral     = true;           //Трал первого ордера, если не открыта сетка
input int               step        = 10;             //
input int               stop        = 100;            //

input string            comment2    = "НАСТРОЙКИ ОБЪЕМА СДЕЛКИ";//.
input lotTypes          lotType     = autoLot;        //лот
input double            lot         = 0.01;           //объем
input cents             risk        = 3;              //risk(%)

input string            comment3    = "НАСТРОЙКИ СЕТКИ";//.
input gridTypes         gridType    = autoGrid;       //сетка
input int               grid        = 30;             //сетка (п)
input double            k           = 1.0;            //множитель автоматической сетки
input int               maxOrders   = 10;             //максимальное количество ордеров в одном направлении
input double            prof        = 0.1;            //выход из сетки ($)

input string            comment4    = "НАСТРОЙКИ MA";//.
input bool              useMA       = true;           //Использовать МА
input int               MA1_period  = 10;
input int               MA2_period  = 50;
input int               MA3_period  = 200;

input string            comment5    = "НАСТРОЙКИ Stochastic";//.
input bool              useStoch    = true;           //Использовать Stochastic
input int               Stochastic_period=30;
input int               stL2        = 80;             //верхний уровень
input int               stL1        = 20;             //нижний уровень

input string            comment6    = "НАСТРОЙКИ CCI";//.
input bool              useCCI      = true;           //Использовать CCI
input int               CCI_period  = 50;
input int               cciL2       = 100;             //верхний уровень
input int               cciL1       = -100;            //нижний уровень

input string            comment7    = "НАСТРОЙКИ RSI";//.
input bool              useRSI      = true;           //Использовать RSI
input int               RSI_period  = 14;
input int               rsiL2       = 80;             //верхний уровень
input int               rsiL1       = 20;             //нижний уровень

ushort mtp;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
   trade.SetExpertMagic(magic);
   trade.SetExpertComment(WindowExpertName());
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;   
   
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick(){
   for(short i = 0; i < 2; i++){
      if(Total(i)==0)Start(i);
      else{
         if(Total(i) < maxOrders)BuildGrid(i);
         TakeProfit(i);
         if(useTral)Tral(i);
      }
   }  
}

//---> Количество ордеров, выставленных экспертом на символе
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

void Start(int cmd = -1){   
   short d = Signal(cmd);   
   if(d == cmd){
      switch(d){
         case 0:if(onTrend)trade.Buy (Symbol(), AutoLot(), 0, 0);
                else       trade.Sell(Symbol(), AutoLot(), 0, 0);
                return;
         case 1:if(onTrend)trade.Sell(Symbol(), AutoLot(), 0, 0);
                else       trade.Buy (Symbol(), AutoLot(), 0, 0);
                return;
      }
   }
}

//+---------------------------------------------------------------------+
//|   TakeProfit()
//|   Имитирует тейкпрофит.
//|   
void TakeProfit(short dir = -1){
   double _lot = 0.0;
   double profit = 0.0;
   if(Total(/*dir*/) == 1)
      return;
   
   for(int i = OrdersTotal()-1; i >= 0; i--){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ",GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()/* && OrderType() == dir*/){
         if(_lot == 0.0)_lot = OrderLots();
         profit += (OrderProfit() + OrderSwap() + OrderCommission());
      }
      
   }
   if(profit > prof*lot/MarketInfo(Symbol(), MODE_MINLOT))
      CloseAllGrid(/*dir*/);
}

//+---------------------------------------------------------------------+
//|   CloseAllGrid()
//|   Закрывает все ордера.
//|   Вызывается при помощи функции TakeProfit()
void CloseAllGrid(short dir = -1){
   switch(dir){
      case 0:trade.CloseBuy();return;
      case 1:trade.CloseSell();return;
      default:trade.CloseTrades();return;
   }
}
//+---------------------------------------------------------------------+
//|   GainedLevel()
//|   Если достигнут уровень, то можно выставлять ордер.
//|   Перебираем с последних выставленных ордеров (задом наперед)

void BuildGrid(int dir = -1){

   for(int i = OrdersTotal() - 1; i >= 0; i--){
      bool x = OrderSelect(i, SELECT_BY_POS);
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
         if(dir == OP_BUY){
            if(Ask < (OrderOpenPrice() - Grid())){
               trade.Buy(Symbol(), OrderLots(), 0, 0);               
            }
            return;
         }
         if(dir == OP_SELL){
            if(Bid > (OrderOpenPrice() + Grid())){
               trade.Sell(Symbol(), OrderLots(), 0, 0);
            }
            return;
         }
         return;
      }
   }
}

short Signal(int cmd = -1){
   //double ema1,ema2,sto1, sto2, sto3, cci1, cci2, cci3, rsi1, rsi2, rsi3, macd, macds, ema3;
   double ma1=iMA(Symbol(),NULL,MA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   double ma2=iMA(Symbol(),NULL,MA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   double ma3=iMA(Symbol(),NULL,MA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   
   double sto1 =iStochastic(Symbol(),NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);   
   double sto2 =iStochastic(Symbol(),NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,1); 
   double sto3 =iStochastic(Symbol(),NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,2);
   
   double cci1 =iCCI(Symbol(),NULL,CCI_period,PRICE_CLOSE,0); 
   double cci2 =iCCI(Symbol(),NULL,CCI_period,PRICE_CLOSE,1); 
   double cci3 =iCCI(Symbol(),NULL,CCI_period,PRICE_CLOSE,2);
   
   double rsi1 =iRSI(Symbol(),NULL,RSI_period,PRICE_CLOSE,0); 
   double rsi2 =iRSI(Symbol(),NULL,RSI_period,PRICE_CLOSE,1); 
   double rsi3 =iRSI(Symbol(),NULL,RSI_period,PRICE_CLOSE,2);
   
   ushort buy     = 0;
   ushort sell    = 0;
   ushort signals = 0;
   
   if(useMA){
      signals++;
      if (ma1>ma2 && ma1>ma3 && ma2>ma3) buy++; 
      if (ma1<ma2 && ma1<ma3 && ma2<ma3)sell++; 
   }
   if(useStoch){
      signals++;
      if ( sto1 > stL2 && sto2 > stL2 && sto3 > stL2)buy++;
      if ( sto1 < stL1 && sto2 < stL1 && sto3 < stL1)sell++;     
   }
   if(useCCI){
      signals++;
      if ( cci1 > cciL2 && cci2 > cciL2 && cci3 > cciL2)buy++;
      if ( cci1 < cciL1 && cci2 < cciL1 && cci3 < cciL1) sell++;
   }
   if(useRSI){      
      signals++;
      if ( rsi1 > rsiL2 && rsi2 > rsiL2 && rsi3 > rsiL2)buy++; 
      if ( rsi1 < rsiL1 && rsi2 < rsiL1 && rsi3 < rsiL1)sell++;
   }
   if(buy != 0 && ((sgnl == gnrl && buy == signals) || (sgnl == indp)) && cmd == 0){
      return 0;
   }
   if(sell != 0 && ((sgnl == gnrl && sell == signals) || (sgnl == indp)) && cmd == 1){
      return 1;
   }      
   return -1;
}

double AutoLot(){
   double Free =AccountFreeMargin();
   double One_Lot =MarketInfo(Symbol(),MODE_MARGINREQUIRED);
   double Step =MarketInfo(Symbol(),MODE_LOTSTEP);
   double Min_Lot =MarketInfo(Symbol(),MODE_MINLOT);
   double Max_Lot =MarketInfo(Symbol(),MODE_MAXLOT);
   double Lot = lotType == autoLot?MathFloor(Free*risk/100/One_Lot/Step)*Step:lot;
   if (Lot<Min_Lot) Lot=Min_Lot;
   if (Lot>Max_Lot) Lot=Max_Lot;
   /*
   if(OrdersHistoryTotal() > 0 && useMrtn){
      for(int i = OrdersHistoryTotal() - 1; i >= 0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS, MODE_HISTORY);
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic){
            if(OrderProfit() < 0.0){
               double modLot = OrderLots()*k;
               if(modLot<Min_Lot) modLot=Min_Lot;
               if(modLot>Max_Lot) modLot=Max_Lot;
               if(AccountFreeMarginCheck(Symbol(), OrderType()==OP_BUY?OP_SELL:OP_BUY, modLot) <= 0.0)return Lot;
               else return modLot;
            }
            else return Lot;
         }         
      }
   }*/
   return Lot;
}

double Grid(){
   if(gridType == fixedGrid) return NormalizeDouble(grid*mtp*Point(), Digits());
   else return iATR(Symbol(), PERIOD_CURRENT, 14, 1)*k;
}


void Tral(int dir = -1){
   if(OrdersTotal() > 0){
      int count = 0;
      int ticket = 0;
      double profit = 0.0;
      for(int i = OrdersTotal()-1; i>=0; i--){
         bool x = OrderSelect(i, SELECT_BY_POS);
         if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == dir){
            count++;
            profit = OrderProfit();
            ticket = OrderTicket();            
         }
      }
      if(count == 1){
         if(profit >= 0.0)trade.TralPoints(ticket, step, stop);
         else trade.Breakeven(ticket, stop);
      } 
   }
}