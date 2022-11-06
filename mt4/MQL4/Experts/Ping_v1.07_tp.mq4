//+------------------------------------------------------------------+
//|                                                         Ping.mq4 |
//|                                                             Enzo |
//|                                       "https://vk.com/id29520847"|
//+------------------------------------------------------------------+
//

#property copyright "Enzo"
#property link      "https://vk.com/id29520847"
#property version   "1.07"
#property strict

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
   d0,      //�����������
   d1,      //�����������
   d2,      //�������
   d3,      //�����
   d4,      //�������
   d5,      //�������
   d6       //�������
};

input int      magic    = 9999;     //�����
input session  oSession  = 0;       //�������� ������
input session  cSession  = 23;      //�������� ������
input days     day1 = d1;           //������ ��������
input days     day2 = d4;           //���������� ��������
input int      levels   = 300;      //���������� ������� ������� (������)
input int      tpBuy  = 300;        //������� �� ��� BUY(������)
input int      tpSell = 300;        //������� �� ��� SELL(������)
input double   profit = 0.0;        //������ �������� ������� ������
input double   volume   = 0.01;     //����� ����
input double   multipler = 2;       //��������� ������
//-------------------------------------------------------------//
// action - ������� ������ ���������. ���� true, 
//          �� �� ���������� �������� �������� �������//
// cmd    - ��� �������� �������� ��������
//
// level1 - ������� ������� (����������� ������� BUY)
// level2 - ������ �������  (������ BUY)
// level3 - ������ �������  (������ SELL)
// level4 - ������ �������  (����������� ������� SELL)
string   symbol;     //������
string   string_day; //�������� ���
int      mgc;        //�����
int      cmd;        //��� ������
int      slp;        //���������������
int      lvl;        //������ ����� ��������
int      tpb;        //������ �� ��� buy
int      tps;        //������ �� ��� sell
int      day;        //���� ������ ���������
double   level1;     //�� �������� �������
double   level2;     //���� �������� �������
double   level3;     //���� ��������� �������
double   level4;     //�� ��������� �������
double   vol;        //�����
double   mtp;        //��������� ������
bool     action;     //������
datetime time;

MqlDateTime GMT;

///////////////////////////////////////////////////////////////////
//                                                               //
//                            OnInit()                           //
//                                                               //
//  Init() - ������������� ����������                            //
//  mgc    - �����                                               //
//  symbol - ������                                              //
//  lvl    - ���������� ����� �������� � �������                 //
//  tpb    - �� ��� ������� Buy                                  //
//  tps    - �� ��� ������� Sell                                 //
//  mtp    - ��������� ������ (�������� ����� �����������)       //
//                                                               // 
//  ���� ������� ������ � ����� �� �������� � �������, ��        //
//  ������������� ������ (lvl, tpb, tps) �� ������������ ������� //
//                                                               //
///////////////////////////////////////////////////////////////////
int OnInit(){
   time     = 0;
   Init();
   mgc      = magic;
   symbol   = Symbol();   
   lvl      = levels;
   tpb      = tpBuy;
   tps      = tpSell;
   mtp      = multipler;
   
   if(OldSameSet()){
      action = true;
      SetLevels();
   }
   return(INIT_SUCCEEDED);
}

//////////////////////////////////////////////////////////////////////////
//                                                                      //
//                              OnTick()                                //
//                                                                      //
// day      - ���� ������                                               //
// GMT      - ���� �� GMT                                               //
//                                                                      //
// ���� action = false, �� ��������� ������� Start()                    //
// ���� action = true,  �� ��������� ������� Continue()                 //
//                                                                      //
//////////////////////////////////////////////////////////////////////////
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
   
   if(GMT.hour < oSession || GMT.hour >= cSession)
      action = true;
   
   if(day < day1 || day >= day2)
      action = true;
   
   if(!action){
      Start();
   }
   else
      Continue();
}


