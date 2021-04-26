//+------------------------------------------------------------------+
//|                                                      PING_V2.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "2.00"


//+---------------------------------------------------------------------------------------+
//|   ������� �������������� ������� ����� � �� ��� ������������                          |
//|   ������ �������.                                                                     |
//|   level1 = High[1]                                                                    |
//|   level4 = Low[1]                                                                     |
//|   level2 = level1 - (level1 - level4)/3                                               |
//|   level3 = level4 + (level1 - level4)/3                                               |
//|                                                                                       |
//|   ���� ���� ���� level2, �� �������� ������ BUYLIMIT(0.01) � SELLSTOP(0.01)           |
//|   ���� ���� ���� level3, �� �������� ������ BUYSTOP(0.01) � SELLLIMIT(0.01)           |
//|   ���� ���� ����� level3 � level2, �� �������� ������ BUYSTOP(0.01) � SELLSTOP(0.01)  |
//|                                                                                       |
//|   ���� ����� ���� ���� �����, �� ������� action = true                                |
//|   ���� ���, �� ��������� ������� Init() � � ��� action = false                        |
//+---------------------------------------------------------------------------------------+

input int    magic      = 823328;  //�����
input double volume     = 0.01;    //�����
input int    expiration = 24;       //���������� (�)

bool     action;     //�������
double   level1;     //�������� ���������� ������� ����� (�� ��� BUY)
double   level2;     //������� �������� ������ BUY
double   level3;     //������� �������� ������ SELL
double   level4;     //������� ���������� ������� ����� (�� ��� SELL)
datetime cTime[1];   //����� ����� �������� ����� 
datetime pTime;      //����� ��� ���������

int OnInit(){
   action = false;
   //Init();
   pTime = 0;
   CheckOldSet();
   return(INIT_SUCCEEDED);
}


void OnTick(){
   
   if(!action)
      Start();
   else
      Continue();   
}


//+---------------------------------------------------------------------------------------+
//|   Init()                                                                              |
//|   �� ��������.                                                                        |
//|   �������� ��������� ���������                                                        |
//+---------------------------------------------------------------------------------------+
void Init(){
   action = false;
   level1 = 0.0;
   level2 = 0.0;
   level3 = 0.0;
   level4 = 0.0;
}


//+---------------------------------------------------------------------------------------+
//|   CheckOldSet()                                                                       |
//|   �� ��������.                                                                        |
//|   ���� ��� ���������� ������ ���� ����������, �� ����������� ������� ���������        |
//|   ������� � action = true.                                                            |
//+---------------------------------------------------------------------------------------+
void CheckOldSet(){
   if(OrdersTotal() == 0)
      return;
   
   for(int i = 0; i < OrdersTotal(); i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__, " ������ ������ ������: ",GetLastError());
         return;
      }
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         action = true;
         if(OrderType() == OP_BUY || OrderType() == OP_BUYSTOP || OrderType() == OP_BUYLIMIT){
            level1 = OrderTakeProfit();
            level2 = OrderOpenPrice();
         }
         else if(OrderType() == OP_SELL || OrderType() == OP_SELLSTOP || OrderType() == OP_SELLLIMIT){
            level3 = OrderOpenPrice();
            level4 = OrderTakeProfit();
         }
      }
   }
}

//+---------------------------------------------------------------------------------------+
//|   Start()                                                                             |
//|   �� ��������.                                                                        |
//|   ������������� ������ �� �������������� ������� ����� � ���������� �� ��� ���        |
//|   �����������. action = true.                                                         |
//|                                                                                       |
//|   level1 = High[1]                                                                    |
//|   level4 = Low[1]                                                                     |
//|   level2 = level1 - (level1 - level4)/3                                               |
//|   level3 = level4 + (level1 - level4)/3                                               |
//|                                                                                       |
//|   ���� ���� ���� level2, �� �������� ������ BUYLIMIT(0.01) � SELLSTOP(0.01)           |
//|   ���� ���� ���� level3, �� �������� ������ BUYSTOP(0.01) � SELLLIMIT(0.01)           |
//|   ���� ���� ����� level3 � level2, �� �������� ������ BUYSTOP(0.01) � SELLSTOP(0.01)  |
//+---------------------------------------------------------------------------------------+
void Start(){
   MqlRates rates[];
   MqlTick  tick;
   RefreshRates();
   CopyRates(Symbol(), PERIOD_D1, 1, 1, rates);
   SymbolInfoTick(Symbol(), tick);
   
   int cmdBuy  = -1; //��� �������� �� buy
   int cmdSell = -1; //��� �������� �� sell
   int slp     = (tick.ask - tick.bid)/Point();
   int expire  = TimeCurrent() + expiration * 3600;
   
   level1 = NormalizeDouble(rates[0].high, Digits());
   level4 = NormalizeDouble(rates[0].low, Digits());
   level2 = NormalizeDouble(level1 - (level1 - level4)/3, Digits());
   level3 = NormalizeDouble(level4 + (level1 - level4)/3, Digits());
   
   if(tick.ask > level2){
      cmdBuy  = OP_BUYLIMIT;
      cmdSell = OP_SELLSTOP;
   }
   else if(tick.bid < level3){
      cmdBuy  = OP_BUYSTOP;
      cmdSell = OP_SELLLIMIT;
   }
   else{
      cmdBuy  = OP_BUYSTOP;
      cmdSell = OP_SELLSTOP;
   }
   
   ResetLastError();
   if(!OrderSend(Symbol(), cmdBuy, volume, level2, slp, level3, level1, NULL, magic, expire)){
      Print(__FUNCTION__, " ������ ����������� ������: ", GetLastError());
      return;
   }
   
   ResetLastError();
   if(!OrderSend(Symbol(), cmdSell, volume, level3, slp, level2, level4, NULL, magic, expire)){
      Print(__FUNCTION__, " ������ ����������� ������: ", GetLastError());
      return;
   }
   
   action = true;
}


