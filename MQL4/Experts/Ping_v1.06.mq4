//+------------------------------------------------------------------+
//|                                                        Spawn.mq4 |
//|                                                             Enzo |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
//�������� ������������ �������

#property copyright "Enzo"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
/*
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
*/

enum days{
   d0,      //�����������
   d1,      //�����������
   d2,      //�������
   d3,      //�����
   d4,      //�������
   d5,      //�������
   d6       //�������
};

int      magic    = 4123;     //�����
//session oSession  = 0;        //�������� ������
//session cSession  = 23;       //�������� ������
input int      levels   = 300;       //���������� ������� ������ � ������� (������)
int      slippage = 50;        //��������������� (������)
double   volume   = 0.01;     //����� ����
input days  day1 = d1;        //������ ��������
input days  day2 = d4;        //���������� ��������
input double   multipler = 2;       //��������� ������ ��� �����������
//input bool     useLimiter = false;  //������������ ������������
//input double   limiter   = 0.64;      //������������ �������
//-------------------------------------------------------------//
// action - ������� ������ ���������. ���� true, 
//          �� �� ���������� �������� �������� �������//
// cmd    - ��� �������� �������� ��������
//
// level1 - ������� ������� (����������� ������� BUY)
// level2 - ������ �������  (������ BUY)
// level3 - ������ �������  (������ SELL)
// level4 - ������ �������  (����������� ������� SELL)
string   symbol;
string   string_day;
int      mgc;
int      cmd;
int      slp;
int      lvl;
int      day;
double   level1;
double   level2;
double   level3;
double   level4;
double   price;
double   sl;
double   tp;
double   vol;     
double   mtp;
bool     action;  
datetime time;

MqlDateTime GMT;

int OnInit(){
   
   Init();
   //time     = 0;
   mgc      = magic;
   symbol   = Symbol();   
   slp      = slippage;
   lvl      = levels;
   mtp      = multipler;
   
   if(OldSameSet()){
      action = true;
      SetLevels();
   }
   
   
   /*
   if(Digits() == 3 || Digits() == 5){
      slp *= 10;
      lvl *= 10;
   }
   */
   return(INIT_SUCCEEDED);
}

void OnTick(){
   if(time == Time[0])
      return;
   time = Time[0];
   
   day = DayOfWeek();
   
   switch(day){
      case 0: string_day = "�����������";break;
      case 1: string_day = "�����������";break;
      case 2: string_day = "�������";    break;
      case 3: string_day = "�����";      break;
      case 4: string_day = "�������";    break;
      case 5: string_day = "�������";    break;
      case 6: string_day = "�������";    break;
   };
   
   TimeGMT(GMT);
   //���� ������� ��������, ���������� �������� �������
   Comment("GMT ",GMT.hour,":",GMT.min,"\n",string_day);
   /*
   for(int i = 0; i < OrdersTotal(); i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ������ ������ ������: ",GetLastError());
         return;
      }
      
      if(OrderSymbol() == symbol){
         return;
      }         
   }
   
   if(GMT.hour < oSession || GMT.hour >= cSession)
      action = true;*/
   
   if(day < day1 || day >= day2)
      action = true;
   
   if(!action){
      Start();
   }
   else
      Continue();
   
}

//������������� ����������
void Init(){
   action   = false;   
   vol      = volume;
   price    = 0.0;
   sl       = 0.0;
   tp       = 0.0;
   
}