///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                              Init()                                  \\
//                                                                      \\
// action   - ������ ������ (���� ���������, �� ���������� �����        \\
//            �������� ����� � �������� ��������)                       \\
// vol      - ����� (����)                                              \\
// price    - ���� �����������                                          \\
// sl       - ��                                                        \\
// tp       - ��                                                        \\
//                                                                      \\
// ���������� ��������� �������� ������ � ��������� ������, ���� ���    \\
// ��������                                                             \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void Init(){
   action   = false;   
   vol      = volume;
   //tp       = 0.0;   
}
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                              Start()                                 \\
//                                                                      \\
// slp   - ��������������� (������������� (ask - bid)/points)           \\
// level1 - �� ��� buy                                                  \\
// level2 - ���� �������� ������ buy  / buystop                         \\
// level3 - ���� �������� ������ sell / sellstop                        \\
// level4 - �� ��� sell                                                 \\
//                                                                      \\
// ���� ASK ���� �������� ���������� ����� - �� ����� �� BUY            \\
// ���� BID ���� �������� ���������� ����� - �� ����� �� SELL           \\
//                                                                      \\
// ��������� ���� �������� ����� � ����������� action � true            \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void Start(){
   Init();
   double   price = 0.0;
   double   tp    = 0.0;
   double   sl    = 0.0;
   MqlTick  lastTick;
   RefreshRates();
   SymbolInfoTick(symbol, lastTick);
   //���� ����� �����, �� ������ ����� �� BUY, �������� �������
   if(lastTick.ask > Close[1]){
      level1   = NormalizeDouble(lastTick.ask + tpb*Point(), Digits());
      level2   = NormalizeDouble(lastTick.ask, Digits());
      level3   = NormalizeDouble(lastTick.ask - lvl*Point(),Digits());
      level4   = NormalizeDouble(lastTick.ask - tps*Point()*2, Digits());
      price    = level2;
      tp       = level1;
      sl       = level3;
      cmd      = OP_BUY;
      action   = true;
   }   
   //���� ����� ��������, �� ������ ����� �� SELL � �������� �������
   else if (lastTick.bid < Close[1]){
      level1   = NormalizeDouble(lastTick.bid + tpb*Point()*2,Digits());
      level2   = NormalizeDouble(lastTick.bid + lvl*Point(),Digits());
      level3   = NormalizeDouble(lastTick.bid,Digits());
      level4   = NormalizeDouble(lastTick.bid - tps*Point(), Digits());
      sl       = level2;
      price    = level3;
      tp       = level4;
      cmd      = OP_SELL;
      action   = true;
   }
   RefreshRates();
   slp = (int)((MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID))/Point());
   ResetLastError();
   if(!OrderSend(symbol, cmd, vol, price, slp, sl, tp, NULL, mgc)){
      Print(__FUNCTION__," ������ �������� ������: ",GetLastError());
      return;
   };
}
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                            Continue()                                \\
//                                                                      \\
// total    - ����� �������                                             \\
// pTicket  - ����� ����������� ������                                  \\
// type     - ��� ��������� ������                                      \\
// cur      - ������� ��������� ������                                  \\
// pend     - ������� ����������� ������                                \\
//                                                                      \\
// 1. ���� ������� ���, �� ��������� ������ (action = false) � �������  \\
//    �� �������.                                                       \\
//                                                                      \\
// 2. ���� ���� �����-�� ������, �� ����������, ���� �� �������� �      \\
//    ���� �� ���������� (cur � pend).                                  \\
//                                                                      \\
// 3. ���� ����� ����������, �� ����������� ���������� pTicket          \\
//    ����� �����������.                                                \\
//                                                                      \\
// 4. ���� cur == true � pend == false, ���������� ��������             \\
//    ��������������� ����������, ��������� CheckOrders() � �������.    \\
//                                                                      \\
// 5. ���� cur == true � pend == true, ��������� CheckOrders()          \\
//    � �������.                                                        \\
//                                                                      \\
// 6. ���� cur == false � pend == true, ������� ���������� �� ������    \\
//    pTicket, ��������� CheckOrders(), ��������� Init()                \\
//                                                                      \\
// 7. ���� cur == false � pend == false, ��������� Init() � �������     \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void Continue(){  
   int total   = OrdersTotal();
   int pTicket = 0;
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
      
      if(OrderSymbol() == symbol && OrderMagicNumber() == mgc){
         if(OrderType() == OP_BUY || OrderType() == OP_SELL){
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
      double lTP     = 0.0;
      double lSL     = 0.0;
      
      if(type == OP_BUY){
         lCmd = OP_SELLSTOP;
         lSL    = level2;
         lPrice = level3;
         lTP    = level4;
      }
      
      else if(type == OP_SELL){
         lCmd = OP_BUYSTOP;
         lPrice = level2;
         lSL    = level3;
         lTP    = level1;
      }
      if(lPrice != 0.0){
      
         vol *= mtp;
         RefreshRates();
         slp = (int)((MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID))/Point());
         ResetLastError();
         if(!OrderSend(symbol, lCmd, vol, lPrice, slp, lSL, lTP, NULL, mgc)){
            Print(__FUNCTION__, " ������ �������� ������: ", GetLastError());
            return;
         }        
      }
      CheckOrders();
      return;
   }
   
   if(cur && pend){
      CheckOrders();
      return;
   }
   
   if(!cur && pend){
      ResetLastError();
      if(!OrderDelete(pTicket)){
         Print(__FUNCTION__," ������ �������� ������: ", GetLastError());
         return;
      }
      CheckOrders();
      Init();
   }
   if(!cur && !pend){
      Init();
   }   
}
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                           OldSameSet()                               \\
//                                                                      \\
// ������� ������������ � ������������� ��������� ��� ����, ����� ��    \\
// ����������� ������. ���� ������� ������ � �������� ��������          \\
// � �������, �� ���������� true � ����� ������ �� ������������.        \\
// ����� ��������� ������������� ����� ������������. ������ �������-    \\
// ������ �� �����.                                                     \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
bool OldSameSet(){
   if(OrdersTotal() > 0)
      
      for(int i = 0; i < OrdersTotal(); i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__," ������ ������ ������: ",GetLastError());
            return false;
         }
         if(OrderSymbol() == symbol && OrderMagicNumber() == mgc)
            return true;
      }
      
   return false;
}


