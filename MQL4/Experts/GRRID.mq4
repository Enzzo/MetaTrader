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
   stops,      //��������
   limits,     //��������
   stopsBuy,   //������ BUYSTOP
   stopsSell,  //������ SELLSTOP
   limitsBuy,  //������ BUYLIMIT
   limitsSell  //������ SELLLIMIT
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
   //d0,      //�����������
   d1 = 1,      //�����������
   d2,      //�������
   d3,      //�����
   d4,      //�������
   d5,      //�������
   d6       //�������
};


input int         magic       = 788765;   //�����
//input session     oSession    = 0;        //�������� ������
//input session     cSession    = 23;       //�������� ������

input string      oSession    = "11:25";     //�������� ������
input string      cSession    = "13:00";     //�������� ������

input days        day1        = d3;       //������ ��������
input days        day2        = d3;       //���������� ��������
input double      volume      = 0.01;     //�����
input orderTypes  orderType   = stops;    //���� ������� � �����
input int         buyCount    = 20;        //���������� ������� �� Buy
input int         sellCount   = 20;        //���������� ������� �� Sell
input int         gOffset     = 20;       //���������� ����� �������(�)
input int         offset      = 10;        //���������� ����� ��������(�)
input int         TP          = 20;       //����������(�)
input int         SL          = 20;       //�������(�)
input int         expiration  = 10;        //����������(�)
input bool        close       = true;    //������������� ��������� ��� ������ ��� �������� ������
input bool        tral        = true;     //����
input int         tralpoints = 20;        //���� ������

string botName = "GRID";
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
      case 0: string_day = "�����������";break;
      case 1: string_day = "�����������";break;
      case 2: string_day = "�������";    break;
      case 3: string_day = "�����";      break;
      case 4: string_day = "�������";    break;
      case 5: string_day = "�������";    break;
      case 6: string_day = "�������";    break;
   };
   Comment("������� ����� ",GMT.hour,":",GMT.min,"\n",string_day);
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

int Total(){
   if(OrdersTotal() == 0)
      return 0;
   int count = 0;
   int total = OrdersTotal();
   
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__,"  ",GetLastError());
         return count;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         count++;
      }
   }
   return count;
}

void BuildGrid(){
   if(Total() > 0)
      return;
   
   MqlRates rates[];
   RefreshRates();
   int slp = (int)(MarketInfo(Symbol(), MODE_SPREAD));
   CopyRates(Symbol(), PERIOD_CURRENT, 0, 1, rates);
   
   if(ArraySize(rates) == 0)
      return;
   
   int    cmd     = -1;
   double price   = 0.0;
   double sl      = 0.0;
   double tp      = 0.0;
   datetime expir = TimeCurrent() + 3600*expiration;
   //���������� ��������
   if(buyCount > 0){
      if(orderType == stops || orderType == stopsBuy)
         cmd = OP_BUYSTOP;
      else if(orderType == limits || orderType == limitsBuy)
         cmd = OP_BUYLIMIT;
         
      for(int i = 0; i < buyCount; i++){
         
         switch(cmd){
            case 2:        //BUYLIMIT
               price = NormalizeDouble(rates[0].close - gOffset*Point()*mtp/2 - offset*Point()*mtp*i, Digits());
               tp    = NormalizeDouble(price + TP*Point()*mtp, Digits());
               sl    = NormalizeDouble(price - SL*Point()*mtp, Digits());
               if(TP == 0)
                  tp = 0.0;
               if(SL == 0)
                  sl = 0.0;
               break;
            case 4:        //BUYSTOP
               price = NormalizeDouble(rates[0].close + gOffset*Point()*mtp/2 + offset*Point()*mtp*i, Digits());
               tp    = NormalizeDouble(price + TP*Point()*mtp, Digits());
               sl    = NormalizeDouble(price - SL*Point()*mtp, Digits());
               if(TP == 0)
                  tp = 0.0;
               if(SL == 0)
                  sl = 0.0;
               break;
            default:
               continue;
         }
         
         if(cmd != -1){
            if(!OrderSend(Symbol(), cmd, volume, price, slp, sl, tp, botName, magic, expir)){
               Print(__FUNCTION__,"  ",GetLastError());
               return;
            }
         }
      }
   }
   
   //���������� ���������
   if(sellCount > 0){
      if(orderType == stops || orderType == stopsSell)
         cmd = OP_SELLSTOP;
      else if(orderType == limits || orderType == limitsSell)
         cmd = OP_SELLLIMIT;
         
      for(int i = 0; i < sellCount; i++){
         
         switch(cmd){
            case 3:        //SELLLIMIT
               price = NormalizeDouble(rates[0].close + gOffset*Point()*mtp/2 + offset*Point()*mtp*i, Digits());
               tp    = NormalizeDouble(price - TP*Point()*mtp, Digits());
               sl    = NormalizeDouble(price + SL*Point()*mtp, Digits());
               if(TP == 0)
                  tp = 0.0;
               if(SL == 0)
                  sl = 0.0;
               break;
            case 5:        //SELLSTOP
               price = NormalizeDouble(rates[0].close - gOffset*Point()*mtp/2 - offset*Point()*mtp*i, Digits());
               tp    = NormalizeDouble(price - TP*Point()*mtp, Digits());
               sl    = NormalizeDouble(price + SL*Point()*mtp, Digits());
               if(TP == 0)
                  tp = 0.0;
               if(SL == 0)
                  sl = 0.0;
               break;
            default:
               continue;
         }
         
         if(cmd != -1){
            if(!OrderSend(Symbol(), cmd, volume, price, slp, sl, tp, botName, magic, expir)){
               Print(__FUNCTION__,"  ",GetLastError());
               return;
            }
         }
      }
   }
}

void CloseGrid(){
   if(Total() == 0)
      return;
   int total = OrdersTotal();
   MqlTick tick;
   RefreshRates();
   SymbolInfoTick(Symbol(), tick);
   int slp = (int)(MarketInfo(Symbol(), MODE_SPREAD));
   for(int i = total - 1; i >= 0; i--){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__,"  ",GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY){
            ResetLastError();
            if(!OrderClose(OrderTicket(), OrderLots(), tick.bid, slp)){
               Print(__FUNCTION__,"  ",GetLastError());
               return;
            }
         }
         if(OrderType() == OP_SELL){
            ResetLastError();
            if(!OrderClose(OrderTicket(), OrderLots(), tick.ask, slp)){
               Print(__FUNCTION__,"  ",GetLastError());
               return;
            }
         }
         if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP || OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT){
            ResetLastError();
            if(!OrderDelete(OrderTicket())){
               Print(__FUNCTION__,"  ",GetLastError());
               return;
            }
         }
      }
   }
}