//��������� ������ ���� ������� �����
void Start(){
   Init();
   MqlTick  lastTick;
   SymbolInfoTick(symbol, lastTick);
   //���� ����� �����, �� ������ ����� �� BUY, �������� �������
   if(lastTick.ask > Open[0]){
      level1   = NormalizeDouble(lastTick.ask + lvl*Point(), Digits());
      level2   = NormalizeDouble(lastTick.ask, Digits());
      level3   = NormalizeDouble(lastTick.ask - lvl*Point(),Digits());
      level4   = NormalizeDouble(lastTick.ask - lvl*Point()*2, Digits());
      price    = level2;
      tp       = level1;
      sl       = level3;
      cmd      = OP_BUY;
      action   = true;
   }   
   //���� ����� ��������, �� ������ ����� �� SELL � �������� �������
   else if (lastTick.bid < Open[0]){
      level1   = NormalizeDouble(lastTick.bid + lvl*Point()*2,Digits());
      level2   = NormalizeDouble(lastTick.bid + lvl*Point(),Digits());
      level3   = NormalizeDouble(lastTick.bid,Digits());
      level4   = NormalizeDouble(lastTick.bid - lvl*Point(), Digits());
      price    = level3;
      tp       = level4;
      sl       = level2;
      cmd      = OP_SELL;
      action   = true;
   }
   //Print("price: ",price, " sl: ",sl," tp: ",tp);
   ResetLastError();
   if(!OrderSend(symbol, cmd, vol, price, slp, sl, tp, NULL, mgc)){
      Print(__FUNCTION__," ������ �������� ������: ",GetLastError());
      return;
   };
}

void Continue(){
   MqlTick  lastTick;
   SymbolInfoTick(symbol, lastTick);
   int total   = OrdersTotal();
   int pTicket = 0; 
   int cTicket = 0;
   int type    = 0;
   bool cur    = false;
   bool pend   = false;
   
   if(total == 0){
      action = false;
      return;
   }
   
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ������ ������ ������: ",GetLastError());
         return;
      }
      
      if(OrderSymbol() == symbol/* && OrderMagicNumber() == mgc*/){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
            cTicket = OrderTicket();
            type = OrderType();
            cur = true;
            vol = OrderLots();
         }
         if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP){
            pTicket = OrderTicket();
            pend = true;
         }
      }         
   }
   
   if(cur && !pend){
      int lCmd;
      double lPrice  = 0.0;
      double lSL     = 0.0;
      double lTP     = 0.0;
      
      if(type == OP_BUY){
         lCmd = OP_SELLSTOP;
         lPrice = level3;
         lSL    = level2;
         lTP    = level4;
      }
      
      else if(type == OP_SELL){
         lCmd = OP_BUYSTOP;
         lPrice = level2;
         lSL    = level3;
         lTP    = level1;
      }
      if(lPrice != 0.0){
      
         //if((useLimiter && vol < limiter) || !useLimiter ){ //1) ���� ������������ ������� � ����� ������ �������� ��� 2).������� �� ������������
         vol *= mtp;
         ResetLastError();
         if(!OrderSend(symbol, lCmd, vol, lPrice, slp, lSL, lTP, NULL, mgc)){
            Print(__FUNCTION__, " ������ �������� ������: ", GetLastError());
            return;
         }
         
      }
      return;
   }
   
   if(cur && pend){
      return;
   }
   
   if(!cur && pend){
      ResetLastError();
      if(!OrderDelete(pTicket)){
         Print(__FUNCTION__," ������ �������� ������: ", GetLastError());
         return;
      }
      Init();
   }
   if(!cur && !pend){
      Init();
   }   
}

bool OldSameSet(){
   if(OrdersTotal() > 0)
      
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__," ������ ������ ������: ",GetLastError());
            return false;
         }
         if(OrderSymbol() == symbol && OrderMagicNumber() == magic)
            return true;
      }
      
   return false;
}

void SetLevels(){
   int total = OrdersTotal();
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ������ ������ ������: ",GetLastError());
         return;
      }
      
      if(OrderSymbol() == symbol && OrderMagicNumber() == magic){
         if(OrderType() == OP_BUY){
            level1 = OrderTakeProfit();
            level2 = OrderOpenPrice();
            level3 = OrderStopLoss();
            vol    = OrderLots();
         }
         
         if(OrderType() == OP_SELL){
            level2 = OrderStopLoss();
            level3 = OrderOpenPrice();
            level4 = OrderTakeProfit();
            vol    = OrderLots();
         }
         
         if(OrderType() == OP_BUYSTOP){
            level1 = OrderTakeProfit();
            level2 = OrderOpenPrice();
            level3 = OrderStopLoss();
            //vol    = OrderLots();
         }
         
         if(OrderType() == OP_SELLSTOP){
            level2 = OrderStopLoss();
            level3 = OrderOpenPrice();
            level4 = OrderTakeProfit();   
            //vol    = OrderLots();         
         }         
      }      
   }
}