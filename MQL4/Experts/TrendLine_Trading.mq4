//+------------------------------------------------------------------+
//|                                            TrendLine_Trading.mq4 |
//|                                                        StatBars  |
//|                                            http://tradexperts.ru |
//+------------------------------------------------------------------+
#property copyright "TO"
#property link      "http://tradexperts.ru"
#include <stdlib.mqh>
#include <stderror.mqh>

extern string Support_Line_Name     = "SP";
extern string Resistance_Line_Name  = "RS";
extern bool Invers_Orders           = false;
extern int SL                       = 50;
extern int TP                       = 50;
extern double Lot                   = 0.1;
extern bool Show_Alert              = false;
extern int Magic_Number             = 818798;


double Prev_Bid=0.0,Prev_Ask=0.0;

int init(){

   return(0);
}

int deinit(){

   return(0);
}

int start(){
   if(Prev_Bid==0){
      Prev_Bid = Bid;
      Prev_Ask = Ask;
      return(0);
   }
   
   int ticket;
   double take, stop;
   int STOP_LEVEL = MarketInfo(Symbol(),MODE_STOPLEVEL);
   if(TP<STOP_LEVEL)TP = STOP_LEVEL;
   if(SL<STOP_LEVEL)SL = STOP_LEVEL;
   
   if(ObjectFind(Support_Line_Name)!=0 && ObjectFind(Resistance_Line_Name)!=0)
      Comment("Ошибка. Причины: Установите хотя бы одну трендовую линию. Проверьте правильность названия линии. Линия должна быть на основном графике.");
   if(ObjectFind(Support_Line_Name)==0 && StringFind(ObjectDescription(Support_Line_Name),"_opened_"+Magic_Number,0)<0)
   {// нашли нужную линию
   Print("New_Line");
      if((!FindOrder_by_type_and_comment(OP_BUY,"Support_Line",Magic_Number,Symbol()) && !Invers_Orders) || // убедились что ордер по этой линии ещё не открывался
      (!FindOrder_by_type_and_comment(OP_SELL,"Support_Line",Magic_Number,Symbol()) && Invers_Orders))
      {
         if(Ask<=ObjectGetValueByShift(Support_Line_Name,0) && Prev_Ask>ObjectGetValueByShift(Support_Line_Name,0) )// Если цена пересекла линию поддержки, то открываем позицию
         {
            ticket=-1;
            if(!Invers_Orders)
            {
               if(TP!=0)take = Bid+TP*Point; else take = 0;
               if(SL!=0)stop =Bid-SL*Point; else stop = 0;
               Print("Prev WHCORDER");
               ticket = WHCOrderSend(Symbol(),OP_BUY,Lot,Ask,3,stop,take,"Support_Line",Magic_Number,0,Aqua);
            }
            if(Invers_Orders)
            {
               if(TP!=0)take = Ask-TP*Point; else take = 0;
               if(SL!=0)stop =Ask+SL*Point; else stop = 0;
               Print("Prev WHCORDER");
               ticket = WHCOrderSend(Symbol(),OP_SELL,Lot,Bid,3,stop,take,"Support_Line",Magic_Number,0,Lime);
            }
            if(ticket>0 && Show_Alert && !Invers_Orders)
               Alert("Открыт ордер BUY по линии Support_Line. Время: "+TimeToStr(Time[0],TIME_MINUTES));
            if(ticket>0 && Show_Alert && Invers_Orders)
               Alert("Открыт ордер SELL по линии Support_Line. Время: "+TimeToStr(Time[0],TIME_MINUTES));
            if(ticket>0)ObjectSetText(Support_Line_Name,ObjectDescription(Support_Line_Name)+"_opened_"+Magic_Number);
         }
      }
   }
   
    if(ObjectFind(Resistance_Line_Name)==0 && StringFind(ObjectDescription(Resistance_Line_Name),"_opened_"+Magic_Number,0)<0)
   {// нашли нужную линию
   Print("New_Line");
      if((!FindOrder_by_type_and_comment(OP_SELL,"Resistance_Line",Magic_Number,Symbol()) && !Invers_Orders) ||  // убедились что ордер по этой линии ещё не открывался
         (!FindOrder_by_type_and_comment(OP_BUY,"Resistance_Line",Magic_Number,Symbol()) && Invers_Orders))
      {
         //Print(Bid>=ObjectGetValueByShift(Resistance_Line_Name,0)," ",Prev_Bid<=ObjectGetValueByShift(Resistance_Line_Name,0));
         if(Bid>=ObjectGetValueByShift(Resistance_Line_Name,0) && Prev_Bid<=ObjectGetValueByShift(Resistance_Line_Name,0))// Если цена пересекла линию поддержки, то открываем позицию
         {
            ticket=-1;
            if(!Invers_Orders){
               if(TP!=0)take = Ask-TP*Point; else take = 0;
               if(SL!=0)stop =Ask+SL*Point; else stop = 0;
               Print("Prev WHCORDER");
               ticket = WHCOrderSend(Symbol(),OP_SELL,Lot,Bid,3,stop,take,"Resistance_Line",Magic_Number,0,Magenta);
            }
            if(Invers_Orders){
               if(TP!=0)take = Bid+TP*Point; else take = 0;
               if(SL!=0)stop =Bid-SL*Point; else stop = 0;
               Print("Prev WHCORDER");
               ticket = WHCOrderSend(Symbol(),OP_BUY,Lot,Ask,3,stop,take,"Resistance_Line",Magic_Number,0,OrangeRed);
            }
            if(ticket>0 && Show_Alert && !Invers_Orders)
               Alert("Открыт ордер SELL по линии Resistance_Line. Время: "+TimeToStr(Time[0],TIME_MINUTES));
            if(ticket>0 && Show_Alert && Invers_Orders)
               Alert("Открыт ордер BUY по линии Resistance_Line. Время: "+TimeToStr(Time[0],TIME_MINUTES));
            if(ticket>0)ObjectSetText(Resistance_Line_Name,ObjectDescription(Resistance_Line_Name)+"_opened_"+Magic_Number);
         }
      }
   }
   
   Prev_Bid = Bid;
   Prev_Ask = Ask;
   return(0);
  }

