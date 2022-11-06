//+------------------------------------------------------------------+
//|                                                      PING_V2.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "2.10"


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

input int    magic      = 823328;            //�����
input double volume     = 0.01;              //�����
input ENUM_TIMEFRAMES period = PERIOD_D1;    //�� ����� ����� ���������� ������
input int    expiration = 24;                //���������� (�)
input int    offset     = 5;                 //����������� ������� ������� �����(�)
/*
input bool  useStoch    = true;          //������������ Stochastic
input ENUM_TIMEFRAMES stTF = PERIOD_D1;  //�� ��� Stochastic
input int   stTop       = 80;
input int   stBottom    = 20;

input bool  useMA       = true;             //������������ ��
input ENUM_TIMEFRAMES maTF = PERIOD_D1;  //�� ��� ��
input int   maPeriod    = 14;
*/
bool     action;     //�������
double   level1;     //�������� ���������� ������� ����� (�� ��� BUY)
double   level2;     //������� �������� ������ BUY
double   level3;     //������� �������� ������ SELL
double   level4;     //������� ���������� ������� ����� (�� ��� SELL)
datetime cTime[1];   //����� ����� �������� ����� 
datetime pTime;      //����� ��� ���������
double   count;
double   avrCnd;
double   offs;       //����������� ������� ������� ����� 
   
int OnInit(){
   
   count = 0;
   avrCnd = 0;
   
   offs = NormalizeDouble(offset * Point(), Digits());
   
   if(Digits() == 3 || Digits() == 5)
      offs = NormalizeDouble(offset * Point(), Digits()) * 10;
   
   for(int i = 0; i < Bars; i++)
      count += (High[i] - Low[i]);
   
   avrCnd = count/Bars;
   
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
//|   ���� �� ������� ������� Stochastic, ��� MA � �����-�� �� ��� ���������� False, ��   |
//|   �������                                                                             |
//+---------------------------------------------------------------------------------------+
void Start(){
   MqlRates rates[];
   MqlTick  tick;
   RefreshRates();
   CopyRates(Symbol(), period, 1, 1, rates);
   SymbolInfoTick(Symbol(), tick);
   
   int cmdBuy  = -1; //��� �������� �� buy
   int cmdSell = -1; //��� �������� �� sell
   int slp     = (tick.ask - tick.bid)/Point();
   int expire  = TimeCurrent() + expiration * 3600;
   
   if(ArraySize(rates)< 1)
      return;
      
      
   //���� ����� ������ ������� - �����������, �������
   //���� ����� ������ ������� + �����������, �������
   if(((rates[0].high - rates[0].low) < avrCnd - offs)||((rates[0].high - rates[0].low) > avrCnd + offs))
      return;
   /*   
   if(useMA)
      if(!FilterMA(rates[0].high, rates[0].low))
         return;
   
   if(useStoch)
      if(!FilterStoch())
         return;
   */
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
/*
//+---------------------------------------------------------------------------------------+
//|   FilterMA()                                                                          |
//|   ����������� ����� ������������� ���������, ������������, ��� ���������.             |
//|   ���� High � Low ����, ��� ���� ��, �� ���������� true                               |
//|   ����� - false                                                                       |
//+---------------------------------------------------------------------------------------+
bool FilterMA(double high, double low){
   double ma = iMA(Symbol(), maTF, maPeriod,0, MODE_EMA, PRICE_CLOSE, 1);
   if((high > ma && low > ma) || (high < ma && low < ma))
      return true;
   else
      return false;
}


//+---------------------------------------------------------------------------------------+
//|   FilterStoch()                                                                       |
//|   �� ��������                                                                         |
//|   ��� ���, ��� ������                                                                 |                                                                 |
//+---------------------------------------------------------------------------------------+
bool FilterStoch(){
   if(iStochastic(Symbol(), stTF, 5, 3, 3, MODE_EMA, 0, MODE_MAIN, 1) > stTop)
      return true;
   else if(iStochastic(Symbol(), stTF, 5, 3, 3, MODE_EMA, 0, MODE_MAIN, 1) < stBottom)
      return true;
   else
      return false;
}*/