///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                            SetLevels()                               \\
//                                                                      \\
// ������� ������������ � ������������� ���������, ���� OldSameSet()    \\
// ������ true (�.�. ���� ���������� ������ � ������ �� �������� �      \\
// �������)                                                             \\
// � ���� ������� ������������ ������� (level1, level2, level3, level4),\\
// � �������� ������� �������� ������ (action)                          \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void SetLevels(){
   int total = OrdersTotal();
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ������ ������ ������: ",GetLastError());
         return;
      }
      
      if(OrderSymbol() == symbol && OrderMagicNumber() == mgc){
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
         }
         
         if(OrderType() == OP_SELLSTOP){
            level2 = OrderStopLoss();
            level3 = OrderOpenPrice();
            level4 = OrderTakeProfit(); 
         }         
      }      
   }
}
//���� ��� ���� buy/sell - ������ �����-�� �������� �� ����� ���������. ���� ���, �� ��������� ��� ������
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
//                                                                      \\
//                           CheckOrders()                              \\
//                                                                      \\
// isBuy  - �������� BUY  �/��� BUYSTOP                                 \\
// isSell - �������� SELL �/��� SELLSTOP                                \\
// ticket - ����� ������, ������� ����� ������                          \\
// _lots  - ����� ���������� ��������� ������                           \\
// _price - ����, �� ������� ����� ������ �������� �����                \\
//                                                                      \\
// ���� ������� ����� ������ ������ BUY  �/��� BUYSTOP                  \\
//                      ���                                             \\
// ���� ������� ����� ������ ������ SELL �/��� SELLSTOP                 \\
//             �� ��� ������ �� ������� � ������ ���������              \\
//                                                                      \\
///////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
void CheckOrders(){
   bool isBuy = false;     //������� ��������
   bool isSell = false;    //������� ���������
   int ticket = 0;
   double _lots =  0.0;
   double _price = 0.0;
   
   int total = OrdersTotal();
   
   if (total == 0)
      return;
      
   for(int i = 0; i < total; i++){
      ResetLastError();
      if(!OrderSelect(i, SELECT_BY_POS)){
         Print(__FUNCTION__," ������ ������ ������ ��� ��������." ,GetLastError());
         return;
      }
      
      if(OrderMagicNumber() == mgc && OrderSymbol() == symbol){
         if(OrderType() == OP_BUY || OrderType() == OP_BUYSTOP)
            isBuy = true;
         if(OrderType() == OP_SELL || OrderType() == OP_SELLSTOP)
            isSell = true;
////////////////////////////////////////////////////////////////////////////////       
         if(OrderLots() == volume && OrderProfit() >= profit && profit != 0.0){
            if(OrderType() == OP_BUY){
               RefreshRates();
               _price = MarketInfo(symbol, MODE_ASK);//last.ask;
            }
            if(OrderType() == OP_SELL){
               RefreshRates();
               _price = MarketInfo(symbol, MODE_BID);//last.bid;
            }
            _lots = OrderLots();
            
            RefreshRates();
            slp = (int)((MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID))/Point());
            if(!OrderClose(OrderTicket(), OrderLots(), _price, slp)){
               Print(__FUNCTION__," ������ �������� ������. " ,GetLastError());
               return;
            }
            return;
         }
////////////////////////////////////////////////////////////////////////////////
      }
   }
   
   if((isBuy && !isSell) || (!isBuy && isSell)){
      //Print("buy = ",isBuy, "  sell = ",isSell);
      for(int i = 0; i < total; i++){
         ResetLastError();
         if(!OrderSelect(i, SELECT_BY_POS)){
            Print(__FUNCTION__," ������ ������ ������." ,GetLastError());
            return;
         }
         
         if(OrderMagicNumber() == mgc && OrderSymbol() == symbol){
            
            ticket = OrderTicket();
            if(OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP){
               if(!OrderDelete(ticket)){
                  Print(__FUNCTION__," ������ �������� ������." ,GetLastError());
                  return;
               }
            }
            
            if(OrderType() == OP_BUY || OrderType() == OP_SELL){
               if(OrderType() == OP_BUY){
                  RefreshRates();
                  _price = MarketInfo(symbol, MODE_ASK);//last.ask;
               }
               if(OrderType() == OP_SELL){
                  RefreshRates();
                  _price = MarketInfo(symbol, MODE_BID);//last.bid;
               }
               _lots = OrderLots();
               
               RefreshRates();
               slp = (int)((MarketInfo(symbol, MODE_ASK) - MarketInfo(symbol, MODE_BID))/Point());
               if(!OrderClose(ticket, _lots, _price, slp)){
                  Print(__FUNCTION__," ������ �������� ������. " ,GetLastError());
                  return;
               }
            }
         }
      }
      Init();
   }
}
   /*
  RefreshRates();
  Price[0]=MarketInfo(OrderSymbol(),MODE_ASK);
  Price[1]=MarketInfo(OrderSymbol(),MODE_BID);
  double dPoint=MarketInfo(OrderSymbol(),MODE_POINT);
  if(dPoint==0) return(false);
  giSlippage=(Price[0]-Price[1])/dPoint;
  */