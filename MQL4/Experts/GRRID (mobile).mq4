//+------------------------------------------------------------------+
//|                                                        GRRID.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict

#include <Trade.mqh>

CTrade trade;

enum orderTypes{
   stops,      //Стоповые
   limits,     //Лимитные
   stopsBuy,   //Только BUYSTOP
   stopsSell,  //Только SELLSTOP
   limitsBuy,  //Только BUYLIMIT
   limitsSell  //Только SELLLIMIT
};

enum session{
   h0,      //0:00
   h1,      //1:00
   h2,      //2:00
   h3,      //3:00
   h4,      //4:00
   h5,      //5:00
   h6,      //6:00
   h7,      //7:00
   h8,      //8:00
   h9,      //9:00
   h10,     //10:00
   h11,     //11:00
   h12,     //12:00
   h13,     //13:00
   h14,     //14:00
   h15,     //15:00
   h16,     //16:00
   h17,     //17:00
   h18,     //18:00
   h19,     //19:00
   h20,     //20:00
   h21,     //21:00
   h22,     //22:00
   h23      //23:00
};

enum days{
   //d0,      //Воскресенье
   d1 = 1,      //Понедельник
   d2,      //Вторник
   d3,      //Среда
   d4,      //Четверг
   d5,      //Пятница
   d6       //Суббота
};


input int         magic       = 7882345;   //Магик
//input session     oSession    = 0;        //Открытие сессии
//input session     cSession    = 23;       //Закрытие сессии

input string      oSession    = "11:25";     //Открытие сессии
input string      cSession    = "13:00";     //Закрытие сессии

input days        day1        = d1;       //Начало торговли
input days        day2        = d5;       //Завершение торговли
input double      volume      = 0.01;     //Объем
orderTypes  orderType   = stops;    //Типы ордеров в сетке
int         buyCount    = 1;        //Количество ордеров на Buy
int         sellCount   = 1;        //Количество ордеров на Sell
input int         gOffset     = 20;       //Расстояние между сетками(п)
input int         offset      = 10;        //Расстояние между ордерами(п)
input int         TP          = 20;       //Тейкпрофит(п)
input int         SL          = 20;       //Стоплос(п)
//input int         expiration  = 10;        //Экспирация(ч)
input bool        close       = true;    //Принудительно закрывать все ордера при закрытии сессии
input bool        tral        = true;     //трал
input int         tralpoints = 20;        //трал пункты

string botName = "GRID (mobile)";
int mtp;
int day;
MqlDateTime GMT;
string string_day = NULL;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){
//---
   trade.SetExpertMagic(magic);
   mtp = 1;
   if(Digits() == 5 || Digits() == 3)
      mtp = 10;
  
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
   
   TimeLocal(GMT); 
   day = GMT.day_of_week;
   
   switch(day){
      case 0: string_day = "Воскресенье";break;
      case 1: string_day = "Понедельник";break;
      case 2: string_day = "Вторник";    break;
      case 3: string_day = "Среда";      break;
      case 4: string_day = "Четверг";    break;
      case 5: string_day = "Пятница";    break;
      case 6: string_day = "Суббота";    break;
   };
   
   Comment("Текущее время ",GMT.hour,":",GMT.min < 10 ? "0"+IntegerToString(GMT.min) : IntegerToString(GMT.min),"\n",string_day);
   StringToTime(oSession);
   
   if((day >= day1 && day <= day2) && (TimeLocal() >= StringToTime(oSession) &&  TimeLocal() < StringToTime(cSession)))
      BuildGrid();
   
   else{
      if(close)
         CloseGrid();
   }
   if(tral)
      trade.TralPointsGeneral(tralpoints);
}
//+------------------------------------------------------------------+

int Total(int dir = -1){
   int count = 0;
   if(OrdersTotal() != 0){
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__,"  ",GetLastError());
            return count;
         }
         if(OrderSymbol() == Symbol() && OrderMagicNumber() == magic && (OrderType() == dir || dir == -1)){
            count++;
         }
      }
   }
   //Print("count = ",count);
   return count;
}