//+---------------------------------------------------------------------------------------+
//|   Continue()                                                                          |
//|   �� ��������.                                                                        |
//|   �������� �������                                                                    |
void Continue(){
   
   //���� ������� ���, �� action = false � �������
   if(OrdersTotal() == 0){
      action = false;
      return;
   }
   
   bool cur  = false;      //��������   ������
   bool pend = false;      //���������� ������
   int  cTicket = 0;       //����� ��������� ������
   int  pTicket = 0;       //����� �����������
   ushort n = 0;           //���������� ������������
      
      
   //��������� ������
   //���� �������, ������������ ����������, ���, �� ������� � action = false
   //���� ����, �� ���� ������
   for(int i = 0; i < OrdersTotal(); i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__, " ������ ������ ������: ",GetLastError());
         return;
      }
      
      //���� ����� �����, ������������ ���������, �� ��������� ��� �����
      if(OrderMagicNumber() == magic && OrderSymbol() == Symbol()){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
            cur = true;
            cTicket = OrderTicket();
         }
         if(OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP){
            pend = true;
            pTicket = OrderTicket();
            n++;
         }
      }/*
      else{
         action = false;
         return;
      }*/
   }
   
   if(!cur && !pend){
      action = false;
      return;
   }
   
   //���� ������������ ���, �� ������� � ����, ���� ���� �� ���������
   if(n == 2){
      action = true;
      return;
   }
   
   ///��� ���� ������� ���������� � ����� 0.01!!!!!!!!!!!!!!!!
   if(cur && pend){
      ResetLastError();
      if(!OrderSelect(pTicket, SELECT_BY_TICKET)){
         Print(__FUNCTION__," ������ ������ ������: ",GetLastError());
         return;
      }
      
      if(OrderLots() == volume){
         ResetLastError();
         if(!OrderDelete(pTicket)){
            Print(__FUNCTION__," ������ �������� ������: ", GetLastError());
            return;
         }
      }
      action = true;
      return;
   }
   
   //���� ������ ���� ���������� � ��� ��������� ������, �� ������� ��� �� ��������� ������ � action = false;
   if(!cur && pend){
      //����� ������ ������� ����������
      /*CopyTime(Symbol(), PERIOD_M1, 0, 1, cTime);
      if(pTime == cTime[0])
         return;
      pTime = cTime[0];
      */
      ResetLastError();
      if(!OrderDelete(pTicket)){
         Print(__FUNCTION__," ������ �������� ������: ",GetLastError());
         return;
      }
      action = false;
      return;
   }
   
   //���� ������ ��������, �� ���������� ���������� � ������� ����� �� ������� (level1 - level4) action = true;
   if(cur && !pend){
      ResetLastError();
      if(!OrderSelect(cTicket, SELECT_BY_TICKET)){
         Print(__FUNCTION__, " ������ ������ ��������� ������: ", GetLastError());
         return;
      }
      
      MqlTick tick;
      RefreshRates();
      SymbolInfoTick(Symbol(), tick);
      int cmd = -1;
      double price = 0.0;
      double sl = 0.0;
      double tp = 0.0;
      double vol = OrderLots() * 2;
      int slp = (tick.ask - tick.bid)/Point();
      
      if(OrderType() == OP_BUY){    
         cmd   = OP_SELLSTOP;
         price = level3;
         sl    = level2;
         tp    = level4;
      }
      else if(OrderType() == OP_SELL){
         cmd   = OP_BUYSTOP;
         price = level2;
         sl    = level3;
         tp    = level1;
      }
      
      if(!OrderSend(Symbol(), cmd, vol, price, slp, sl, tp, NULL, magic)){
         Print(__FUNCTION__, " ������ �������� ������: ", GetLastError());
         return;
      }
      action = true;
   }
}