// Функция orders for WHC - 
//Для  открытия позиций в условиях рыночного исполнения торговых заявок Market Watch
int WHCOrderSend(string symbol, 
                 int cmd, 
                 double volume, 
                 double price, 
                 int slippage, 
                 double stoploss, 
                 double takeprofit, 
                 string comment, 
                 int magic, 
                 datetime expiration, 
                 color arrow_color)
{
   Print("WHCORDER");
   static int trying=0;
   int ticket = OrderSend(symbol,cmd, volume, price, slippage, 0, 0, comment, magic, expiration, arrow_color);
   int check = -1;
   if (ticket > 0 )
   {
      if(stoploss != 0 || takeprofit != 0)
      if (!OrderModify(ticket, price, stoploss, takeprofit,expiration, arrow_color))
      {
         check = GetLastError();
         if (check != ERR_NO_ERROR)
            Print("OrderModify error: ", ErrorDescription(check));
      }
   }
   else
   {
      check = GetLastError();
      if (check != ERR_NO_ERROR)
         Print("OrderSend error: ",ErrorDescription(check));
      if(trying>5){trying=0;return(0);}
      trying++;
      ticket = WHCOrderSend(symbol, cmd, volume, price, slippage, stoploss, takeprofit, comment, magic, expiration, arrow_color);
      if(ticket!=0)trying=0;
   }
   return (ticket);
}

//---- Ищет ордера по типу и комментарию, в случае успеха возвращает true ----//
bool FindOrder_by_type_and_comment(int type, string comm, int mn, string sym){
   for(int i= OrdersTotal()-1;i>=0;i--){
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES)){
         Print(GetLastError());
         ResetLastError();
         return false;
      };
      if(OrderMagicNumber() == mn && type == OrderType() && StringFind(OrderComment(),comm,0)>=0 && sym==OrderSymbol())
         return(true);
   }
   return(false);
}