void BuildGrid(){
   MqlRates rates[];
   RefreshRates();
   int slp = (int)(MarketInfo(Symbol(), MODE_SPREAD));
   CopyRates(Symbol(), PERIOD_CURRENT, 0, 1, rates);
   
   if(ArraySize(rates) == 0)
      return;
   bool x = false;
   int    cmd     = -1;
   int    total   = 0;
   double price  = 0.0;
   double nearPrice;
   double farPrice;
   int    ticket = 0;
   //datetime expir = TimeCurrent() + 3600*expiration;
   //Выставляем баевские

   if(orderType == stops || orderType == stopsBuy)
      cmd = OP_BUYSTOP;
   else if(orderType == limits || orderType == limitsBuy)
      cmd = OP_BUYLIMIT;
                
   switch(cmd){
      case 2:        //BUYLIMIT               
         total = Total(OP_BUYLIMIT);
           
         price = NormalizeDouble(rates[0].close - gOffset*Point()*mtp/2 - offset*Point()*mtp, Digits());
         trade.BuyLimit(Symbol(), PERIOD_CURRENT, volume, price, SL, TP, botName);
         break;
         
      case 4:        //BUYSTOP            
         total = Total(OP_BUYSTOP); 
         //if(total >= buyCount) break;
            
         if(total == 0){
            for(int i = 0; i < buyCount; i++){
               price = NormalizeDouble(rates[0].close + gOffset*Point()*mtp/2 + offset*Point()*mtp*i, Digits());
               trade.BuyStop(Symbol(), PERIOD_CURRENT, volume, price, SL, TP, botName);
            }
            break;
         }
         
         nearPrice = 0.0;
         farPrice  = 0.0;
         ticket = 0;
         for(int i = OrdersTotal() - 1; i >= 0; i--){
            x = OrderSelect(i, SELECT_BY_POS);
            if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == OP_BUYSTOP){
               if(nearPrice == 0.0 || nearPrice > OrderOpenPrice())nearPrice = OrderOpenPrice();
               if(farPrice  == 0.0 || farPrice  < OrderOpenPrice()){farPrice  = OrderOpenPrice();ticket = OrderTicket();}
            }
         }
         if(nearPrice != 0.0 && nearPrice > NormalizeDouble(rates[0].close + gOffset*Point()*mtp/2 + offset*Point()*mtp, Digits()))
            trade.BuyStop(Symbol(), PERIOD_CURRENT, volume, NormalizeDouble(rates[0].close + gOffset*Point()*mtp/2, Digits()), SL, TP, botName);
         if(ticket != 0 && Total(OP_BUYSTOP) > buyCount)
            trade.DeletePending(ticket);
      break;       
   }
   
   
   //Выставляем селовские
   if(orderType == stops || orderType == stopsSell)
      cmd = OP_SELLSTOP;
   else if(orderType == limits || orderType == limitsSell)
      cmd = OP_SELLLIMIT;
             
   switch(cmd){
      case 3:        //SELLLIMIT
         total = Total(OP_SELLLIMIT);
         price = NormalizeDouble(rates[0].close + gOffset*Point()*mtp/2, Digits());
         trade.SellLimit(Symbol(), PERIOD_CURRENT, volume, price, SL, TP, botName);
         break;
      case 5:        //SELLSTOP
         total = Total(OP_SELLSTOP);
         
         //if(total >= sellCount) break;
           
         if(total == 0){
            for(int i = 0; i < sellCount; i++){
               price = NormalizeDouble(rates[0].close - gOffset*Point()*mtp/2 - offset*Point()*mtp*i, Digits());
               trade.SellStop(Symbol(), PERIOD_CURRENT, volume, price, SL, TP, botName);
            }
            break;
         }
         nearPrice = 0.0;
         farPrice  = 0.0;
         ticket = 0;
         for(int i = OrdersTotal() - 1; i >= 0; i--){
            x = OrderSelect(i, SELECT_BY_POS);
            if(OrderMagicNumber() == magic && OrderSymbol() == Symbol() && OrderType() == OP_SELLSTOP){
               if(nearPrice == 0.0 || nearPrice < OrderOpenPrice())nearPrice = OrderOpenPrice();
               if(farPrice  == 0.0 || farPrice  > OrderOpenPrice()){farPrice  = OrderOpenPrice();ticket = OrderTicket();}
            }
         }
         if(nearPrice != 0.0 && nearPrice < NormalizeDouble(rates[0].close - gOffset*Point()*mtp/2 - offset*Point()*mtp, Digits()))
            trade.SellStop(Symbol(), PERIOD_CURRENT, volume, NormalizeDouble(rates[0].close - gOffset*Point()*mtp/2, Digits()), SL, TP, botName);
         if(ticket != 0 && Total(OP_SELLSTOP) > sellCount)
            trade.DeletePending(ticket);
      break;
   }
}

void CloseGrid(){
   trade.CloseTrades();
   trade.DeletePendings();
}
